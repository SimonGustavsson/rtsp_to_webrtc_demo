{ stdenv, pkgs ? import <nixpkgs> {} }:

stdenv.mkDerivation rec {
  name = "libsrtp-${version}";
  version = "2.4.2";
  src = builtins.fetchGit {
    url = "https://github.com/cisco/libsrtp.git";
    ref = "main";
  };

  nativeBuildInputs = with pkgs; [ cmake gcc ];

  meta = {
    description = "Whatever...";
    homepage = https://github.com/cisco/libsrtp;
  };
}
