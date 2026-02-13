import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';

class MealHistoryScreen extends StatefulWidget {
	const MealHistoryScreen({Key? key}) : super(key: key);

	@override
	State<MealHistoryScreen> createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
	final ApiService _apiService = ApiService();
	String _statusMessage = '';
	bool _isLoading = false;
	List<Meal>? _mealList;

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
		print('_retrieveMeals called');
		setState(() {
			_isLoading = true;
			_statusMessage = '';
			_mealList = null;
		});


		try {
			final meals = await _apiService.getMeals();
			setState(() => _mealList = meals..sort((a,b) => b.timestamp.compareTo(a.timestamp)));
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
				title: const Text('History'),
			),
			body: _isLoading
			? const Center(child: CircularProgressIndicator())
			: _mealList == null || _mealList!.isEmpty
				? Center(
					child: Text(
						_statusMessage.isNotEmpty ? _statusMessage : 'No meals logged.',
					),
				)
				: ListView.builder(
					itemCount: _mealList!.length,
					itemBuilder: (context, index) {
						final meal = _mealList![index];
						return Card(
							margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
							child: Padding(
								padding: const EdgeInsets.all(16.0),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											meal.description,
											style: const TextStyle(
												fontWeight: FontWeight.bold,
												fontSize: 16,
											),
										),
										const SizedBox(height: 8),
										Text('Calories: ${meal.calories}'),
										Text('Protein: ${meal.protein}g'),
										Text('Carbs: ${meal.carbs}g'),
										Text('Fat: ${meal.fat}g'),
										Text('Date: ${meal.timestamp.month}/${meal.timestamp.day}/${meal.timestamp.year}'),
										Text('Time:	${meal.timestamp.hour}:${meal.timestamp.minute}'),
									],
								),
							),
						);
					},
				),
		);
	}
}
