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
      appBar: CommonAppBar(
        title: _isEnglish ? 'Incentive Tracker' : 'प्रोत्साहन ट्रैकर',
        isEnglish: _isEnglish,
        onLanguageToggle: () => setState(() => _isEnglish = !_isEnglish),
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
                
                // Floating Action Buttons (SOS & Voice)
                FloatingActionButtonsWidget(
                  key: const ValueKey('incentive_screen_buttons'),
                  isEnglish: _isEnglish,
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
