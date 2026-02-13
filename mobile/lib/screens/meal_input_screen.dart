import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';

class MealInputScreen extends StatefulWidget {
	const MealInputScreen({Key? key}) : super(key: key);

	@override
	State<MealInputScreen> createState() => _MealInputScreenState();
}

class _MealInputScreenState extends State<MealInputScreen> {
	final TextEditingController _mealController = TextEditingController();
	final ApiService _apiService = ApiService();
	String _statusMessage = '';
	bool _isLoading = false;
	Meal? _meal;

	@override
	void dispose() {
		_mealController.dispose();
		super.dispose();
	}


	Future<void> _submitMeal() async {
		final description = _mealController.text.trim();
		if (description.isEmpty) {
			setState(() => _statusMessage = 'Please enter a meal description.');
			return;
		}

		setState(() {
			_isLoading = true;
			_statusMessage = '';
			_meal = null;
		});

		try {
			final meal = await _apiService.submitMeal(description);
			setState(() => _meal = meal);
			_mealController.clear();
		}
		catch (e) {
			setState(() => _statusMessage = 'Failed to connect to server: $e');
		} 
		finally {
			setState(() => _isLoading = false);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Add Meal'),
				actions: [
					IconButton(
						icon: const Icon(Icons.history),
						onPressed: () => Navigator.pushNamed(context, '/meal-history'),
					)
				]
		  ),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
					child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
					TextField(
						controller: _mealController,
						decoration: const InputDecoration(
							labelText: 'Meal Description',
							hintText: 'e.g., chicken breast with rice',
							border: OutlineInputBorder(),
						),
						maxLines: 3,
					),
					const SizedBox(height: 16),
					ElevatedButton(
						onPressed: _isLoading ? null : _submitMeal,
						child: _isLoading
						? const CircularProgressIndicator(color: Colors.white)
						: const Text('Submit Meal'),
					),
					if (_meal != null) ...[
						const SizedBox(height: 16),
						Card(
							child: Padding(
								padding: const EdgeInsets.all(16.0),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(_meal!.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
										const SizedBox(height: 8),
										Text('Calories: ${_meal!.calories}'),
										Text('Protein: ${_meal!.protein}g'),
										Text('Carbs: ${_meal!.carbs}g'),
										Text('Fat: ${_meal!.fat}g'),
									],
								),	
							),
						),
					] 
					else
						Text(_statusMessage),
					],
				),
			),
		);
	}
}
