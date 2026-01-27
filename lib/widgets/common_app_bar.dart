import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isEnglish;
  final VoidCallback onLanguageToggle;
  final VoidCallback? onHomePressed;
  final bool showHomeIcon;
  final Color? backgroundColor;

  const CommonAppBar({
    Key? key,
    required this.title,
    required this.isEnglish,
    required this.onLanguageToggle,
    this.onHomePressed,
    this.showHomeIcon = true,
    this.backgroundColor,
  }) : super(key: key);

  void _showProfileModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Icon
              CircleAvatar(
                radius: 35,
                backgroundColor: AppTheme.primaryTeal.withOpacity(0.2),
                child: const Icon(Icons.person, size: 40, color: AppTheme.primaryTeal),
              ),
              const SizedBox(height: 16),
              // Name
              const Text(
                'Priya Sharma',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                isEnglish ? 'ASHA Worker' : 'आशा कार्यकर्ता',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              // Details
              _buildInfoRow(Icons.badge, 'ID: ASH001'),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.phone, '+91 98765 43210'),
              const SizedBox(height: 20),
              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  icon: const Icon(Icons.logout, size: 18),
                  label: Text(isEnglish ? 'Sign Out' : 'साइन आउट'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryTeal, size: 18),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showHomeIcon
          ? IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 24),
              onPressed: onHomePressed ?? () {
                Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
              },
              padding: EdgeInsets.zero,
              tooltip: isEnglish ? 'Home' : 'होम',
            )
          : null,
      title: Text(title),
      elevation: 0,
      centerTitle: true,
      backgroundColor: backgroundColor ?? AppTheme.primaryTeal,
      actions: [
        // Language Switcher
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 4.0),
          child: GestureDetector(
            onTap: onLanguageToggle,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isEnglish ? Icons.language : Icons.translate,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isEnglish ? 'EN' : 'हिन्दी',
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
        // Profile Icon
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white, size: 24),
          onPressed: () => _showProfileModal(context),
          padding: EdgeInsets.zero,
          tooltip: isEnglish ? 'Profile' : 'प्रोफ़ाइल',
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProfileModal extends StatelessWidget {
  final bool isEnglish;

  const ProfileModal({Key? key, required this.isEnglish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Profile Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryTeal.withOpacity(0.2),
            child: Icon(
              Icons.person,
              size: 60,
              color: AppTheme.primaryTeal,
            ),
          ),
          const SizedBox(height: 16),
          
          // User Name
          Text(
            isEnglish ? 'ASHA Worker' : 'आशा कार्यकर्ता',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Priya Sharma',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // User Details Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.badge,
                  isEnglish ? 'Worker ID' : 'कार्यकर्ता आईडी',
                  'ASH001',
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  Icons.phone,
                  isEnglish ? 'Contact' : 'संपर्क',
                  '+91 98765 43210',
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  Icons.location_on,
                  isEnglish ? 'Area' : 'क्षेत्र',
                  'Ward 12, Block A',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Sign Out Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: Text(
                isEnglish ? 'Sign Out' : 'साइन आउट',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryTeal, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
