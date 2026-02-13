package models

import "time"

type Meal struct {
	ID int `json:"id"`
	Description string `json:"description"`
	Calories int `json:"calories"`
	Protein float64 `json:"protein"`
	Carbs float64 `json:"carbs"`
	Fat float64 `json:"fat"`
	Timestamp time.Time `json:"timestamp"` 
}


func (m Meal) IsToday() bool {
	now := time.Now()
	return m.Timestamp.Year() == now.Year() &&
	m.Timestamp.Month() == now.Month() &&
	m.Timestamp.Day() == now.Day()
}


