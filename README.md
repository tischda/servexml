# servexml [![Build status](https://ci.appveyor.com/api/projects/status/toidj9bpnna2542w?svg=true)](https://ci.appveyor.com/project/tischda/servexml)

servexml starts a web server that returns dummy XML content for mclupdater.exe to work.

### Install

~~~
go get github.com/tischda/servexml
~~~

### Usage

you need to update MCL settings to activate automatic logo updates

you need to add this to your hosts file:
```
127.0.0.1    files.mychannellogos.com
```

to start the server:
```
servexml.exe
```

to stop the server
```
curl http://localhost/?SHUTDOWN=true
```
