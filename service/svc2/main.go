package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
)

func main() {
	router := http.NewServeMux()

	router.HandleFunc("/", homeHandler)

	svc1Endpoint := os.Getenv("SVC1_ENDPOINT")
	router.HandleFunc("/svc1", svc1Handler(svc1Endpoint))

	router.HandleFunc("/file", fileHandler)
	router.HandleFunc("/file/{name}", readFileHandler)

	fmt.Println("Service 2 is running on port 8080")
	http.ListenAndServe(":8080", router)
}

func homeHandler(w http.ResponseWriter, r *http.Request) {
	msg, _ := json.Marshal(
		map[string]string{
			"message": "Hello from service 2",
		},
	)
	fmt.Fprintf(w, "%s", msg)
}

func svc1Handler(svc1Endpoint string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
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
	}
}

func fileHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	name := r.FormValue("name")
	if name == "" {
		http.Error(w, "name is required", http.StatusBadRequest)
		return
	}

	content := r.FormValue("content")
	if content == "" {
		content = name + " content"
	}

	dir := os.Getenv("SVC2_FILES_DIR")

	err := os.Mkdir(dir, 0755)
	if err != nil && !os.IsExist(err) {
		log.Println("Dir write error:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	name = filepath.Join(dir, name)

	err = os.WriteFile(name, []byte(content), 0644)
	if err != nil {
		log.Println("File write error:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	data := map[string]string{
		"message": "File created",
		"content": content,
	}

	log.Println("File write success!")

	res, _ := json.Marshal(data)

	fmt.Fprintf(w, "%s", res)
}

func readFileHandler(w http.ResponseWriter, r *http.Request) {
	name := r.PathValue("name")
	if name == "" {
		http.Error(w, "name is required", http.StatusBadRequest)
		return
	}

	dir := os.Getenv("SVC2_FILES_DIR")
	name = filepath.Join(dir, name)
	// @todo: read file not working. fix it.
	data, err := os.ReadFile(name)
	if err != nil {
		log.Println("File read error:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	log.Println("File content:", string(data))

	res, _ := json.Marshal(map[string]string{
		"content": string(data),
	})
	fmt.Fprintf(w, "%s", res)
}
