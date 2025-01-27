package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
)

// go build -ldflags=all="-X main.version=${BUILD_TAG} -s -w"
var version string
var showVersion bool

var shutdownChan = make(chan bool)

const SHUTDOWN_MESSAGE = "Shutdown request received. Stopping server..."

func init() {
	flag.BoolVar(&showVersion, "version", false, "print version and exit")
}

func main() {
	flag.Parse()
	if showVersion {
		fmt.Println("servexml version", version)
	} else {
		serve()
	}
}

// Starts a web server that returns dummy XML content for mclupdater.exe to work.
// Stop the server with `curl localhost?SHUTDOWN=true`
func serve() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Query().Get("SHUTDOWN") == "true" {
			log.Println(SHUTDOWN_MESSAGE)
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(SHUTDOWN_MESSAGE))
			shutdownChan <- true
			return
		}
		// Set the Content-Type header to application/xml
		w.Header().Set("Content-Type", "application/xml")
		w.WriteHeader(http.StatusOK)

		// Write an empty XML document
		_, err := w.Write([]byte("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root></root>"))
		if err != nil {
			log.Printf("Error writing response: %v", err)
		}
	})

	go func() {
		log.Println("Starting server on :80")
		if err := http.ListenAndServe(":80", nil); err != nil {
			log.Fatalf("Server failed to start: %v", err)
		}
	}()

	<-shutdownChan
	log.Println("Server has been stopped.")
}
