import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({Key? key}) : super(key: key);

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  bool _isEnglish = true;
  Timer? _sosTimer;
  bool _sosActive = false;
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
              ? '🚨 SOS Activated!\n📍 Location shared with emergency contact\n📞 Calling emergency contact...'
              : '🚨 SOS सक्रिय!\n📍 स्थान आपातकाल संपर्क को भेजा गया\n📞 आपातकाल संपर्क को कॉल कर रहे हैं...',
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
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

  void _showAppTour() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isEnglish ? '📱 App Tour' : '📱 ऐप टूर'),
        content: Text(
          _isEnglish
              ? '''Monthly Summary Tab

View your performance metrics:
• Total visits completed
• Tasks completed
• Emergency alerts handled
• Average patient satisfaction rating
• Health outcomes achieved

This helps you track:
✓ Your productivity
✓ Quality of service
✓ Areas for improvement
✓ Performance trends

Use this data to improve your service delivery!'''
              : '''मासिक सारांश टैब

अपने प्रदर्शन मेट्रिक्स देखें:
• कुल दौरे पूरे किए
• पूर्ण कार्य
• आपातकाल सतर्कता संभाली गई
• औसत रोगी संतुष्टि रेटिंग
• स्वास्थ्य परिणाम प्राप्त

यह आपको ट्रैक करने में मदद करता है:
✓ आपकी उत्पादकता
✓ सेवा की गुणवत्ता
✓ सुधार के क्षेत्र
✓ प्रदर्शन प्रवृत्ति

अपनी सेवा वितरण को बेहतर बनाने के लिए इस डेटा का उपयोग करें!''',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_isEnglish ? 'Got it!' : 'समझ गए!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false),
          padding: EdgeInsets.zero,
        ),
        title: Text(_isEnglish ? 'Monthly Summary' : 'मासिक सारांश'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isEnglish ? 'Profile' : 'प्रोफ़ाइल'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            padding: EdgeInsets.zero,
          ),
          IconButton(
            icon: Text(_isEnglish ? 'EN' : 'हिन्दी', style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => setState(() => _isEnglish = !_isEnglish),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showAppTour,
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Navigation
          Container(
            color: AppTheme.primaryTeal.withOpacity(0.1),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildTabs(),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSummaryCard('Total Visits', '45', Icons.people, Colors.blue),
                    _buildSummaryCard('Tasks Completed', '38', Icons.check_circle, Colors.green),
                    _buildSummaryCard('Alerts Handled', '5', Icons.warning, Colors.orange),
                    _buildSummaryCard('Average Rating', '4.8/5', Icons.star, Colors.amber),
                    _buildSummaryCard('Vaccinations', '120', Icons.healing, Colors.teal),
                    _buildSummaryCard('Follow-ups Done', '28', Icons.assignment_turned_in, Colors.purple),
                  ],
                ),
                // Draggable Voice Assistant Button
                Positioned(
                  left: _voicePosition.dx,
                  top: MediaQuery.of(context).size.height - 200 + _voicePosition.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _voicePosition = Offset(
                          _voicePosition.dx + details.delta.dx,
                          _voicePosition.dy + details.delta.dy,
                        );
                      });
                    },
                    child: FloatingActionButton(
                      onPressed: _openVoiceAssistant,
                      mini: true,
                      backgroundColor: AppTheme.accentTeal,
                      child: const Icon(Icons.mic, size: 20),
                    ),
                  ),
                ),
                // Draggable SOS Button
                Positioned(
                  left: _sosPosition.dx,
                  top: MediaQuery.of(context).size.height - 130 + _sosPosition.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _sosPosition = Offset(
                          _sosPosition.dx + details.delta.dx,
                          _sosPosition.dy + details.delta.dy,
                        );
                      });
                    },
                    child: FloatingActionButton(
                      onPressed: _showSOSDialog,
                      backgroundColor: Colors.red,
                      child: const Text('SOS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTabs() {
    final tabs = [
      _isEnglish ? "Today's Task" : 'आज का कार्य',
      _isEnglish ? 'Emergency Alert' : 'आपातकाल सतर्कता',
      _isEnglish ? 'Patient Mgmt' : 'रोगी प्रबंधन',
      _isEnglish ? 'Incentive' : 'प्रोत्साहन',
      _isEnglish ? 'Summary' : 'सारांश',
    ];

    return List.generate(
      tabs.length,
      (index) => GestureDetector(
        onTap: () {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/todays_task');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/emergency_alert');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/patient_management');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/incentive_tracker');
              break;
            case 4:
              // Already here
              break;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: index == 4 ? AppTheme.primaryTeal : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            tabs[index],
            style: TextStyle(
              fontSize: 14,
              fontWeight: index == 4 ? FontWeight.bold : FontWeight.normal,
              color: index == 4 ? AppTheme.primaryTeal : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                  Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
