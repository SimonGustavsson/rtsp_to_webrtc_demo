defmodule RtspToWebRTC.Pipeline do
  use Membrane.Pipeline
  require Logger

  alias RtspToWebRTC.ConnectionManager

  @impl true
  def handle_init(options) do
    Logger.info("Source handle_init options: #{inspect(options)}")

    connection_manager_spec = [
      %{
        id: "ConnectionManager",
        start:
          {ConnectionManager, :start_link,
           [
             [
               stream_url: options.stream_url,
               port: options.port,
               pipeline: self()
             ]
           ]},
        restart: :transient
      }
    ]

    Supervisor.start_link(connection_manager_spec,
      strategy: :one_for_one,
      name: RtspToWebRTC.Supervisor
    )

    {:ok, %{video: nil, port: options.port}}
  end

  @impl true
  def handle_other({:rtsp_setup_complete, options}, _ctx, state) do
    Logger.info("Source received pipeline options: #{inspect(options)}")

    webrtc_ref = Pad.ref(:input, make_ref())
    {_, _, webrtc_ref_id} = webrtc_ref

    rtc_endpoint = %Membrane.WebRTC.EndpointBin{
      direction: :sendonly,
      outbound_tracks: [
        %Membrane.WebRTC.Track{
          type: :video,
          stream_id: Membrane.WebRTC.Track.stream_id(),
          id: webrtc_ref_id,
          encoding: :H264,
          name: "Example Name",
          mid: "",
          rids: nil,
          rtp_mapping: %ExSDP.Attribute.RTPMapping{
            payload_type: 97,
            encoding: "h264-1998",
            clock_rate: 90_000
          },
          fmtp: [],
          status: :ready,
          extmaps: []
        }
      ]
    }

    rtc_engine_options = [
      id: "Test Room"
    ]

    {:ok, pid} = Membrane.RTC.Engine.start(rtc_engine_options, [])

    Membrane.RTC.Engine.register(pid, self())
    Process.monitor(pid)

    Membrane.RTC.Engine.add_endpoint(pid, rtc_endpoint)

    children = %{
      app_source: %Membrane.UDP.Source{
        local_port_no: state[:port],
        recv_buffer_size: 500_000
      },
      rtp: %Membrane.RTP.SessionBin{
        fmt_mapping: %{97 => {:H264, 90_000}}
      },
      webrtc: rtc_endpoint
    }

    rtp_ref = make_ref()
    rtp_output_ref = Pad.ref(:rtp_output, rtp_ref)
    rtp_input_ref = Pad.ref(:rtp_input, rtp_ref)

    links = [
      link(:app_source)
      |> via_in(rtp_input_ref)
      |> to(:rtp)
      |> via_out(rtp_output_ref)
      |> via_in(webrtc_ref)
      |> to(:webrtc)
    ]

    spec = %ParentSpec{children: children, links: links}
    {{:ok, spec: spec}, %{state | video: %{sps: options[:sps], pps: options[:pps]}}}
  end
end
