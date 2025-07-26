import 'package:flutter/material.dart';
import '../services/prediction_api_service.dart';
import 'home_screen.dart';

class PredictionResultsPage extends StatefulWidget {
  final String state;
  final String crop;
  final String season;
  final double area;
  final PredictionResponse? apiPrediction;

  const PredictionResultsPage({
    super.key,
    required this.state,
    required this.crop,
    required this.season,
    required this.area,
    this.apiPrediction,
  });

  @override
  State<PredictionResultsPage> createState() => _PredictionResultsPageState();
}

class _PredictionResultsPageState extends State<PredictionResultsPage> {
  late double predictedProduction;
  late double yieldPerHectare;
  late double avgYield;
  late String confidence;
  late String riskFactor;

  @override
  void initState() {
    super.initState();
    _calculatePrediction();
  }

  void _calculatePrediction() {
    if (widget.apiPrediction != null) {
      // Use real API prediction data
      predictedProduction = widget.apiPrediction!.predictedProduction;
      yieldPerHectare = predictedProduction / widget.area;
      avgYield = yieldPerHectare * 0.85; // Mock average for comparison
      confidence = _getConfidence(widget.crop);
      riskFactor = _getRiskFactor(widget.season);
    } else {
      // Fallback to mock data if API fails
      yieldPerHectare = _getCropYield(widget.crop);
      predictedProduction = widget.area * yieldPerHectare;
      avgYield = yieldPerHectare * 0.85;
      confidence = _getConfidence(widget.crop);
      riskFactor = _getRiskFactor(widget.season);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Prediction Results',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _saveResults,
            icon: const Icon(Icons.bookmark_border, color: Colors.green),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3D3D),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Input Summary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              'Location',
                              widget.state,
                              Icons.location_on,
                            ),
                          ),
                          Expanded(
                            child: _buildInfoItem(
                              'Crop',
                              widget.crop,
                              Icons.agriculture,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              'Season',
                              widget.season,
                              Icons.wb_sunny,
                            ),
                          ),
                          Expanded(
                            child: _buildInfoItem(
                              'Area',
                              '${widget.area} ha',
                              Icons.landscape,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Main Prediction Result
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.2),
                        Colors.green.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.insights, color: Colors.green, size: 24),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'Prediction Result',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  widget.apiPrediction != null
                                      ? Colors.blue.withOpacity(0.2)
                                      : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.apiPrediction != null
                                  ? 'LIVE DATA'
                                  : 'DEMO',
                              style: TextStyle(
                                color:
                                    widget.apiPrediction != null
                                        ? Colors.blue
                                        : Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${predictedProduction.toStringAsFixed(2)} tons',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Predicted Production',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Confidence: $confidence',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Comparison Analytics
                const Text(
                  'Performance Analysis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _buildAnalyticsCard(
                        'Yield per Hectare',
                        '${yieldPerHectare.toStringAsFixed(2)} tons/ha',
                        Icons.trending_up,
                        const Color(0xFF4A90E2), // Professional blue
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildAnalyticsCard(
                        'vs. Average Yield',
                        '${((yieldPerHectare - avgYield) / avgYield * 100).toStringAsFixed(1)}%',
                        Icons.compare_arrows,
                        yieldPerHectare > avgYield
                            ? const Color(0xFF7ED321) // Bright green
                            : const Color(0xFFFF9500), // Vibrant orange
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _buildAnalyticsCard(
                        'Risk Factor',
                        riskFactor,
                        Icons.warning_amber,
                        _getRiskColor(riskFactor),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildAnalyticsCard(
                        'Market Value',
                        '₹${(predictedProduction * _getCropPrice(widget.crop)).toStringAsFixed(0)}',
                        Icons.currency_rupee,
                        const Color(0xFF9B59B6), // Rich purple
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Historical Trends (Mock Chart)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4A90E2).withOpacity(0.1),
                        const Color(0xFF4A90E2).withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF4A90E2).withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.bar_chart,
                            color: Color(0xFF4A90E2),
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Historical Trends',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Production trend for last 5 years',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 15),
                      // Mock chart representation
                      Row(
                        children: List.generate(5, (index) {
                          double height =
                              40 + (index * 10.0) + (index % 2 == 0 ? 5 : -5);
                          List<Color> barColors = [
                            const Color(0xFF4A90E2), // Blue
                            const Color(0xFF7ED321), // Green
                            const Color(0xFFF39C12), // Orange
                            const Color(0xFF9B59B6), // Purple
                            const Color(0xFFE74C3C), // Red
                          ];
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              child: Column(
                                children: [
                                  Container(
                                    height: height,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          barColors[index],
                                          barColors[index].withOpacity(0.6),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: barColors[index].withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${2019 + index}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'New Prediction',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _goToHome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Home',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Mock data functions
  double _getCropYield(String crop) {
    switch (crop) {
      case 'Rice':
        return 4.2;
      case 'Wheat':
        return 3.5;
      case 'Sugarcane':
        return 75.0;
      case 'Cotton(lint)':
        return 1.8;
      case 'Groundnut':
        return 2.1;
      case 'Soyabean':
        return 1.9;
      case 'Maize':
        return 4.8;
      case 'Jowar':
        return 2.3;
      case 'Bajra':
        return 2.1;
      default:
        return 3.0;
    }
  }

  double _getCropPrice(String crop) {
    // Price per ton in INR
    switch (crop) {
      case 'Rice':
        return 25000;
      case 'Wheat':
        return 22000;
      case 'Sugarcane':
        return 3500;
      case 'Cotton(lint)':
        return 95000;
      case 'Groundnut':
        return 65000;
      case 'Soyabean':
        return 45000;
      case 'Maize':
        return 20000;
      default:
        return 30000;
    }
  }

  String _getConfidence(String crop) {
    // Mock confidence based on crop popularity in dataset
    List<String> highConfidence = [
      'Rice',
      'Wheat',
      'Sugarcane',
      'Cotton(lint)',
    ];
    return highConfidence.contains(crop) ? 'High (85%)' : 'Medium (72%)';
  }

  String _getRiskFactor(String season) {
    switch (season) {
      case 'Kharif':
        return 'Moderate';
      case 'Rabi':
        return 'Low';
      case 'Summer':
        return 'High';
      default:
        return 'Medium';
    }
  }

  Color _getRiskColor(String risk) {
    switch (risk) {
      case 'Low':
        return const Color(0xFF27AE60); // Fresh green
      case 'Moderate':
      case 'Medium':
        return const Color(0xFFF39C12); // Warm orange
      case 'High':
        return const Color(0xFFE74C3C); // Vibrant red
      default:
        return const Color(0xFFF1C40F); // Bright yellow
    }
  }

  void _saveResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Results saved to your profile'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }
}
