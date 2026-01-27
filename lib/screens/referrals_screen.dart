import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/floating_action_buttons.dart';

class ReferralsScreen extends StatefulWidget {
  const ReferralsScreen({Key? key}) : super(key: key);

  @override
  State<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends State<ReferralsScreen> {
  bool _isEnglish = true;

  // Mock data for Hospital Referrals
  final List<HospitalReferral> _hospitalReferrals = [
    HospitalReferral(
      patientName: 'Sunita Devi',
      patientNameHindi: 'सुनीता देवी',
      reason: 'High-risk pregnancy',
      reasonHindi: 'उच्च जोखिम वाली गर्भावस्था',
      hospitalName: 'District Hospital',
      hospitalNameHindi: 'जिला अस्पताल',
      status: 'In Transit',
      statusHindi: 'मार्ग में',
      statusColor: Colors.orange,
    ),
    HospitalReferral(
      patientName: 'Ram Lal',
      patientNameHindi: 'राम लाल',
      reason: 'Chest pain, breathing difficulty',
      reasonHindi: 'सीने में दर्द, सांस लेने में कठिनाई',
      hospitalName: 'Medical College Hospital',
      hospitalNameHindi: 'मेडिकल कॉलेज अस्पताल',
      status: 'Seen',
      statusHindi: 'जांच हो गई',
      statusColor: Colors.green,
    ),
    HospitalReferral(
      patientName: 'Baby Rahul',
      patientNameHindi: 'बच्चा राहुल',
      reason: 'High fever, persistent cough',
      reasonHindi: 'तेज बुखार, लगातार खांसी',
      hospitalName: 'Children Hospital',
      hospitalNameHindi: 'बाल चिकित्सालय',
      status: 'Referred',
      statusHindi: 'रेफर किया गया',
      statusColor: Colors.red,
    ),
  ];

  // Mock data for Telemedicine Referrals
  final List<TelemedicineReferral> _telemedicineReferrals = [
    TelemedicineReferral(
      patientName: 'Geeta Sharma',
      patientNameHindi: 'गीता शर्मा',
      condition: 'Gestational diabetes monitoring',
      conditionHindi: 'गर्भकालीन मधुमेह निगरानी',
      status: 'Waiting',
      statusHindi: 'प्रतीक्षा में',
    ),
    TelemedicineReferral(
      patientName: 'Rajesh Kumar',
      patientNameHindi: 'राजेश कुमार',
      condition: 'Post-operative follow-up',
      conditionHindi: 'ऑपरेशन के बाद फॉलो-अप',
      status: 'Completed',
      statusHindi: 'पूर्ण',
    ),
    TelemedicineReferral(
      patientName: 'Anita Singh',
      patientNameHindi: 'अनीता सिंह',
      condition: 'Hypertension consultation',
      conditionHindi: 'उच्च रक्तचाप परामर्श',
      status: 'Waiting',
      statusHindi: 'प्रतीक्षा में',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_isEnglish ? 'Referrals' : 'रेफरल'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppTheme.primaryTeal,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => setState(() => _isEnglish = !_isEnglish),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language, size: 18, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      _isEnglish ? 'EN' : 'HI',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
            // Section 1: Hospital Referrals
            Text(
              _isEnglish ? 'Hospital Referrals' : 'अस्पताल रेफरल',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ..._hospitalReferrals.map((referral) => _buildHospitalReferralCard(referral)),
            
            const SizedBox(height: 24),
            
            // Section 2: Telemedicine Referrals
            Text(
              _isEnglish ? 'Telemedicine Referrals' : 'टेलीमेडिसिन रेफरल',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ..._telemedicineReferrals.map((referral) => _buildTelemedicineReferralCard(referral)),
            
            const SizedBox(height: 100), // Extra padding for floating buttons
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

  Widget _buildHospitalReferralCard(HospitalReferral referral) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEnglish ? referral.patientName : referral.patientNameHindi,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: referral.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: referral.statusColor, width: 1),
                  ),
                  child: Text(
                    _isEnglish ? referral.status : referral.statusHindi,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: referral.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Reason for Referral
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.medical_services, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEnglish ? 'Reason:' : 'कारण:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isEnglish ? referral.reason : referral.reasonHindi,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Hospital Name
            Row(
              children: [
                Icon(Icons.local_hospital, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEnglish ? 'Hospital:' : 'अस्पताल:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isEnglish ? referral.hospitalName : referral.hospitalNameHindi,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemedicineReferralCard(TelemedicineReferral referral) {
    final isWaiting = referral.status == 'Waiting';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Name
            Text(
              _isEnglish ? referral.patientName : referral.patientNameHindi,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            
            // Condition Summary
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.description, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEnglish ? 'Condition:' : 'स्थिति:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isEnglish ? referral.condition : referral.conditionHindi,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isWaiting ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isEnglish 
                          ? '🎥 Starting Telemedicine Session...' 
                          : '🎥 टेलीमेडिसिन सत्र शुरू हो रहा है...',
                      ),
                      backgroundColor: AppTheme.primaryTeal,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } : null,
                icon: Icon(isWaiting ? Icons.videocam : Icons.check_circle, size: 20),
                label: Text(
                  isWaiting 
                    ? (_isEnglish ? 'Start Telemedicine' : 'टेलीमेडिसिन शुरू करें')
                    : (_isEnglish ? 'Completed' : 'पूर्ण'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isWaiting ? AppTheme.primaryTeal : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Models
class HospitalReferral {
  final String patientName;
  final String patientNameHindi;
  final String reason;
  final String reasonHindi;
  final String hospitalName;
  final String hospitalNameHindi;
  final String status;
  final String statusHindi;
  final Color statusColor;

  HospitalReferral({
    required this.patientName,
    required this.patientNameHindi,
    required this.reason,
    required this.reasonHindi,
    required this.hospitalName,
    required this.hospitalNameHindi,
    required this.status,
    required this.statusHindi,
    required this.statusColor,
  });
}

class TelemedicineReferral {
  final String patientName;
  final String patientNameHindi;
  final String condition;
  final String conditionHindi;
  final String status;
  final String statusHindi;

  TelemedicineReferral({
    required this.patientName,
    required this.patientNameHindi,
    required this.condition,
    required this.conditionHindi,
    required this.status,
    required this.statusHindi,
  });
}
