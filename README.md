[![Build Status](https://github.com/tischda/servexml/actions/workflows/build.yml/badge.svg)](https://github.com/tischda/servexml/actions/workflows/build.yml)
[![Test Status](https://github.com/tischda/servexml/actions/workflows/test.yml/badge.svg)](https://github.com/tischda/servexml/actions/workflows/test.yml)
[![Go Report Card](https://goreportcard.com/badge/github.com/tischda/servexml)](https://goreportcard.com/report/github.com/tischda/servexml)

# servexml

Starts a web server that returns dummy XML content for `mclupdater.exe` to work.

### Install

~~~
go install github.com/tischda/servexml@latest
~~~

### Usage

You need to update MCL settings to activate automatic logo updates.

You need to add this to your hosts file:
```
127.0.0.1    files.mychannellogos.com
```

To start the server:
```
servexml.exe
```

To stop the server:
```
curl http://localhost/?SHUTDOWN=true
```
