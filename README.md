# !This is work in progress and might not work!

# Rtsp To WebRTC

An demo application streaming RTSP to WebRTC using the [Membrane Framework](https://membrane.stream/).

## HTTPS
This application uses HTTPS, so to run it you'll need a certificate and key. You can generate them with:

```
openssl req -newkey rsa:2048 -nodes -keyout priv/certs/key.pem -x509 -days 365 -out priv/certs/certificate.pem
```

Note that this certificate is not validated and thus may cause warnings in your web browser.

## Usage

This demo was created to work with the [Nix](https://nixos.org/) package manager but should work in other environments as well with the right dependencies installed (see a list of dependencies in [shell.nix](./shell.nix)).

Before running, set the URL to the RTSP stream in [rtsp_to_webrtc.ex](./lib/rtsp_to_webrtc.ex) then run:

```
nix-shell
iex -S mix
```
