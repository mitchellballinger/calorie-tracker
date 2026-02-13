import 'package:flutter/material.dart';
import 'screens/meal_input_screen.dart';
import 'screens/meal_history_screen.dart';

void main() {
	runApp(const CalorieTrackerApp());
}

class CalorieTrackerApp extends StatelessWidget {
	const CalorieTrackerApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			initialRoute: '/',
			routes: {
				'/': (context) => const MealInputScreen(),
				'/meal-history': (context) => const MealHistoryScreen(),
			},
			debugShowCheckedModeBanner: false,
		);
	}
}

