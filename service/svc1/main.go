package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

func main() {
	router := http.NewServeMux()

	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		msg, _ := json.Marshal(
			map[string]string{
				"message": "Hello from service 1",
			},
		)
		fmt.Fprintf(w, "%s", msg)
	})

	fmt.Println("Service 1 is running on port 8080")
	http.ListenAndServe(":8080", router)
}
