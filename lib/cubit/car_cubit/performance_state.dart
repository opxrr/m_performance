import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:m_performance/m_database/models/car.dart';

class PerformanceStats extends StatelessWidget {
  final double horsepower;
  final double speed;
  final double weight;
  final double acceleration;
  final Car originalCar;

  const PerformanceStats({
    super.key,
    required this.horsepower,
    required this.speed,
    required this.weight,
    required this.acceleration,
    required this.originalCar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStat(
                  context,
                  'Horsepower',
                  horsepower,
                  originalCar.horsepower.toDouble(),
                  1000,
                  'HP',
                ),
                const SizedBox(height: 12),
                _buildStat(
                  context,
                  'Top Speed',
                  speed,
                  originalCar.topSpeed.toDouble(),
                  400,
                  'km/h',
                ),
                const SizedBox(height: 12),
                _buildStat(
                  context,
                  'Weight',
                  weight,
                  originalCar.weight.toDouble(),
                  3000,
                  'kg',
                  isReverse: true,
                ),
                const SizedBox(height: 12),
                _buildStat(
                  context,
                  '0-100 km/h',
                  acceleration,
                  originalCar.zeroToHundred,
                  10,
                  's',
                  isReverse: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(
      BuildContext context,
      String label,
      double value,
      double originalValue,
      double maxValue,
      String unit, {
        bool isReverse = false,
      }) {
    final theme = Theme.of(context);
    final progress = (value / maxValue).clamp(0.0, 1.0);
    final isFavorable = isReverse ? value < originalValue : value > originalValue;
    final color = isFavorable ? Colors.green : Colors.redAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(1)} $unit',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: 10,
          child: LinearProgressIndicator(
            value: isReverse ? 1.0 - progress : progress,
            backgroundColor: theme.dividerColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              value == originalValue ? Colors.indigoAccent : color,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}