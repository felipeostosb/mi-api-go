 package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
)

func main() {
	// Define el handler para nuestro endpoint
	http.HandleFunc("/", statusHandler)

	// Google Cloud Run nos da el puerto a través de una variable de entorno
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // Puerto por defecto para pruebas locales
	}

	log.Printf("Iniciando servidor en el puerto %s...", port)
	// Inicia el servidor
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

// statusHandler escribe la respuesta JSON
func statusHandler(w http.ResponseWriter, r *http.Request) {
	// Prepara la respuesta
	response := map[string]string{"status": "La ejecución ha comenzado."}

	// Establece el header para indicar que la respuesta es JSON
	w.Header().Set("Content-Type", "application/json")

	// Codifica y envía la respuesta
	json.NewEncoder(w).Encode(response)
}
