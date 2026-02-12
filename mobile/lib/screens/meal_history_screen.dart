import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';


class MealHistoryScreen extends StatefulWidget {
	const MealHistoryScreen({Key? key}) : super(key: key);

	@override
	State<MealHistoryScreen> createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState() extends State<MealHistoryScreen> {
	final ApiService() _apiService = ApiService();
	String _statusMessage = '';
	bool _isLoading = false;
	List<Meal?> _mealList;


	@override
	void dispose() {
		super.dispose()
	}

	Future<void> _retrieveMeals() async {
		
		setState(() {
			_isLoading = true;
			_statusMessage = '';
			_mealList = null;
		})


		try {
			// need to call out to get meals
		}
		catch (e) {
			setState(() => _statusMessage = 'Failed to connect to server: $e')
		}
		finally {
			setState(() => _isLoading = false)
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('History'),
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
		)
	}
}
