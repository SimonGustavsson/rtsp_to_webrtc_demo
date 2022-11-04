with import <nixpkgs> {};
let
  libsrtp2 = callPackage ./libsrtp2.nix {};

  inputs = [
    ffmpeg-full
    clang-tools
    srtp
    pkg-config

    libsrtp2
    openssl

    elixir
  ];

  hooks = ''
    # this allows mix to work on the local directory
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export LANG=en_US.UTF-8
    export ERL_AFLAGS="-kernel shell_history enabled"
    export PATH="$PWD/node_modules/.bin/:$PATH"
  '';

in mkShell {
  buildInputs = inputs;
  shellHook = hooks;
}
