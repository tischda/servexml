package main

import (
	"fmt"
	"log"
	"net/http"
)

// Starts a web server that returns dummy XML content for mclupdater.exe to work.
// Stop the server with `curl localhost?SHUTDOWN=true` or set a request limit
func serve(cfg *Config) {
	numRequests := 0

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Query().Get("SHUTDOWN") == "true" {
			log.Println(SHUTDOWN_REQUEST)
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(SHUTDOWN_REQUEST))
			shutdownChan <- true
			return
		}
		// Set response header
		w.Header().Set("Content-Type", "application/xml")
		w.WriteHeader(http.StatusOK)

		// Write an empty XML document
		_, err := w.Write([]byte("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root></root>"))
		if err != nil {
			log.Printf("Error writing response: %v", err)
		}

		if cfg.requests > 0 {
			numRequests++
			if numRequests >= cfg.requests {
				log.Println(REQUEST_LIMIT_REACHED)
				shutdownChan <- true
			}
		}
	})

	go func() {
		addr := fmt.Sprintf(":%d", cfg.port)
		log.Printf("Starting server on %s", addr)
		if err := http.ListenAndServe(addr, nil); err != nil {
			log.Printf("Server failed to start: %v", err)
		}
	}()

	<-shutdownChan
	log.Println("Server has been stopped.")
}
