defmodule RtspToWebRTC do
  use Application

  require Logger

  def start(_, _) do
    RtspToWebRTC.Pipeline.start_link(%{
      stream_url: "rtsp://192.168.1.12:7447/",
      port: 7447
    })
  end
end
