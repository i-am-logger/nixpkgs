{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, sphinx
, pytestCheckHook
}:

let
  pname = "sphinx-autodoc-typehints";
  version = "1.19.4";
in

buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "sphinx_autodoc_typehints";
    inherit version;
    hash = "sha256-/9jnEPZ1dHG1yDHH7OiPUqn/FfJ4NvTvHIaVpk+NzKg=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # requires spobjinv, nbtyping
  doCheck = false;

  pythonImportsCheck = [
    "sphinx_autodoc_typehints"
  ];

  meta = with lib; {
    description = "Type hints (PEP 484) support for the Sphinx autodoc extension";
    homepage = "https://github.com/tox-dev/sphinx-autodoc-typehints";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
