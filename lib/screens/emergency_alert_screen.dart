import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class EmergencyAlertScreen extends StatefulWidget {
  const EmergencyAlertScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyAlertScreen> createState() => _EmergencyAlertScreenState();
}

// Emergency Model
class EmergencyCase {
  final String id;
  final String patientName;
  final String patientNameHindi;
  final String category; // 'pregnant', 'child', 'elderly'
  final String reason;
  final String reasonHindi;
  final String priority; // 'emergency', 'urgent'
  final DateTime alertTime;
  bool isHighlighted;

  EmergencyCase({
    required this.id,
    required this.patientName,
    required this.patientNameHindi,
    required this.category,
    required this.reason,
    required this.reasonHindi,
    required this.priority,
    required this.alertTime,
    this.isHighlighted = false,
  });

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(alertTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  String getTimeAgoHindi() {
    final now = DateTime.now();
    final difference = now.difference(alertTime);
    
    if (difference.inMinutes < 1) {
      return 'अभी';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} मिनट पहले';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} घंटे पहले';
    } else {
      return '${difference.inDays} दिन पहले';
    }
  }
}

class _EmergencyAlertScreenState extends State<EmergencyAlertScreen> {
  bool _isEnglish = true;
  Timer? _sosTimer;
  bool _sosActive = false;
  
  // Draggable button positions
  Offset _sosPosition = const Offset(0, 0);
  Offset _voicePosition = const Offset(0, 0);

  // Emergency List
  final List<EmergencyCase> _emergencies = [
    EmergencyCase(
      id: '1',
      patientName: 'Sunita Devi',
      patientNameHindi: 'सुनीता देवी',
      category: 'pregnant',
      reason: 'Severe abdominal pain, 8 months pregnant',
      reasonHindi: 'गंभीर पेट दर्द, 8 माह गर्भवती',
      priority: 'emergency',
      alertTime: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    EmergencyCase(
      id: '2',
      patientName: 'Baby Rahul',
      patientNameHindi: 'बेबी राहुल',
      category: 'child',
      reason: 'High fever (104°F), difficulty breathing',
      reasonHindi: 'तेज बुखार (104°F), सांस लेने में कठिनाई',
      priority: 'emergency',
      alertTime: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    EmergencyCase(
      id: '3',
      patientName: 'Ram Lal (72)',
      patientNameHindi: 'राम लाल (72)',
      category: 'elderly',
      reason: 'Chest pain, dizziness',
      reasonHindi: 'सीने में दर्द, चक्कर आना',
      priority: 'urgent',
      alertTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  int get _activeCount => _emergencies.length;
  int get _emergencyCount => _emergencies.where((e) => e.priority == 'emergency').length;

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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'pregnant':
        return Icons.pregnant_woman;
      case 'child':
        return Icons.child_care;
      case 'elderly':
        return Icons.elderly;
      default:
        return Icons.person;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'pregnant':
        return Colors.pink;
      case 'child':
        return Colors.orange;
      case 'elderly':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _toggleHighlight(String caseId) {
    setState(() {
      for (var emergency in _emergencies) {
        if (emergency.id == caseId) {
          emergency.isHighlighted = !emergency.isHighlighted;
        } else {
          emergency.isHighlighted = false;
        }
      }
    });
  }

  void _callTelemedicine(String patientName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEnglish 
              ? '📞 Starting telemedicine call with $patientName...' 
              : '📞 $patientName के साथ टेलीमेडिसिन कॉल शुरू हो रही है...',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.primaryTeal,
      ),
    );
  }

  void _callAmbulance(String patientName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEnglish 
              ? '🚑 Calling ambulance for $patientName...' 
              : '🚑 $patientName के लिए एम्बुलेंस बुला रहे हैं...',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _viewDetails(String patientName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEnglish 
              ? 'Viewing details for $patientName' 
              : '$patientName का विवरण देख रहे हैं',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort emergencies: priority 'emergency' first, then by time
    final sortedEmergencies = List<EmergencyCase>.from(_emergencies)
      ..sort((a, b) {
        if (a.priority == b.priority) {
          return b.alertTime.compareTo(a.alertTime); // Newest first
        }
        return a.priority == 'emergency' ? -1 : 1; // Emergency first
      });

    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
            ),
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        leadingWidth: 100,
        title: Text(_isEnglish ? 'Active Emergencies' : 'सक्रिय आपात स्थिति'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.red[700],
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
          Column(
            children: [
              // Top Section - Count Badge
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[700]!, Colors.red[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_rounded, color: Colors.white, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              '$_emergencyCount ${_isEnglish ? 'Active' : 'सक्रिय'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Emergency List
              Expanded(
                child: sortedEmergencies.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 80,
                              color: Colors.green[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _isEnglish ? 'No Active Emergencies' : 'कोई सक्रिय आपात स्थिति नहीं',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: sortedEmergencies.length,
                        itemBuilder: (context, index) {
                          final emergency = sortedEmergencies[index];
                          return _buildEmergencyCard(emergency);
                        },
                      ),
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
                      tag: 'voice_emergency',
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
                      tag: 'sos_emergency',
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

  Widget _buildEmergencyCard(EmergencyCase emergency) {
    return GestureDetector(
      onTap: () => _toggleHighlight(emergency.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        child: Card(
          elevation: emergency.isHighlighted ? 8 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: emergency.isHighlighted 
                  ? (emergency.priority == 'emergency' ? Colors.red : Colors.orange)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: emergency.isHighlighted
                  ? LinearGradient(
                      colors: [
                        (emergency.priority == 'emergency' ? Colors.red : Colors.orange).withOpacity(0.1),
                        (emergency.priority == 'emergency' ? Colors.red : Colors.orange).withOpacity(0.05),
                      ],
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(emergency.category).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(emergency.category),
                          color: _getCategoryColor(emergency.category),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Patient Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Priority Badge & Time
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: emergency.priority == 'emergency' 
                                        ? Colors.red.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: emergency.priority == 'emergency' ? Colors.red : Colors.orange,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: emergency.priority == 'emergency' ? Colors.red : Colors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _isEnglish 
                                            ? (emergency.priority == 'emergency' ? 'EMERGENCY' : 'URGENT')
                                            : (emergency.priority == 'emergency' ? 'आपातकाल' : 'तत्काल'),
                                        style: TextStyle(
                                          color: emergency.priority == 'emergency' ? Colors.red : Colors.orange,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _isEnglish ? emergency.getTimeAgo() : emergency.getTimeAgoHindi(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Patient Name
                            Text(
                              _isEnglish ? emergency.patientName : emergency.patientNameHindi,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Category Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(emergency.category).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _isEnglish 
                                    ? (emergency.category == 'pregnant' ? 'Pregnant' : 
                                       emergency.category == 'child' ? 'Child' : 'Elderly')
                                    : (emergency.category == 'pregnant' ? 'गर्भवती' : 
                                       emergency.category == 'child' ? 'बच्चा' : 'बुजुर्ग'),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _getCategoryColor(emergency.category),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Emergency Reason
                            Text(
                              _isEnglish ? emergency.reason : emergency.reasonHindi,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () => _callTelemedicine(_isEnglish ? emergency.patientName : emergency.patientNameHindi),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.videocam, size: 18),
                          label: Text(
                            _isEnglish ? 'Call' : 'कॉल',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          onPressed: () => _callAmbulance(_isEnglish ? emergency.patientName : emergency.patientNameHindi),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.local_hospital, size: 18),
                          label: Text(
                            _isEnglish ? 'Ambulance' : 'एम्बुलेंस',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _viewDetails(_isEnglish ? emergency.patientName : emergency.patientNameHindi),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Icon(Icons.info_outline, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
