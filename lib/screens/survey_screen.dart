import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/cards_buttons.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int currentQuestion = 0;
  final answers = <int, String>{};
  
  // SOS & Voice variables
  Timer? _sosTimer;
  bool _sosActive = false;
  Offset _sosPosition = const Offset(0, 0);
  Offset _voicePosition = const Offset(0, 0);

  final questions = [
    {
      'question': 'How easy was it to use AI PulseTriage?',
      'options': ['Very Hard', 'Hard', 'Easy', 'Very Easy'],
      'icons': [
        Icons.sentiment_very_dissatisfied,
        Icons.sentiment_dissatisfied,
        Icons.sentiment_satisfied,
        Icons.sentiment_very_satisfied,
      ],
    },
    {
      'question': 'Would you recommend this app to other ASHA workers?',
      'options': ['No', 'Maybe', 'Likely', 'Definitely'],
      'icons': [
        Icons.thumb_down,
        Icons.help_outline,
        Icons.thumb_up,
        Icons.favorite,
      ],
    },
    {
      'question': 'How helpful were the risk recommendations?',
      'options': ['Not Helpful', 'Somewhat', 'Helpful', 'Very Helpful'],
      'icons': [
        Icons.star_outline,
        Icons.star_half,
        Icons.star,
        Icons.star,
      ],
    },
  ];

  void _submitSurvey() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback!'),
        backgroundColor: AppTheme.riskLow,
        duration: Duration(seconds: 2),
      ),
    );
  }

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
        title: const Text(
          'Emergency Alert',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: const Text(
          'Are you in emergency?\nSOS will activate if you don\'t respond in 5 seconds.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              _sosTimer?.cancel();
              Navigator.pop(context);
              _sosActive = false;
            },
            child: const Text('No'),
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
            child: const Text('Yes, Emergency!'),
          ),
        ],
      ),
    );
  }

  void _activateSOS() {
    if (_sosActive) return;
    _sosActive = true;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '🚨 SOS Activated!\n📍 Location shared with emergency contact\n📞 Calling emergency contact...',
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _openVoiceAssistant() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎤 Voice Assistant Activated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Skip Survey?'),
            content: const Text('Your feedback helps us improve.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Continue'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Skip'),
              ),
            ],
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false),
            padding: EdgeInsets.zero,
          ),
          title: const Text('Quick Survey'),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'EN',
                        style: TextStyle(
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
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinearProgressIndicator(
                      value: (currentQuestion + 1) / questions.length,
                      minHeight: 6,
                      backgroundColor: AppTheme.borderColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Question ${currentQuestion + 1} of ${questions.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question['question'] as String,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ...List.generate(
                      (question['options'] as List).length,
                      (index) {
                        final option = (question['options'] as List)[index];
                        final icon = (question['icons'] as List)[index];
                        final isSelected = answers[currentQuestion] == option;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                answers[currentQuestion] = option as String;
                              });
                            },
                            child: Card(
                              color: isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : AppTheme.cardBg,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Icon(
                                      icon as IconData,
                                      size: 48,
                                      color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumText,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      option as String,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected ? AppTheme.primaryBlue : AppTheme.darkText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    if (currentQuestion == questions.length - 1)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Optional: Any comments?',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Share your thoughts (optional)',
                              hintStyle: TextStyle(color: AppTheme.lightText),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppTheme.borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppTheme.borderColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            // SOS Button
            Positioned(
              left: _sosPosition.dx,
              bottom: _sosPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _sosPosition = Offset(
                      (_sosPosition.dx + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - 60),
                      (_sosPosition.dy - details.delta.dy).clamp(0.0, MediaQuery.of(context).size.height - 200),
                    );
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showSOSDialog,
                      customBorder: const CircleBorder(),
                      child: const Icon(Icons.sos, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),
            ),
            // Voice Assistant Button
            Positioned(
              left: _voicePosition.dx,
              bottom: _voicePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _voicePosition = Offset(
                      (_voicePosition.dx + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - 60),
                      (_voicePosition.dy - details.delta.dy).clamp(0.0, MediaQuery.of(context).size.height - 200),
                    );
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.accentTeal,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentTeal.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _openVoiceAssistant,
                      customBorder: const CircleBorder(),
                      child: const Icon(Icons.mic, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LargeButton(
                label: currentQuestion == questions.length - 1 ? 'Submit' : 'Next',
                onPressed: answers.containsKey(currentQuestion)
                    ? () {
                        if (currentQuestion < questions.length - 1) {
                          setState(() => currentQuestion++);
                        } else {
                          _submitSurvey();
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Skip Survey',
                    style: TextStyle(color: AppTheme.mediumText),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
