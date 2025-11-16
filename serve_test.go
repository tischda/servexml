//go:build windows

package main

import (
	"fmt"
	"net/http"
	"testing"
	"time"
)

func TestServe(t *testing.T) {
	cfg := &Config{
		requests: 1,
		port:     8080,
	}

	done := make(chan bool)
	go func() {
		serve(cfg)
		done <- true
	}()

	time.Sleep(500 * time.Millisecond)

	addr := fmt.Sprintf("http://127.0.0.1:%d", cfg.port)
	resp, err := http.Get(addr)
	if err != nil {
		t.Errorf("Request failed: %v", err)
	} else {
		resp.Body.Close()
	}

	select {
	case <-done:
		t.Log("Server shut down successfully after 1 request")
	case <-time.After(3 * time.Second):
		t.Error("Server did not shutdown within timeout")
	}
}
