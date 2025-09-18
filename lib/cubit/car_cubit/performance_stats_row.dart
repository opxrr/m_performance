import 'dart:ui';

import 'package:flutter/material.dart';

class PerformanceStatsRow extends StatelessWidget {
  final String horsepower;
  final String topSpeed;
  final String weight;
  final String acceleration;

  const PerformanceStatsRow({
    super.key,
    required this.horsepower,
    required this.topSpeed,
    required this.weight,
    required this.acceleration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildStatTile(
                    Icons.directions_car,
                    'Horsepower',
                    horsepower,
                    'Engine power in HP',
                  ),
                ),
                Expanded(
                  child: _buildStatTile(
                    Icons.speed,
                    'Top Speed',
                    topSpeed,
                    'Maximum speed in km/h',
                  ),
                ),
                Expanded(
                  child: _buildStatTile(
                    Icons.line_weight,
                    'Weight',
                    weight,
                    'Vehicle weight in kg',
                  ),
                ),
                Expanded(
                  child: _buildStatTile(
                    Icons.timer,
                    '0-100 km/h',
                    acceleration,
                    'Acceleration time in seconds',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile(
    IconData icon,
    String label,
    String value,
    String tooltip,
  ) {
    return GestureDetector(
      onTap: () {},
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: tooltip,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
