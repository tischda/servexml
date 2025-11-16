package main

import (
	"flag"
	"fmt"
	"log"
	"os"
)

// https://goreleaser.com/cookbooks/using-main.version/
var (
	name    string
	version string
	date    string
	commit  string
)

// flags
type Config struct {
	requests int
	port     int
	help     bool
	version  bool
}

func initFlags() *Config {
	cfg := &Config{}
	flag.IntVar(&cfg.requests, "r", 0, "")
	flag.IntVar(&cfg.requests, "requests", 0, "number of requests before shutdown")
	flag.IntVar(&cfg.port, "p", 80, "")
	flag.IntVar(&cfg.port, "port", 80, "port number to listen on")
	flag.BoolVar(&cfg.help, "?", false, "")
	flag.BoolVar(&cfg.help, "help", false, "displays this help message")
	flag.BoolVar(&cfg.version, "v", false, "")
	flag.BoolVar(&cfg.version, "version", false, "print version and exit")
	return cfg
}

const SHUTDOWN_REQUEST = "Shutdown request received. Stopping server..."
const REQUEST_LIMIT_REACHED = "Request limit reached. Stopping server..."

var shutdownChan = make(chan bool)

func main() {
	log.SetFlags(0)
	cfg := initFlags()
	flag.Usage = func() {
		fmt.Fprintln(os.Stderr, "Usage: "+name+` [OPTIONS]

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

EXAMPLES:`)

		fmt.Fprintln(os.Stderr, "\n  $ "+name+` --requests 2 --port 8080
  Starting server on :8080`)
	}
	flag.Parse()

	if flag.Arg(0) == "version" || cfg.version {
		fmt.Printf("%s %s, built on %s (commit: %s)\n", name, version, date, commit)
		return
	}

	if cfg.help {
		flag.Usage()
		return
	}

	if len(os.Args) < 2 {
		flag.Usage()
		os.Exit(1)
	}
	serve(cfg)
}
