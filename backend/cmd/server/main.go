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
	err = http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}
}
