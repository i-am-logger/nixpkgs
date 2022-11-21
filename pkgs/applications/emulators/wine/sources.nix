{ pkgs ? import <nixpkgs> {} }:
## we default to importing <nixpkgs> here, so that you can use
## a simple shell command to insert new sha256's into this file
## e.g. with emacs C-u M-x shell-command
##
##     nix-prefetch-url sources.nix -A {stable{,.mono,.gecko64,.gecko32}, unstable, staging, winetricks}

# here we wrap fetchurl and fetchFromGitHub, in order to be able to pass additional args around it
let fetchurl = args@{url, sha256, ...}:
  pkgs.fetchurl { inherit url sha256; } // args;
    fetchFromGitHub = args@{owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev sha256; } // args;
    fetchFromGitLab = args@{domain, owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitLab { inherit domain owner repo rev sha256; } // args;
in rec {

  stable = fetchurl rec {
    version = "7.0";
    url = "https://dl.winehq.org/wine/source/7.0/wine-${version}.tar.xz";
    sha256 = "sha256-W0PifVwIXLGPlzlORhgDENXu98HZHGiVQyo4ibLeCGs=";

    ## see http://wiki.winehq.org/Gecko
    gecko32 = fetchurl rec {
      version = "2.47.3";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86.msi";
      sha256 = "sha256-5bmwbTzjVWRqjS5y4ETjfh4MjRhGTrGYWtzRh6f0jgE=";
    };
    gecko64 = fetchurl rec {
      version = "2.47.3";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86_64.msi";
      sha256 = "sha256-pT7pVDkrbR/j1oVF9uTiqXr7yNyLA6i0QzSVRc4TlnU=";
    };

    ## see http://wiki.winehq.org/Mono
    mono = fetchurl rec {
      version = "7.0.0";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      sha256 = "sha256-s35vyeWQ5YIkPcJdcqX8wzDDp5cN/cmKeoHSOEW6iQA=";
    };

    patches = [
      # Also look for root certificates at $NIX_SSL_CERT_FILE
      ./cert-path.patch
    ];
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "7.20";
    url = "https://dl.winehq.org/wine/source/7.x/wine-${version}.tar.xz";
    sha256 = "sha256-dRt58itan3LJ7BX3VbALE9PtBz6RaMPvStq9nbN9DVA=";
    inherit (stable) gecko32 gecko64 patches;

    mono = fetchurl rec {
      version = "7.4.0";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      sha256 = "sha256-ZBP/Mo679+x2icZI/rNUbYEC3thlB50fvwMxsUs6sOw=";
    };
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-staging/wine-staging/releases
    inherit (unstable) version;
    sha256 = "sha256-yzZE06FBoPL65+m8MrKlmW5cSIcX3dZYAOY9wjEJaJw=";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";

    disabledPatchsets = [ ];
  };

  wayland = fetchFromGitLab rec {
    # https://gitlab.collabora.com/alf/wine/-/tree/wayland
    version = "7.20";
    sha256 = "sha256-UrukAnlfrr6eeVwFSEOWSVSfyMHbMT1o1tfXxow61xY=";
    domain = "gitlab.collabora.com";
    owner = "alf";
    repo = "wine";
    rev = "1dc9821ef0b6109c74d0c95cd5418caf7f9feaf1";

    inherit (unstable) gecko32 gecko64;

    inherit (unstable) mono;
  };

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20220411";
    sha256 = "sha256-FjH10nZDYbqXI6/vKpZJKfv2maXSVkahNDf5UTU3eyU=";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };
}
