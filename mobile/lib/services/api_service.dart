import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/meal.dart';

class ApiService {
	static final ApiService _instance = ApiService._internal();
	factory ApiService() => _instance;
	ApiService._internal();
	
	static const String _baseUrl = 'http://localhost:8080';

	List<Meal>? _cachedMeals;

	Future<Meal> submitMeal(String description) async {
		final response = await http.post(
			Uri.parse('$_baseUrl/submit-meal'),
			headers: {'Content-Type': 'application/json'},
			body: jsonEncode({'description': description}),
		);

		if (response.statusCode == 200) {
			final json = jsonDecode(response.body);
			_cachedMeals?.add(Meal.fromJson(json));
			return Meal.fromJson(json);
		}
		else {
			throw Exception('Failed to submit meal: ${response.statusCode}');
		}
	}

	Future<List<Meal>> getMeals({bool forceRefresh = false, String date = ""}) async {
		if (_cachedMeals != null && !forceRefresh) {
			print("Cache hit");
			return _cachedMeals!;
		}
		final response = await http.get(Uri.parse('$_baseUrl/get-meals?date=${date}'));
		
		if (response.statusCode == 200) {
			final data = jsonDecode(response.body) as List;

			List<Meal> meals = data.map((element) => Meal.fromJson(element)).toList();
			_cachedMeals = meals;
			return meals;
		}
		else {
			throw Exception('Failed to get meals: ${response.statusCode}');
		}
		
	}

	Future<void> deleteMeal(int id) async {
		final response = await http.post(
			Uri.parse('$_baseUrl/delete-meal'),
			headers: {'Content-Type': 'application/json'},
			body: jsonEncode({'id': id}),
		);
		
		if (response.statusCode == 200) {
			_cachedMeals?.removeWhere((meal) => meal.id == id);
			return;
		}
		else {
			throw Exception('Failed to delete meals: ${response.statusCode}');
		}

	}

	Map<String, double> calculateTotals() {
		if (_cachedMeals == null || _cachedMeals!.isEmpty) {
			return {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0};
		}

		return {
			'calories': _cachedMeals!.fold(0, (sum, meal) => sum + meal.calories).toDouble(),
			'protein': _cachedMeals!.fold(0.0, (sum, meal) => sum + meal.protein),
			'carbs': _cachedMeals!.fold(0.0, (sum, meal) => sum + meal.carbs),
			'fat': _cachedMeals!.fold(0.0, (sum, meal) => sum + meal.fat),
		};
	}


}
