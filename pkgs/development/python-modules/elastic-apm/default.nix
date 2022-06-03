{ lib
, asynctest
, aiohttp
, blinker
, buildPythonPackage
, certifi
, ecs-logging
, fetchFromGitHub
, fetchpatch
, httpx
, jinja2
, jsonschema
, Logbook
, mock
, pytest-asyncio
, pytest-bdd
, pytest-localserver
, pytest-mock
, pytestCheckHook
, pythonOlder
, sanic
, sanic-testing
, starlette
, structlog
, tornado
, urllib3
, webob
}:

buildPythonPackage rec {
  pname = "elastic-apm";
  version = "6.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "apm-agent-python";
    rev = "v${version}";
    sha256 = "sha256-IaCl39rhsFLQwvQdPcqKruV/Mo3f7WH91UVgMG/cnOc=";
  };

  patches = [
    (fetchpatch {
      # fix tests with sanic>=22.3.0
      url = "https://github.com/elastic/apm-agent-python/commit/114ee6ca998b4d6a5cb075a289af39cb963cf08a.patch";
      hash = "sha256-M6yEHjThKDCRQOmR0L94KEt8tUun1tPRULI6PNIlE/8=";
    })
  ];

  propagatedBuildInputs = [
    aiohttp
    blinker
    certifi
    sanic
    starlette
    tornado
    urllib3
  ];

  checkInputs = [
    asynctest
    ecs-logging
    jinja2
    jsonschema
    Logbook
    mock
    httpx
    pytest-asyncio
    pytest-bdd
    pytest-mock
    pytest-localserver
    sanic-testing
    pytestCheckHook
    structlog
    webob
  ];

  disabledTests = [
    "elasticapm_client"
  ];

  disabledTestPaths = [
    # Exclude tornado tests
    "tests/contrib/asyncio/tornado/tornado_tests.py"
  ];

  pythonImportsCheck = [
    "elasticapm"
  ];

  meta = with lib; {
    description = "Python agent for the Elastic APM";
    homepage = "https://github.com/elastic/apm-agent-python";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
