import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class IncentiveTrackerScreen extends StatefulWidget {
  const IncentiveTrackerScreen({Key? key}) : super(key: key);

  @override
  State<IncentiveTrackerScreen> createState() => _IncentiveTrackerScreenState();
}

class _IncentiveTrackerScreenState extends State<IncentiveTrackerScreen> {
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

  void _showAppTour() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isEnglish ? '📱 App Tour' : '📱 ऐप टूर'),
        content: Text(
          _isEnglish
              ? '''Incentive Tracker Tab

Track your monthly earnings:
• Daily task completions
• Bonus achievements
• Performance incentives
• Payment history

View payment status:
💰 Received = Paid to account
⏳ Pending = Awaiting approval
❌ Failed = Issue with claim

Ensure all tasks are completed to maximize earnings.'''
              : '''प्रोत्साहन ट्रैकर टैब

अपनी मासिक कमाई ट्रैक करें:
• दैनिक कार्य पूरा होना
• बोनस उपलब्धियां
• प्रदर्शन प्रोत्साहन
• भुगतान इतिहास

भुगतान स्थिति देखें:
💰 प्राप्त = खाते में भुगतान
⏳ लंबित = अनुमोदन की प्रतीक्षा
❌ विफल = दावे में समस्या

कमाई को अधिकतम करने के लिए सभी कार्य पूरे करें।''',
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
        title: Text(_isEnglish ? 'Incentive Tracker' : 'प्रोत्साहन ट्रैकर'),
        elevation: 0,
        actions: [
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
                    _buildIncentiveCard('January Earnings', '₹2,450', 'Pending', Colors.orange),
                    _buildIncentiveCard('December Earnings', '₹2,800', 'Received', Colors.green),
                    _buildIncentiveCard('November Earnings', '₹2,300', 'Received', Colors.green),
                    _buildIncentiveCard('October Earnings', '₹2,650', 'Received', Colors.green),
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
              // Already here
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/monthly_summary');
              break;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: index == 3 ? AppTheme.primaryTeal : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            tabs[index],
            style: TextStyle(
              fontSize: 14,
              fontWeight: index == 3 ? FontWeight.bold : FontWeight.normal,
              color: index == 3 ? AppTheme.primaryTeal : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncentiveCard(String title, String amount, String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(status, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryTeal)),
          ],
        ),
      ),
    );
  }
}
