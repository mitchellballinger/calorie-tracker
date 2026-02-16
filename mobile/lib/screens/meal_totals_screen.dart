import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';

class MealTotalsScreen extends StatefulWidget {
	const MealTotalsScreen({Key? key}) : super(key: key);

	@override
	State<MealTotalsScreen> createState() => _MealTotalsScreenState();
}

class _MealTotalsScreenState extends State<MealTotalsScreen> {
	final ApiService _apiService = ApiService();
	String _statusMessage = '';
	bool _isLoading = false;
	int _calorieTotal = 0;
	double _proteinTotal = 0;
	double _carbsTotal = 0;
	double _fatTotal = 0;

	@override
	void initState() {
		super.initState();
		_retrieveMeals();
	}

	@override
	void dispose() {
		super.dispose();
	}

	Future<void> _retrieveMeals() async {
		setState(() {
			_isLoading = true;
			_statusMessage = '';
			_calorieTotal = 0;
			_proteinTotal = 0;
			_carbsTotal = 0;
			_fatTotal = 0;
		});


		try {
			// just passing in currentDate for get meals, will refine later to be able
			// to select all meals from different time periods
			// need to add cached date, so if passed in date differs from cached date,
			// we can force refresh
			final meals = await _apiService.getMeals();
			_calculateTotals(meals);
		}
		catch (e) {
			setState(() => _statusMessage = 'Failed to connect to server: $e');
		}
		finally {
			setState(() => _isLoading = false);
		}

	}

	void _calculateTotals(List<Meal>? meals) {
		if (meals == null || meals.isEmpty) return;

		setState(() {
			_calorieTotal = meals.fold(0, (sum, meal) => sum + meal.calories);
			_proteinTotal = meals.fold(0.0, (sum, meal) => sum + meal.protein);
			_carbsTotal = meals.fold(0.0, (sum, meal) => sum + meal.carbs);
			_fatTotal = meals.fold(0.0, (sum, meal) => sum + meal.fat);
		});
	}	



	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Totals'),
			),
			body: _isLoading ? const Center(child: CircularProgressIndicator())
			: _statusMessage.isNotEmpty ? Center(child: Text(_statusMessage)) 
				: Column(
					children: [
					Card(
						margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
						child: Padding(
							padding: const EdgeInsets.all(16.0),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text('Total Calories: ${_calorieTotal}'),
									Text('Total Protein: ${_proteinTotal.toStringAsFixed(1)}'),
									Text('Total Carbs: ${_carbsTotal.toStringAsFixed(1)}'),
									Text('Total Fat: ${_fatTotal.toStringAsFixed(1)}'),
								]
							)
						)
					)]	
				)
		);
	}
}
