import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
	static const String _baseUrl = 'http://localhost:8080';

	Future<bool> submitMeal(String description) async {
		final response = await http.post(
			Uri.parse('$_baseUrl/meal'),
			headers: {'Content-Type': 'application/json'},
			body: jsonEncode({'description': description}),
		);

		return response.statusCode == 200;
	}
}
