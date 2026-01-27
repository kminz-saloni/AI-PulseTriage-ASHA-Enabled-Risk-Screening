import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class TodaysTaskScreen extends StatefulWidget {
  const TodaysTaskScreen({Key? key}) : super(key: key);

  @override
  State<TodaysTaskScreen> createState() => _TodaysTaskScreenState();
}

// Task Model
class Task {
  final String id;
  final String title;
  final String titleHindi;
  final String taskType; // 'pregnancy', 'child', 'followup'
  final String priority; // 'high', 'normal'
  final String suggestedTime;
  final String suggestedTimeHindi;
  bool isCompleted;
  bool isHighlighted;

  Task({
    required this.id,
    required this.title,
    required this.titleHindi,
    required this.taskType,
    required this.priority,
    required this.suggestedTime,
    required this.suggestedTimeHindi,
    this.isCompleted = false,
    this.isHighlighted = false,
  });
}

class _TodaysTaskScreenState extends State<TodaysTaskScreen> {
  bool _isEnglish = true;
  Timer? _sosTimer;
  bool _sosActive = false;
  
  // Draggable button positions
  Offset _sosPosition = const Offset(0, 0);
  Offset _voicePosition = const Offset(0, 0);

  // Task List
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Visit pregnant woman – Sunita Devi',
      titleHindi: 'गर्भवती महिला की विजिट – सुनीता देवी',
      taskType: 'pregnancy',
      priority: 'high',
      suggestedTime: 'Before 12 PM',
      suggestedTimeHindi: 'दोपहर 12 बजे से पहले',
    ),
    Task(
      id: '2',
      title: 'Child vaccination – Rahul Kumar (18 months)',
      titleHindi: 'बच्चे का टीकाकरण – राहुल कुमार (18 माह)',
      taskType: 'vaccination',
      priority: 'high',
      suggestedTime: 'Before 2 PM',
      suggestedTimeHindi: 'दोपहर 2 बजे से पहले',
    ),
    Task(
      id: '3',
      title: 'Follow-up visit – Meera Sharma (Diabetes)',
      titleHindi: 'फॉलो-अप विजिट – मीरा शर्मा (मधुमेह)',
      taskType: 'diabetes',
      priority: 'normal',
      suggestedTime: 'Before 4 PM',
      suggestedTimeHindi: 'शाम 4 बजे से पहले',
      isCompleted: true,
    ),
    Task(
      id: '4',
      title: 'Health awareness session – Ward 5',
      titleHindi: 'स्वास्थ्य जागरूकता सत्र – वार्ड 5',
      taskType: 'awareness',
      priority: 'normal',
      suggestedTime: 'Evening 5-6 PM',
      suggestedTimeHindi: 'शाम 5-6 बजे',
    ),
    Task(
      id: '5',
      title: 'Newborn checkup – Baby of Kavita',
      titleHindi: 'नवजात शिशु जांच – कविता का बच्चा',
      taskType: 'newborn',
      priority: 'high',
      suggestedTime: 'Before 3 PM',
      suggestedTimeHindi: 'दोपहर 3 बजे से पहले',
      isCompleted: true,
    ),
    Task(
      id: '6',
      title: 'Medicine delivery – Ramesh Lal',
      titleHindi: 'दवा वितरण – रमेश लाल',
      taskType: 'medicine',
      priority: 'normal',
      suggestedTime: 'Anytime today',
      suggestedTimeHindi: 'आज कभी भी',
      isCompleted: true,
    ),
    Task(
      id: '7',
      title: 'Blood pressure check – Elderly group',
      titleHindi: 'रक्तचाप जांच – बुजुर्ग समूह',
      taskType: 'bloodpressure',
      priority: 'normal',
      suggestedTime: 'Morning 10-11 AM',
      suggestedTimeHindi: 'सुबह 10-11 बजे',
    ),
  ];

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  int get _totalCount => _tasks.length;

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

  IconData _getTaskIcon(String taskType) {
    switch (taskType) {
      case 'pregnancy':
        return Icons.pregnant_woman;
      case 'vaccination':
        return Icons.vaccines;
      case 'diabetes':
        return Icons.medication;
      case 'awareness':
        return Icons.campaign;
      case 'newborn':
        return Icons.baby_changing_station;
      case 'medicine':
        return Icons.local_pharmacy;
      case 'bloodpressure':
        return Icons.monitor_heart;
      default:
        return Icons.task;
    }
  }

  Color _getTaskIconColor(String taskType) {
    switch (taskType) {
      case 'pregnancy':
        return Colors.pink;
      case 'vaccination':
        return Colors.blue;
      case 'diabetes':
        return Colors.orange;
      case 'awareness':
        return Colors.purple;
      case 'newborn':
        return Colors.lightGreen;
      case 'medicine':
        return Colors.teal;
      case 'bloodpressure':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _toggleTaskHighlight(String taskId) {
    setState(() {
      for (var task in _tasks) {
        if (task.id == taskId) {
          task.isHighlighted = !task.isHighlighted;
        } else {
          task.isHighlighted = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    
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
              // Top Section - Date, Progress, Motivation
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryTeal, AppTheme.accentTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryTeal.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            today,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Progress Indicator
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _isEnglish ? 'Task Progress' : 'कार्य प्रगति',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_completedCount ${_isEnglish ? 'of' : 'में से'} $_totalCount ${_isEnglish ? 'completed' : 'पूर्ण'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Motivational Line
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _isEnglish ? 'You are doing great today!' : 'आप आज बहुत अच्छा कर रहे हैं!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Task List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return _buildTaskCard(task);
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
                      tag: 'voice_task',
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
                      tag: 'sos_task',
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

  Widget _buildTaskCard(Task task) {
    return GestureDetector(
      onTap: () => _toggleTaskHighlight(task.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          elevation: task.isHighlighted ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: task.isHighlighted ? AppTheme.primaryTeal : Colors.transparent,
              width: 2,
            ),
          ),
          child: Opacity(
            opacity: task.isCompleted ? 0.5 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: task.isHighlighted
                    ? LinearGradient(
                        colors: [
                          AppTheme.primaryTeal.withOpacity(0.1),
                          AppTheme.accentTeal.withOpacity(0.05),
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
                        // Task Type Icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getTaskIconColor(task.taskType).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getTaskIcon(task.taskType),
                            color: _getTaskIconColor(task.taskType),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Task Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Priority Badge & Completion Status
                              Row(
                                children: [
                                  if (task.priority == 'high')
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.red, width: 1),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.priority_high, color: Colors.red, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            _isEnglish ? 'HIGH' : 'उच्च',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (task.priority == 'normal')
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.amber, width: 1),
                                      ),
                                      child: Text(
                                        _isEnglish ? 'NORMAL' : 'सामान्य',
                                        style: const TextStyle(
                                          color: Colors.orange,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (task.isCompleted) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check_circle, color: Colors.green, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            _isEnglish ? 'DONE' : 'पूर्ण',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Task Title
                              Text(
                                _isEnglish ? task.title : task.titleHindi,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Suggested Time
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: task.priority == 'high' ? Colors.red : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isEnglish ? task.suggestedTime : task.suggestedTimeHindi,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: task.priority == 'high' ? Colors.red : Colors.grey[700],
                                      fontWeight: task.priority == 'high' ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
      ),
    );
  }
}
