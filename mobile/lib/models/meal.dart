class Meal {
	final int id;
	final String description;
	final int calories;
	final double protein;
	final double carbs;
	final double fat;
	final DateTime timestamp;
	

	Meal({
		required this.id,
		required this.description,
		required this.calories,
		required this.protein,
		required this.carbs,
		required this.fat,
		required this.timestamp,
	});

	factory Meal.fromJson(Map<String, dynamic> json) {
		return Meal(
			id: json['id'] ?? 0,
			description: json['description'],
			calories: json['calories'],
			protein: (json['protein'] as num).toDouble(),
			carbs: (json['carbs'] as num).toDouble(),
			fat: (json['fat'] as num).toDouble(),
			timestamp: DateTime.parse(json['timestamp']),
		);
	}



}
