import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isEnglish = true;
  Timer? _sosTimer;
  bool _sosActive = false;
  
  // Draggable button positions
  Offset _sosPosition = const Offset(0, 0);
  Offset _voicePosition = const Offset(0, 0);

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

  void _openVoiceAssistant() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEnglish ? '🎤 Voice Assistant Activated' : '🎤 वॉइस सहायक सक्रिय',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryTeal,
                child: const Text('PS', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 16),
              Text(
                'Priya Sharma',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _isEnglish ? 'ASHA Worker' : 'आशा कार्यकर्ता',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _buildProfileInfo(Icons.phone, '+91 98765 43210'),
              const SizedBox(height: 12),
              _buildProfileInfo(Icons.email, 'priya.sharma@aasha.gov.in'),
              const SizedBox(height: 12),
              _buildProfileInfo(Icons.location_on, _isEnglish ? 'Sector 12, Delhi' : 'सेक्टर 12, दिल्ली'),
              const SizedBox(height: 12),
              _buildProfileInfo(Icons.badge, 'ID: ASHA-DL-2024-1234'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.logout),
                  label: Text(
                    _isEnglish ? 'Sign Out' : 'साइन आउट करें',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryTeal, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppTheme.primaryTeal, size: 24),
          ),
          onPressed: _showProfileDialog,
        ),
        title: Text(_isEnglish ? 'AASHA Sathi' : 'आशा साथी'),
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
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              // Greeting - Stylish centered design
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _isEnglish ? 'Welcome' : 'स्वागत है',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.primaryTeal,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isEnglish ? 'Priya Sharma' : 'प्रिया शर्मा',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 3,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.accentTeal,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              // 5 Navigation Buttons
              _buildNavButton(
                icon: Icons.assignment,
                title: _isEnglish ? "Today's Task" : 'आज का कार्य',
                description: _isEnglish ? 'View your daily tasks' : 'अपने दैनिक कार्य देखें',
                color: Colors.blue,
                route: '/todays_task',
              ),
              const SizedBox(height: 8),
              _buildNavButton(
                icon: Icons.warning,
                title: _isEnglish ? 'Emergency Alert' : 'आपातकाल सतर्कता',
                description: _isEnglish ? 'Critical health alerts' : 'महत्वपूर्ण स्वास्थ्य सतर्कता',
                color: Colors.red,
                route: '/emergency_alert',
              ),
              const SizedBox(height: 8),
              _buildNavButton(
                icon: Icons.people,
                title: _isEnglish ? 'Patient Management' : 'रोगी प्रबंधन',
                description: _isEnglish ? 'Manage your patients' : 'अपने रोगियों का प्रबंधन करें',
                color: Colors.teal,
                route: '/patient_management',
              ),
              const SizedBox(height: 8),
              _buildNavButton(
                icon: Icons.paid,
                title: _isEnglish ? 'Incentive Tracker' : 'प्रोत्साहन ट्रैकर',
                description: _isEnglish ? 'Track your earnings' : 'अपनी कमाई ट्रैक करें',
                color: Colors.green,
                route: '/incentive_tracker',
              ),
              const SizedBox(height: 8),
              _buildNavButton(
                icon: Icons.bar_chart,
                title: _isEnglish ? 'Monthly Summary' : 'मासिक सारांश',
                description: _isEnglish ? 'View your statistics' : 'अपने आंकड़े देखें',
                color: Colors.purple,
                route: '/monthly_summary',
              ),
            ],
          ),
          // Draggable Voice Assistant Button - Lower Right
          Positioned(
            right: 16 - _voicePosition.dx,
            bottom: 16 - _voicePosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _voicePosition = Offset(
                    _voicePosition.dx + details.delta.dx,
                    _voicePosition.dy + details.delta.dy,
                  );
                });
              },
              child: Material(
                color: AppTheme.accentTeal,
                borderRadius: BorderRadius.circular(50),
                elevation: 6,
                child: InkWell(
                  onTap: _openVoiceAssistant,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Hero(
                      tag: 'voice_home',
                      child: Icon(Icons.mic, size: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Draggable SOS Button - Lower Left
          Positioned(
            left: 16 + _sosPosition.dx,
            bottom: 16 - _sosPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _sosPosition = Offset(
                    _sosPosition.dx + details.delta.dx,
                    _sosPosition.dy + details.delta.dy,
                  );
                });
              },
              child: Material(
                color: Colors.red,
                borderRadius: BorderRadius.circular(50),
                elevation: 6,
                child: InkWell(
                  onTap: _showSOSDialog,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Hero(
                      tag: 'sos_home',
                      child: Icon(Icons.warning, size: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: color, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

