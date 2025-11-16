[![Build Status](https://github.com/tischda/servexml/actions/workflows/build.yml/badge.svg)](https://github.com/tischda/servexml/actions/workflows/build.yml)
[![Test Status](https://github.com/tischda/servexml/actions/workflows/test.yml/badge.svg)](https://github.com/tischda/servexml/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/tischda/servexml/badge.svg)](https://coveralls.io/r/tischda/servexml)
[![Linter Status](https://github.com/tischda/servexml/actions/workflows/linter.yml/badge.svg)](https://github.com/tischda/servexml/actions/workflows/linter.yml)
[![License](https://img.shields.io/github/license/tischda/servexml)](/LICENSE)
[![Release](https://img.shields.io/github/release/tischda/servexml.svg)](https://github.com/tischda/servexml/releases/latest)

# servexml

Starts a web server that returns dummy XML content for `mclupdater.exe` to work.
My Channel Logos (MCL) updates channel logos for Windows Media Center.

## Install

~~~
go install github.com/tischda/servexml@latest
~~~

## Usage

```
Usage: servexml [OPTIONS]

Starts a web server that returns dummy XML content.

OPTIONS:

  -r, --requests int (mandatory)
        number of requests before shutdown
  -p, --port int (default: 80)
        port number to listen on
  -?, --help
        display this help message
  -v, --version
        print version and exit

EXAMPLES:

  $ servexml --requests 2 --port 8080
  Starting server on :8080
```

## Configuration

You need to update MCL settings to activate automatic logo updates.

You need to add this to your hosts file:
```
127.0.0.1    files.mychannellogos.com
```

To start the server:
```
servexml.exe --requests 2
```

To stop the server:
```
curl http://localhost/?SHUTDOWN=true
```
