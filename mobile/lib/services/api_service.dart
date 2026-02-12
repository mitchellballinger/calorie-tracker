import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/meal.dart';

class ApiService {
	static const String _baseUrl = 'http://localhost:8080';

	Future<Meal> submitMeal(String description) async {
		final response = await http.post(
			Uri.parse('$_baseUrl/meal'),
			headers: {'Content-Type': 'application/json'},
			body: jsonEncode({'description': description}),
		);

		if (response.statusCode == 200) {
			final json = jsonDecode(response.body);
			return Meal.fromJson(json);
		}
		else {
			throw Exception('Failed to submit meal: ${response.statusCode}');
		}
	}
}
