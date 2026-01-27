import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
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
  Timer? _sosTimer;
  bool _sosActive = false;
  
  // Draggable button positions
  Offset _sosPosition = const Offset(20, -180);
  Offset _voicePosition = const Offset(20, -100);

  @override
  void dispose() {
    _sosTimer?.cancel();
    super.dispose();
  }

  void _showSOSDialog() {
    _sosTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _activateSOS();
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          _isEnglish ? 'Emergency Alert' : 'आपातकाल सतर्कता',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Text(
          _isEnglish
              ? 'Are you in emergency?\nSOS will activate if you don\'t respond in 5 seconds.'
              : 'क्या आप आपातकाल में हैं?\nयदि आप 5 सेकंड में प्रतिक्रिया नहीं देते हैं तो SOS सक्रिय हो जाएगा।',
        ),
        actions: [
          TextButton(
            onPressed: () {
              _sosTimer?.cancel();
              Navigator.pop(context);
              _sosActive = false;
            },
            child: Text(_isEnglish ? 'No' : 'नहीं'),
          ),
          ElevatedButton(
            onPressed: () {
              _sosTimer?.cancel();
              Navigator.pop(context);
              _activateSOS();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(_isEnglish ? 'Yes, Emergency!' : 'हाँ, आपातकाल!'),
          ),
        ],
      ),
    );
  }

  void _activateSOS() {
    if (_sosActive) return;
    _sosActive = true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEnglish
              ? '🚨 SOS Activated! Location sent to emergency contact'
              : '🚨 SOS सक्रिय! स्थान आपातकाल संपर्क को भेजा गया',
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
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
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          _buildCurrentScreen(),
          
          // Draggable Voice Assistant Button
          Positioned(
            right: _voicePosition.dx,
            bottom: _voicePosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _voicePosition = Offset(
                    (_voicePosition.dx - details.delta.dx).clamp(20.0, size.width - 80),
                    (_voicePosition.dy - details.delta.dy).clamp(-size.height + 180, -20.0),
                  );
                });
              },
              child: FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isEnglish ? 'Voice Assistant' : 'आवाज़ सहायक'),
                      backgroundColor: AppTheme.primaryTeal,
                    ),
                  );
                },
                backgroundColor: AppTheme.primaryTeal,
                child: const Icon(Icons.mic, color: Colors.white, size: 28),
                heroTag: 'voice_main',
              ),
            ),
          ),

          // Draggable SOS Button
          Positioned(
            right: _sosPosition.dx,
            bottom: _sosPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _sosPosition = Offset(
                    (_sosPosition.dx - details.delta.dx).clamp(20.0, size.width - 80),
                    (_sosPosition.dy - details.delta.dy).clamp(-size.height + 180, -20.0),
                  );
                });
              },
              child: FloatingActionButton(
                onPressed: _showSOSDialog,
                backgroundColor: Colors.red,
                child: const Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                heroTag: 'sos_main',
              ),
            ),
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
        title: Text(_isEnglish ? "Today's Tasks" : 'आज के कार्य'),
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
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      _isEnglish ? 'EN' : 'HI',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.language, color: Colors.white, size: 16),
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
}
