import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/floating_action_buttons.dart';

class IncentiveTrackerScreen extends StatefulWidget {
  const IncentiveTrackerScreen({Key? key}) : super(key: key);

  @override
  State<IncentiveTrackerScreen> createState() => _IncentiveTrackerScreenState();
}

class _IncentiveTrackerScreenState extends State<IncentiveTrackerScreen> {
  bool _isEnglish = true;

  // Summary data
  final double _earnedThisMonth = 3450.0;
  final double _pendingAmount = 1200.0;
  final double _paidAmount = 2250.0;

  // Mock incentive data
  final List<IncentiveRecord> _incentives = [
    IncentiveRecord(
      activityType: 'Delivery Assistance',
      activityTypeHindi: 'प्रसव सहायता',
      patientName: 'Sunita Devi',
      patientNameHindi: 'सुनीता देवी',
      amount: 600.0,
      status: 'Paid',
      statusHindi: 'भुगतान किया गया',
      statusColor: Colors.green,
    ),
    IncentiveRecord(
      activityType: 'Immunization',
      activityTypeHindi: 'टीकाकरण',
      patientName: 'Baby Rahul',
      patientNameHindi: 'बच्चा राहुल',
      amount: 150.0,
      status: 'Approved',
      statusHindi: 'स्वीकृत',
      statusColor: Colors.blue,
    ),
    IncentiveRecord(
      activityType: 'Antenatal Follow-up',
      activityTypeHindi: 'प्रसवपूर्व अनुवर्ती',
      patientName: 'Geeta Sharma',
      patientNameHindi: 'गीता शर्मा',
      amount: 200.0,
      status: 'Pending',
      statusHindi: 'लंबित',
      statusColor: Colors.orange,
    ),
    IncentiveRecord(
      activityType: 'Delivery Assistance',
      activityTypeHindi: 'प्रसव सहायता',
      patientName: 'Anita Singh',
      patientNameHindi: 'अनीता सिंह',
      amount: 600.0,
      status: 'Paid',
      statusHindi: 'भुगतान किया गया',
      statusColor: Colors.green,
    ),
    IncentiveRecord(
      activityType: 'Postnatal Follow-up',
      activityTypeHindi: 'प्रसवोत्तर अनुवर्ती',
      patientName: 'Baby Priya',
      patientNameHindi: 'बच्ची प्रिया',
      amount: 150.0,
      status: 'Paid',
      statusHindi: 'भुगतान किया गया',
      statusColor: Colors.green,
    ),
    IncentiveRecord(
      activityType: 'Immunization',
      activityTypeHindi: 'टीकाकरण',
      patientName: 'Baby Amit',
      patientNameHindi: 'बच्चा अमित',
      amount: 150.0,
      status: 'Pending',
      statusHindi: 'लंबित',
      statusColor: Colors.orange,
    ),
    IncentiveRecord(
      activityType: 'Antenatal Follow-up',
      activityTypeHindi: 'प्रसवपूर्व अनुवर्ती',
      patientName: 'Radha Kumari',
      patientNameHindi: 'राधा कुमारी',
      amount: 200.0,
      status: 'Approved',
      statusHindi: 'स्वीकृत',
      statusColor: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          _isEnglish ? 'Incentives' : 'प्रोत्साहन',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        elevation: 2,
        centerTitle: true,
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () => setState(() => _isEnglish = !_isEnglish),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language, size: 24, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          _isEnglish ? 'EN' : 'HI',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Summary Section
                _buildSummaryCard(),
                
                const SizedBox(height: 24),
                
                // Motivation Text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryTeal.withOpacity(0.1),
                        AppTheme.accentTeal.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryTeal.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isEnglish
                              ? 'Your work is improving lives.'
                              : 'आपका काम जीवन में सुधार कर रहा है।',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryTeal,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Incentive List Header
                Text(
                  _isEnglish ? 'Incentive History' : 'प्रोत्साहन इतिहास',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Incentive Cards
                ..._incentives.map((incentive) => _buildIncentiveCard(incentive)),
                
                const SizedBox(height: 100), // Space for floating buttons
              ],
            ),
          ),
          // Floating Action Buttons (SOS & Voice Assistant)
          FloatingActionButtonsWidget(
            isEnglish: _isEnglish,
            initialSosPosition: const Offset(16, 20),
            initialVoicePosition: const Offset(16, 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryTeal, AppTheme.accentTeal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              _isEnglish ? 'Monthly Summary' : 'मासिक सारांश',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  icon: Icons.currency_rupee,
                  label: _isEnglish ? 'Earned' : 'अर्जित',
                  amount: '₹${_earnedThisMonth.toStringAsFixed(0)}',
                  color: Colors.white,
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildSummaryItem(
                  icon: Icons.hourglass_empty,
                  label: _isEnglish ? 'Pending' : 'लंबित',
                  amount: '₹${_pendingAmount.toStringAsFixed(0)}',
                  color: Colors.white,
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildSummaryItem(
                  icon: Icons.check_circle,
                  label: _isEnglish ? 'Paid' : 'भुगतान',
                  amount: '₹${_paidAmount.toStringAsFixed(0)}',
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String amount,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildIncentiveCard(IncentiveRecord incentive) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Type and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        _getActivityIcon(incentive.activityType),
                        color: AppTheme.primaryTeal,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isEnglish ? incentive.activityType : incentive.activityTypeHindi,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: incentive.statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: incentive.statusColor, width: 1.5),
                  ),
                  child: Text(
                    _isEnglish ? incentive.status : incentive.statusHindi,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: incentive.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Patient Name
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  _isEnglish ? incentive.patientName : incentive.patientNameHindi,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Incentive Amount
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.currency_rupee,
                    size: 20,
                    color: AppTheme.primaryTeal,
                  ),
                  Text(
                    incentive.amount.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryTeal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String activityType) {
    if (activityType.contains('Delivery')) {
      return Icons.pregnant_woman;
    } else if (activityType.contains('Immunization')) {
      return Icons.vaccines;
    } else if (activityType.contains('Follow-up') || activityType.contains('Antenatal') || activityType.contains('Postnatal')) {
      return Icons.medical_services;
    }
    return Icons.health_and_safety;
  }
}

// Incentive Record Model
class IncentiveRecord {
  final String activityType;
  final String activityTypeHindi;
  final String patientName;
  final String patientNameHindi;
  final double amount;
  final String status;
  final String statusHindi;
  final Color statusColor;

  IncentiveRecord({
    required this.activityType,
    required this.activityTypeHindi,
    required this.patientName,
    required this.patientNameHindi,
    required this.amount,
    required this.status,
    required this.statusHindi,
    required this.statusColor,
  });
}

