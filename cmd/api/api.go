package main

import (
	"flag"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"time"

	conf "github.com/ironpeakservices/chart-iron-go/config"
)

type Handler struct{}

func (Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	_, _ = w.Write([]byte("hello world!"))
}

func main() {
	rand.Seed(time.Now().UTC().UnixNano())

	configPath := flag.String("config", conf.DefaultConfigPath, "Path to the config file.")
	flag.Parse()

	config, err := conf.LoadConfig(*configPath)
	if err != nil {
		log.Fatalf("could not read config: %+v", err)
	}

	srv := &http.Server{
		Addr:         fmt.Sprintf("%s:%d", config.ListenHost, config.ListenPort),
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  120 * time.Second,
		TLSConfig:    nil,
		Handler:      Handler{},
	}

	log.Printf("web server listening on %s:%d", config.ListenHost, config.ListenPort)
	log.Fatal(srv.ListenAndServe())
}
