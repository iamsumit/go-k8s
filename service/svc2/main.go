package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

func main() {
	router := http.NewServeMux()

	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		msg, _ := json.Marshal(
			map[string]string{
				"message": "Hello from service 2",
			},
		)
		fmt.Fprintf(w, "%s", msg)
	})

	svc1Endpoint := os.Getenv("SVC1_ENDPOINT")

	router.HandleFunc("/svc1", func(w http.ResponseWriter, r *http.Request) {
		resp, err := http.Get(svc1Endpoint)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer resp.Body.Close()

		var data map[string]string
		if err := json.NewDecoder(resp.Body).Decode(&data); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		msg, _ := json.Marshal(
			map[string]string{
				"message": data["message"],
			},
		)
		fmt.Fprintf(w, "%s", msg)
	})

	fmt.Println("Service 2 is running on port 8080")
	http.ListenAndServe(":8080", router)
}
