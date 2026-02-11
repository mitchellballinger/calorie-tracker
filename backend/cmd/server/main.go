package main

import (
	"fmt"
	"log"
	"net/http"
	"calorie-tracker/internal/database"
	"calorie-tracker/internal/handlers"
	"github.com/joho/godotenv"
	"os"
)

func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}

func main() {
	fmt.Println("Server starting...")
	db, err := database.InitDB()

	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	err = godotenv.Load()
	if err != nil {
		log.Fatal("Error loading api key")
	}

	apiKey := os.Getenv("API_KEY")

	http.HandleFunc("/meal", handlers.CreateMealHandler(db, apiKey))
	fmt.Println("Calling listen and serve")
	err = http.ListenAndServe(":8080", corsMiddleware(http.DefaultServeMux))
	if err != nil {
		log.Fatal(err)
	}
}
