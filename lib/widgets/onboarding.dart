import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Onboarding tour step
class TourStep {
  final String title;
  final String description;
  final Widget Function(BuildContext, VoidCallback, VoidCallback) buildOverlay;

  TourStep({
    required this.title,
    required this.description,
    required this.buildOverlay,
  });
}

/// Spotlight-style onboarding tour manager
class AppTourManager {
  static const String tourShownKey = 'app_tour_shown';

  static Future<bool> hasShownTour() async {
    // In production, use shared preferences
    // For now, return false to show tour on first run
    return false;
  }

  static Future<void> markTourAsShown() async {
    // In production, save to shared preferences
  }
}

/// Spotlight overlay for highlighting UI elements
class SpotlightOverlay extends StatefulWidget {
  final List<TourStep> steps;
  final VoidCallback onComplete;
  final VoidCallback? onSkip;

  const SpotlightOverlay({
    Key? key,
    required this.steps,
    required this.onComplete,
    this.onSkip,
  }) : super(key: key);

  @override
  State<SpotlightOverlay> createState() => _SpotlightOverlayState();
}

class _SpotlightOverlayState extends State<SpotlightOverlay> {
  late int _currentStep;
  late List<GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    _currentStep = 0;
    _keys = List.generate(widget.steps.length, (_) => GlobalKey());
  }

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _complete();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _complete() {
    AppTourManager.markTourAsShown();
    widget.onComplete();
  }

  void _skip() {
    AppTourManager.markTourAsShown();
    widget.onSkip?.call() ?? _complete();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentStep];
    final isLastStep = _currentStep == widget.steps.length - 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Dark overlay with spotlight
          GestureDetector(
            onTap: _nextStep,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              child: CustomPaint(
                painter: SpotlightPainter(
                  _getTargetRect(),
                  16,
                ),
              ),
            ),
          ),

          // Tutorial content positioned below spotlight
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step ${_currentStep + 1}/${widget.steps.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.mediumText,
                            letterSpacing: 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: _skip,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryTeal,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.lg),

                    // Title
                    Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: AppTheme.md),

                    // Description
                    Text(
                      step.description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.mediumText,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppTheme.xl),

                    // Progress dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.steps.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentStep
                                ? AppTheme.primaryTeal
                                : AppTheme.borderColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.xl),

                    // Action buttons
                    Row(
                      children: [
                        if (_currentStep > 0)
                          Expanded(
                            child: TextButton(
                              onPressed: _previousStep,
                              child: const Text('Back'),
                            ),
                          ),
                        const SizedBox(width: AppTheme.md),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLastStep ? _complete : _nextStep,
                            child: Text(
                              isLastStep
                                  ? 'Start Using App'
                                  : 'Next',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Rect _getTargetRect() {
    // Dummy rect - in production, use actual widget positions
    return Rect.fromLTWH(
      MediaQuery.of(context).size.width / 2 - 40,
      MediaQuery.of(context).size.height / 2 - 40,
      80,
      80,
    );
  }
}

/// Custom painter for spotlight effect
class SpotlightPainter extends CustomPainter {
  final Rect spotlight;
  final double radius;

  SpotlightPainter(this.spotlight, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(spotlight, Radius.circular(radius)),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(
      path,
      Paint()..color = Colors.black.withOpacity(0.7),
    );
  }

  @override
  bool shouldRepaint(SpotlightPainter oldDelegate) =>
      oldDelegate.spotlight != spotlight;
}

/// Simple onboarding screen alternative
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  late int _currentPage;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.home,
      title: 'Home Dashboard',
      description: 'This is your home screen for daily tasks. Access all patient information and tasks here.',
      color: AppTheme.primaryTeal,
    ),
    OnboardingPage(
      icon: Icons.mic,
      title: 'AI Assistant',
      description: 'Tap here anytime for guidance. Ask "What should I do next?" and get instant help.',
      color: AppTheme.accentTeal,
    ),
    OnboardingPage(
      icon: Icons.emergency,
      title: 'Emergency SOS',
      description: 'Use this in emergencies. Always available at the bottom-left. One tap gets help.',
      color: AppTheme.emergencyRed,
    ),
    OnboardingPage(
      icon: Icons.people,
      title: 'Manage Patients',
      description: 'View all patients, their health status, and visit history in one place.',
      color: AppTheme.primaryGreen,
    ),
    OnboardingPage(
      icon: Icons.trending_up,
      title: 'Track Incentives',
      description: 'Monitor your earnings and work summary. See what you\'ve accomplished.',
      color: AppTheme.warningOrange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  void _complete() {
    AppTourManager.markTourAsShown();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.lg),
                child: GestureDetector(
                  onTap: _complete,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryTeal,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(page: _pages[index]);
                },
              ),
            ),

            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.xl,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    width: index == _currentPage ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentPage
                          ? AppTheme.primaryTeal
                          : AppTheme.borderColor,
                    ),
                  ),
                ),
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(AppTheme.lg),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Start Using App'
                        : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Onboarding page data
class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

/// Onboarding page widget
class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 64,
              color: page.color,
            ),
          ),
          const SizedBox(height: AppTheme.xxl),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.lg),
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.mediumText,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
