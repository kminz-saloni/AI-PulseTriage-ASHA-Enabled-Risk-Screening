import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/cards.dart';
import '../widgets/buttons.dart';
import '../widgets/input_components.dart';
import '../widgets/floating_action_buttons.dart';

class AiRiskResultScreen extends StatefulWidget {
  const AiRiskResultScreen({Key? key}) : super(key: key);

  @override
  State<AiRiskResultScreen> createState() => _AiRiskResultScreenState();
}

class _AiRiskResultScreenState extends State<AiRiskResultScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false),
          padding: EdgeInsets.zero,
        ),
        title: const Text('AI Risk Assessment'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const Row(
                  children: [
                    Icon(
                      Icons.language,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'EN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.bgLight,
      floatingActionButton: FloatingActionButtonsWidget(
        key: const ValueKey('ai_risk_buttons'),
        isEnglish: true,
      ),
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
}
