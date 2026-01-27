import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/floating_action_buttons.dart';
import 'patient_management_screen.dart';
import 'emergency_alert_screen.dart';
import 'incentive_tracker_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isEnglish = true;

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const PatientManagementScreen();
      case 2:
        return const EmergencyAlertScreen();
      case 3:
        return _buildTasksTab();
      case 4:
        return const IncentiveTrackerScreen();
      default:
        return _buildHomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildCurrentScreen(),
          
          // Floating Action Buttons (SOS & Voice)
          FloatingActionButtonsWidget(
            key: const ValueKey('main_screen_buttons'),
            isEnglish: _isEnglish,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryTeal,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: _isEnglish ? 'Home' : 'होम',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: _isEnglish ? 'Patients' : 'मरीज़',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.medical_services),
            label: _isEnglish ? 'Referrals' : 'रेफरल',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.task_alt),
            label: _isEnglish ? 'Tasks' : 'कार्य',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.attach_money),
            label: _isEnglish ? 'Incentives' : 'प्रोत्साहन',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppTheme.primaryTeal, size: 24),
          ),
          onPressed: () {
            // Show compact profile dialog
            showDialog(
              context: context,
              builder: (context) => _buildCompactProfileDialog(),
            );
          },
        ),
        title: Text(_isEnglish ? 'AASHA-TRIAGE' : 'आशा-ट्रायज'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppTheme.primaryTeal,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => setState(() => _isEnglish = !_isEnglish),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isEnglish ? Icons.language : Icons.translate,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isEnglish ? 'EN' : 'हिन्दी',
                      style: const TextStyle(
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Actions Section
              Text(
                _isEnglish ? 'Quick Actions' : 'त्वरित कार्य',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildQuickActionCard(
                    icon: Icons.search,
                    title: _isEnglish ? 'Search Patient' : 'मरीज़ खोजें',
                    color: Colors.blue,
                    onTap: () => setState(() => _currentIndex = 1),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickActionCard(
                    icon: Icons.warning,
                    title: _isEnglish ? 'Emergency\nAlert' : 'आपातकाल\nसतर्कता',
                    color: Colors.red,
                    onTap: () => setState(() => _currentIndex = 2),
                  )),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildQuickActionCard(
                    icon: Icons.list_alt,
                    title: _isEnglish ? 'Emergencies' : 'आपात स्थितियां',
                    color: Colors.orange,
                    onTap: () => setState(() => _currentIndex = 2),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickActionCard(
                    icon: Icons.person_add,
                    title: _isEnglish ? 'New Patient' : 'नया मरीज़',
                    color: Colors.teal,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isEnglish ? 'Add New Patient' : 'नया मरीज़ जोड़ें'),
                          backgroundColor: Colors.teal,
                        ),
                      );
                    },
                  )),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Date and Task Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    today,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Text(
                      _isEnglish ? 'Task Progress' : 'कार्य प्रगति',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isEnglish ? '3 of 7 completed' : '7 में से 3 पूर्ण',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Task List
              Text(
                _isEnglish ? 'Your Tasks' : 'आपके कार्य',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildTaskCard(
                title: _isEnglish ? 'Visit pregnant woman – Sunita Devi' : 'गर्भवती महिला की विजिट – सुनीता देवी',
                time: _isEnglish ? 'Before 12 PM' : 'दोपहर 12 बजे से पहले',
                icon: Icons.pregnant_woman,
                color: Colors.pink,
                priority: 'HIGH',
                isCompleted: false,
              ),
              
              _buildTaskCard(
                title: _isEnglish ? 'Child vaccination – Rahul Kumar (18 months)' : 'बच्चे का टीकाकरण – राहुल कुमार (18 माह)',
                time: _isEnglish ? 'Before 2 PM' : 'दोपहर 2 बजे से पहले',
                icon: Icons.vaccines,
                color: Colors.blue,
                priority: 'HIGH',
                isCompleted: false,
              ),
              
              _buildTaskCard(
                title: _isEnglish ? 'Follow-up visit – Meera Sharma (Diabetes)' : 'फॉलो-अप विजिट – मीरा शर्मा (मधुमेह)',
                time: _isEnglish ? 'Before 4 PM' : 'शाम 4 बजे से पहले',
                icon: Icons.medication,
                color: Colors.orange,
                priority: 'NORMAL',
                isCompleted: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String time,
    required IconData icon,
    required Color color,
    required String priority,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? Colors.green.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (priority == 'HIGH')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'HIGH',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isCompleted)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _isEnglish ? 'DONE' : 'पूर्ण',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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

  Widget _buildTasksTab() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(_isEnglish ? 'All Tasks' : 'सभी कार्य'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppTheme.primaryTeal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _isEnglish ? 'All Tasks View' : 'सभी कार्य दृश्य',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactProfileDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Icon
            CircleAvatar(
              radius: 35,
              backgroundColor: AppTheme.primaryTeal.withOpacity(0.2),
              child: const Icon(Icons.person, size: 40, color: AppTheme.primaryTeal),
            ),
            const SizedBox(height: 16),
            // Name
            Text(
              'Priya Sharma',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _isEnglish ? 'ASHA Worker' : 'आशा कार्यकर्ता',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            // Details
            _buildInfoRow(Icons.badge, 'ID: ASH001'),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.phone, '+91 98765 43210'),
            const SizedBox(height: 20),
            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                icon: const Icon(Icons.logout, size: 18),
                label: Text(_isEnglish ? 'Sign Out' : 'साइन आउट'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryTeal, size: 18),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
