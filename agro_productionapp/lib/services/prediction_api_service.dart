import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionApiService {
  static const String baseUrl =
      'https://ml-linear-regression-assignment.onrender.com';

  // Prediction request model
  static Future<PredictionResponse> predictProduction({
    required String crop,
    required String state,
    required String season,
    required double area,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/predict');

      final requestBody = {
        'Crop': crop,
        'State': state,
        'Season': season,
        'Area': area,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return PredictionResponse.fromJson(responseData);
      } else {
        throw PredictionException(
          'Prediction failed with status code: ${response.statusCode}. ${response.body}',
        );
      }
    } catch (e) {
      if (e is PredictionException) {
        rethrow;
      }
      throw PredictionException(
        'Network error: Unable to connect to prediction service. Please check your internet connection.',
      );
    }
  }

  // Health check endpoint
  static Future<bool> checkServiceHealth() async {
    try {
      final url = Uri.parse('$baseUrl/');
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// Response model matching the FastAPI response
class PredictionResponse {
  final String crop;
  final String state;
  final String? season;
  final double area;
  final double predictedProduction;

  PredictionResponse({
    required this.crop,
    required this.state,
    this.season,
    required this.area,
    required this.predictedProduction,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      crop: json['crop'] ?? '',
      state: json['state'] ?? '',
      season: json['season'],
      area: (json['area'] ?? 0.0).toDouble(),
      predictedProduction: (json['predicted_production'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop': crop,
      'state': state,
      'season': season,
      'area': area,
      'predicted_production': predictedProduction,
    };
  }
}

// Custom exception for prediction errors
class PredictionException implements Exception {
  final String message;

  PredictionException(this.message);

  @override
  String toString() => 'PredictionException: $message';
}
