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
			// need to add cached date, so if passed in date differs from cached date,
			// we can force refresh
			await _apiService.getMeals();
			final totals = _apiService.calculateTotals();
			setState(() {
				_calorieTotal = totals['calories']!.toInt();
				_proteinTotal = totals['protein']!;
				_carbsTotal = totals['carbs']!;
				_fatTotal = totals['fat']!;
			});
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
