import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom scaffold with persistent SOS (bottom-left) and AI Assistant (bottom-right) buttons
class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBottomNav;
  final VoidCallback? onAIButtonPressed;
  final VoidCallback? onSOSButtonPressed;
  final PreferredSizeWidget? appBar;
  final bool centerTitle;
  final bool showAppBar;

  const AppScaffold({
    Key? key,
    required this.body,
    this.title,
    this.actions,
    this.showBottomNav = false,
    this.onAIButtonPressed,
    this.onSOSButtonPressed,
    this.appBar,
    this.centerTitle = true,
    this.showAppBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? appBar ??
              AppBar(
                title: title != null ? Text(title!) : null,
                centerTitle: centerTitle,
                actions: actions,
              )
          : null,
      body: body,
      floatingActionButton: _buildFloatingButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildFloatingButtons() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24 + 20, // Account for bottom nav + extra padding
        right: 16,
        left: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SOS Button (Bottom-Left)
          FloatingActionButton(
            onPressed: onSOSButtonPressed ?? () {},
            backgroundColor: AppTheme.emergencyRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.emergency, size: 24),
            heroTag: 'sos_button',
          ),
          
          // AI Assistant Button (Bottom-Right)
          FloatingActionButton(
            onPressed: onAIButtonPressed ?? () {},
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.mic, size: 24),
            heroTag: 'ai_button',
          ),
        ],
      ),
    );
  }
}
