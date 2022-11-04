defmodule RtspToWebRTC.MixProject do
  use Mix.Project

  def project do
    [
      app: :rtsp_to_webrtc_demo,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {RtspToWebRTC, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:connection, "~> 1.1"},
      {:membrane_core, "~> 0.10"},
      {:membrane_rtsp, "~> 0.3"},
      {:membrane_udp_plugin, "~> 0.8"},
      {:membrane_rtp_plugin, "~> 0.14"},
      {:membrane_rtc_engine, "~> 0.6.0"},
      {:membrane_rtp_h264_plugin, "~> 0.13"},
      {:membrane_h264_ffmpeg_plugin, "~> 0.21"},
      {:membrane_webrtc_plugin, "~> 0.8.0"},
      {:fast_tls, "~> 1.1.13"}
    ]
  end
end
