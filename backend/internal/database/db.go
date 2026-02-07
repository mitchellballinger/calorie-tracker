package database

import (
	"database/sql"
	_ "github.com/mattn/go-sqlite3"
	"calorie-tracker/internal/models"
)


func InitDB() (*sql.DB, error) {
	db, err := sql.Open("sqlite3", "./calorie-tracker.db")

	if err != nil {
		return nil, err
	}

	_, err = db.Exec(`CREATE TABLE IF NOT EXISTS meals (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		description TEXT,
		calories INTEGER,
		protein REAL,
		carbs REAL,
		fat REAL,
		timestamp DATETIME
	)`)

	if err != nil {
		return nil, err
	}

	return db, nil
}

func InsertMeal(db *sql.DB, meal *models.Meal) (error) {

	_, err := db.Exec(`INSERT INTO meals
	(description, calories, protein, carbs, fat, timestamp)
	VALUES (?, ?, ?, ?, ?, ?)`, meal.Description, meal.Calories,
	meal.Protein, meal.Carbs, meal.Fat, meal.Timestamp)

	if err != nil {
		return err
	}

	return nil
}

