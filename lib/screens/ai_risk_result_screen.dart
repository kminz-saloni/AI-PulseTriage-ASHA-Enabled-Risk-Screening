import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/cards.dart';
import '../widgets/buttons.dart';
import '../widgets/input_components.dart';

class AiRiskResultScreen extends StatelessWidget {
  const AiRiskResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Risk Assessment'),
        elevation: 0,
      ),
      backgroundColor: AppTheme.bgLight,
      floatingActionButton: _buildFloatingButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reena Sharma',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppTheme.xs),
                      Text(
                        'Age 28 | Pregnant | Nandpur Village',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mediumText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.xxl),

              // Risk level badge
              Center(
                child: Column(
                  children: [
                    PriorityBadge(
                      level: 'HIGH RISK',
                      backgroundColor: AppTheme.riskHigh.withOpacity(0.15),
                      textColor: AppTheme.riskHigh,
                      fontSize: 20,
                    ),
                    const SizedBox(height: AppTheme.lg),
                    Text(
                      'Requires Immediate Attention',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.riskHigh,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.xxl),

              // Findings
              SectionHeader(
                title: 'Key Findings',
              ),
              const SizedBox(height: AppTheme.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  child: Column(
                    children: [
                      _buildFinding(
                        'Blood Pressure',
                        '150/95 mmHg',
                        AppTheme.riskHigh,
                      ),
                      CustomDivider(),
                      _buildFinding(
                        'Swelling',
                        'Significant edema detected',
                        AppTheme.riskHigh,
                      ),
                      CustomDivider(),
                      _buildFinding(
                        'Protein in Urine',
                        'Present (1+)',
                        AppTheme.riskMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.xxl),

              // Recommendations
              SectionHeader(
                title: 'Recommended Actions',
              ),
              const SizedBox(height: AppTheme.md),
              Card(
                color: AppTheme.cautionAmber.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.cautionAmber,
                          ),
                          const SizedBox(width: AppTheme.lg),
                          Expanded(
                            child: Text(
                              'Refer to District Hospital immediately for specialist evaluation.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.darkText,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.xl),

              // Action buttons
              LargeButton(
                label: 'Call Ambulance',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling ambulance...')),
                  );
                },
                backgroundColor: AppTheme.emergencyRed,
                icon: Icons.phone,
              ),
              const SizedBox(height: AppTheme.md),
              SecondaryButton(
                label: 'Call Doctor',
                onPressed: () {},
                borderColor: AppTheme.primaryTeal,
                textColor: AppTheme.primaryTeal,
                icon: Icons.phone,
              ),
              const SizedBox(height: AppTheme.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinding(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: AppTheme.xs),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppTheme.mediumText,
              ),
            ),
          ],
        ),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingButtons() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 72 + 20,
        right: 16,
        left: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: AppTheme.emergencyRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            heroTag: 'sos_button_risk',
            child: const Icon(Icons.emergency, size: 28),
          ),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            heroTag: 'ai_button_risk',
            child: const Icon(Icons.mic, size: 28),
          ),
        ],
      ),
    );
  }
}
