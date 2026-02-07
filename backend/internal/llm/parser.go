package llm

import (
	"fmt"
	"context"
	"encoding/json"
	"strings"
	"github.com/anthropics/anthropic-sdk-go"
	"github.com/anthropics/anthropic-sdk-go/option"
)

type NutritionData struct {
	Calories int `json:"calories"`
	Protein float64 `json:"protein"` 
	Carbs float64 `json:"carbs"`
	Fat float64 `json:"fat"`
}

// trimming markdown formatting claude puts
// on json
func stripMarkdown(text string) string {
    text = strings.ReplaceAll(text, "```json", "")
    text = strings.ReplaceAll(text, "```", "")
    return strings.TrimSpace(text)
}


func ParseMeal(apiKey string, description string) (*NutritionData, error) {
	
	client := anthropic.NewClient(option.WithAPIKey(apiKey))

	message, err := client.Messages.New(context.TODO(), anthropic.MessageNewParams{
		Model: anthropic.ModelClaudeSonnet4_5_20250929,
		MaxTokens: 1024,
		System: []anthropic.TextBlockParam{
			{Text: `You are a nutritional expert. Given a meal description, estimate calories, protein (g),
			carbs (g), and fat (g). Return ONLY valid JSON in this format:
			{\"calories\": 500, \"protein\": 30.5, \"carbs\": 45.0, \"fat\": 15.2}`},
		},
		Messages: []anthropic.MessageParam{
			anthropic.NewUserMessage(anthropic.NewTextBlock(description)),
		},
	})

	if err != nil {
		return nil, err
	}

	responseText := message.Content[0].Text
	cleanJSON := stripMarkdown(responseText)

	var data NutritionData
	err = json.Unmarshal([]byte(cleanJSON), &data)

	if err != nil {
		fmt.Println("Unmarshal error", err)
		return nil, err
	}


	return &data, nil


}
