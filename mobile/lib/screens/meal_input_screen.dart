import 'package:flutter/material.dart';
import '../services/api_service.dart';

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
    });

    try {
      final success = await _apiService.submitMeal(description);
      setState(() {
        _statusMessage = success ? 'Meal logged successfully!' : 'Server error.';
      });
      if (success) _mealController.clear();
    } catch (e) {
      setState(() => _statusMessage = 'Failed to connect to server: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal'),
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
            const SizedBox(height: 16),
            Text(_statusMessage),
          ],
        ),
      ),
    );
  }
}
