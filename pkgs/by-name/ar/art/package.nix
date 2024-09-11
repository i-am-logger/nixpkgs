{ lib
, stdenv
, fetchFromBitbucket
, cmake
, pkg-config
, util-linux
, libselinux
, libsepol
, libthai
, libdatrie
, lerc
, libxkbcommon
, libepoxy
, libXtst
, wrapGAppsHook3
, makeWrapper
, pixman
, libpthreadstubs
, gtkmm3
, libXau
, libXdmcp
, lcms2
, libraw
, libiptcdata
, fftw
, expat
, pcre2
, libsigcxx
, lensfun
, librsvg
, libcanberra-gtk3
, exiv2
, exiftool
, mimalloc
, openexr_3
, ilmbase
, opencolorio
, color-transformation-language
}:

stdenv.mkDerivation rec {
  pname = "art";
  version = "1.23";

  src = fetchFromBitbucket {
    owner = "agriggio";
    repo = "art";
    rev = version;
    hash = "sha256-OB/Rr4rHNJc40o6esNPDRbhN4EPGf2zhlzzM+mBpUUU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    lerc
    libxkbcommon
    libepoxy
    libXtst
    pixman
    libpthreadstubs
    gtkmm3
    libXau
    libXdmcp
    lcms2
    libraw
    libiptcdata
    fftw
    expat
    pcre2
    libsigcxx
    lensfun
    librsvg
    exiv2
    exiftool
    libcanberra-gtk3
    mimalloc
    openexr_3
    ilmbase
    opencolorio
    color-transformation-language
  ];

  cmakeFlags = [
    "-DPROC_TARGET_NUMBER=2"
    "-DCACHE_NAME_SUFFIX=\"\""
    "-DENABLE_OCIO=True"
    "-DENABLE_CTL=1"
    "-DCTL_INCLUDE_DIR=${color-transformation-language}/include/CTL"
  ];

  CMAKE_CXX_FLAGS = toString [
    "-std=c++11"
    "-Wno-deprecated-declarations"
    "-Wno-unused-result"
  ];
  env.CXXFLAGS = "-include cstdint"; # needed at least with gcc13 on aarch64-linux

  meta = {
    description = "A raw converter based on RawTherapee";
    homepage = "https://bitbucket.org/agriggio/art/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "art";
    platforms = lib.platforms.linux;
  };
}
