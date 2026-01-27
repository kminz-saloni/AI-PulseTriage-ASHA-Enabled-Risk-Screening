import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class FloatingActionButtonsWidget extends StatefulWidget {
  final bool isEnglish;
  final Offset? initialSosPosition;
  final Offset? initialVoicePosition;
  final Function(Offset)? onSosPositionChanged;
  final Function(Offset)? onVoicePositionChanged;

  const FloatingActionButtonsWidget({
    Key? key,
    required this.isEnglish,
    this.initialSosPosition,
    this.initialVoicePosition,
    this.onSosPositionChanged,
    this.onVoicePositionChanged,
  }) : super(key: key);

  @override
  State<FloatingActionButtonsWidget> createState() => _FloatingActionButtonsWidgetState();
}

class _FloatingActionButtonsWidgetState extends State<FloatingActionButtonsWidget> {
  Timer? _sosTimer;
  bool _sosActive = false;
  late Offset _sosPosition;
  late Offset _voicePosition;

  @override
  void initState() {
    super.initState();
    _sosPosition = widget.initialSosPosition ?? const Offset(16, 80);
    _voicePosition = widget.initialVoicePosition ?? const Offset(16, 80);
  }

  @override
  void didUpdateWidget(FloatingActionButtonsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update positions when switching tabs
    if (oldWidget.initialSosPosition != widget.initialSosPosition ||
        oldWidget.initialVoicePosition != widget.initialVoicePosition) {
      setState(() {
        _sosPosition = widget.initialSosPosition ?? const Offset(16, 80);
        _voicePosition = widget.initialVoicePosition ?? const Offset(16, 80);
      });
    }
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
        title: Text(
          widget.isEnglish ? 'Emergency Alert' : 'आपातकाल सतर्कता',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Text(
          widget.isEnglish
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
            child: Text(widget.isEnglish ? 'No' : 'नहीं'),
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
            child: Text(
              widget.isEnglish ? 'Yes, Emergency!' : 'हाँ, आपातकाल!',
              style: const TextStyle(color: Colors.white),
            ),
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
          widget.isEnglish
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
          widget.isEnglish ? '🎤 Voice Assistant Activated' : '🎤 आवाज़ सहायक सक्रिय',
        ),
        backgroundColor: AppTheme.primaryTeal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Draggable SOS Button (Bottom-left)
        Positioned(
          left: _sosPosition.dx,
          bottom: _sosPosition.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _sosPosition = Offset(
                  (_sosPosition.dx + details.delta.dx).clamp(0.0, size.width - 80),
                  (_sosPosition.dy - details.delta.dy).clamp(20.0, size.height - 180),
                );
              });
              widget.onSosPositionChanged?.call(_sosPosition);
            },
            child: FloatingActionButton(
              onPressed: _showSOSDialog,
              backgroundColor: Colors.red,
              heroTag: 'sos_${DateTime.now().millisecondsSinceEpoch}',
              child: const Icon(
                Icons.warning,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),

        // Draggable Voice Assistant Button (Bottom-right)
        Positioned(
          right: _voicePosition.dx,
          bottom: _voicePosition.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _voicePosition = Offset(
                  (_voicePosition.dx - details.delta.dx).clamp(0.0, size.width - 80),
                  (_voicePosition.dy - details.delta.dy).clamp(20.0, size.height - 180),
                );
              });
              widget.onVoicePositionChanged?.call(_voicePosition);
            },
            child: FloatingActionButton(
              onPressed: _openVoiceAssistant,
              backgroundColor: AppTheme.primaryTeal,
              heroTag: 'voice_${DateTime.now().millisecondsSinceEpoch}',
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
