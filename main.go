package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	sig := make(chan os.Signal, 1)
	serr := make(chan error, 1)

	// Handle the signal
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)

	router := http.NewServeMux()

	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello, World!"))
	})

	router.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello!"))
	})

	server := &http.Server{
		Addr:    ":8080",
		Handler: router,
	}

	go func() {
		fmt.Println("Starting server on port 8080")
		if err := server.ListenAndServe(); err != nil {
			serr <- err
		}
	}()

	select {
	case err := <-serr:
		fmt.Println("Server error: ", err)
	case <-sig:
		server.Shutdown(context.Background())
		fmt.Println("Signal received, shutting down...")
	}
}
