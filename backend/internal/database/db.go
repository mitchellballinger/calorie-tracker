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

	result, err := db.Exec(`INSERT INTO meals
	(description, calories, protein, carbs, fat, timestamp)
	VALUES (?, ?, ?, ?, ?, ?)`, meal.Description, meal.Calories,
	meal.Protein, meal.Carbs, meal.Fat, meal.Timestamp)
	
	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	meal.ID = int(id)

	return nil
}

func GetMeals(db *sql.DB) ([]models.Meal, error) {
	rows, err := db.Query(`SELECT id, description, calories, 
	protein, carbs, fat, timestamp FROM meals`)
	
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var meals []models.Meal

	for rows.Next() {
		var meal models.Meal
		
		err = rows.Scan(&meal.ID, &meal.Description, &meal.Calories,
		&meal.Protein, &meal.Carbs, &meal.Fat, &meal.Timestamp)

		if err != nil {
			return nil, err
		}

		meals = append(meals, meal)
	}

	err = rows.Err()

	if err != nil {
		return nil, err
	}

	return meals, nil

}

