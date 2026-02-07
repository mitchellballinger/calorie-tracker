package models

import "time"

type Meal struct {
	ID int
	Description string
	Calories int
	Protein float64
	Carbs float64
	Fat float64
	Timestamp time.Time
}


func (m Meal) IsToday() bool {
	now := time.Now()
	return m.Timestamp.Year() == now.Year() &&
	m.Timestamp.Month() == now.Month() &&
	m.Timestamp.Day() == now.Day()
}


