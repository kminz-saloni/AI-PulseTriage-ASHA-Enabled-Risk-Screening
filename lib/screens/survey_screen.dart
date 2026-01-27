import 'package:flutter/material.dart';
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
          title: const Text('Quick Survey'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
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
