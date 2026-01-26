import 'package:flutter/material.dart';
import '../../domain/risk_level.dart';

class RiskBadge extends StatelessWidget {
  final RiskLevel riskLevel;
  final double size;

  const RiskBadge({
    super.key,
    required this.riskLevel,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final label = _getLabel();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size / 2, vertical: size / 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: color, size: size / 2),
          SizedBox(width: size / 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: size / 2,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (riskLevel) {
      case RiskLevel.green:
        return Colors.green;
      case RiskLevel.yellow:
        return Colors.orange;
      case RiskLevel.red:
        return Colors.red;
    }
  }

  String _getLabel() {
    switch (riskLevel) {
      case RiskLevel.green:
        return 'Low Risk';
      case RiskLevel.yellow:
        return 'Medium Risk';
      case RiskLevel.red:
        return 'High Risk';
    }
  }
}
