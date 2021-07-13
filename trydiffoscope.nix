{ lib
, fetchFromGitLab
, python3Packages
, which
}:

with python3Packages;

let
  version = "67.0.5";
in
buildPythonApplication {
  pname = "trydiffoscope";
  inherit version;

  patchPhase =
    let
      escapePath = path: builtins.replaceStrings ["/"] ["\\/"] (toString path);
    in
      ''
        ls
        sed -i 's/\/usr\/bin\/env/'"$(which env | sed 's/\//\\\//gm')"'/' setup.py
      '';

  nativeBuildInputs = [ which ];

  propagatedBuildInputs = [ requests ];

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "reproducible-builds";
    repo = "trydiffoscope";
    rev = "67.0.5";
    sha256 = "sha256-tz2oHnZSxns5ol/qg+EBo1q08o5jm1lD7Tnyv5EMWts=";
  };
}
