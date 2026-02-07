package handlers

import (
	"fmt"
	"encoding/json"
	"net/http"
	"time"
	"database/sql"
	"calorie-tracker/internal/models"
	"calorie-tracker/internal/database"
	"calorie-tracker/internal/llm"
)

type MealRequest struct {
	Description string `json:"description"`
}

func CreateMealHandler(db *sql.DB, apiKey string) http.HandlerFunc {
	return func (w http.ResponseWriter, r *http.Request) {
		var req MealRequest

		err := json.NewDecoder(r.Body).Decode(&req)
		if err != nil {
			http.Error(w, "Invalid JSON", http.StatusBadRequest)
			return
		}

		data, err := llm.ParseMeal(apiKey, req.Description)

		if err != nil {
			http.Error(w, "LLM Failure", http.StatusInternalServerError)
			return
		}
		
		meal := models.Meal {
			Description: req.Description,
			Calories: data.Calories,
			Protein: data.Protein,
			Carbs: data.Carbs,
			Fat: data.Fat,
			Timestamp: time.Now(),
		}

		err = database.InsertMeal(db, &meal)

		if err != nil {
			fmt.Println("Error: ", err)
			http.Error(w, "Database failure", http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]string{"status": "success"})
	}
}
