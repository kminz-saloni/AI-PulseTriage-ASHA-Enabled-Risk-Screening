import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_app_bar.dart';
import '../models/models.dart';

enum FollowUpStatus { dueToday, overdue, upcoming }
enum PatientCategory { pregnant, child, elderly }

class FollowUp {
  final String id;
  final String patientName;
  final PatientCategory category;
  final String followUpReason;
  final DateTime scheduledDate;
  final FollowUpStatus status;
  final RiskLevel riskLevel;
  bool isCompleted;

  FollowUp({
    required this.id,
    required this.patientName,
    required this.category,
    required this.followUpReason,
    required this.scheduledDate,
    required this.status,
    required this.riskLevel,
    this.isCompleted = false,
  });
}

class FollowupsScreen extends StatefulWidget {
  const FollowupsScreen({Key? key}) : super(key: key);

  @override
  State<FollowupsScreen> createState() => _FollowupsScreenState();
}

class _FollowupsScreenState extends State<FollowupsScreen> {
  bool _isEnglish = true;
  String _selectedFilter = 'Due Today';

  // Sample follow-up data
  final List<FollowUp> _allFollowUps = [
    FollowUp(
      id: 'FU001',
      patientName: 'Sunita Devi',
      category: PatientCategory.pregnant,
      followUpReason: 'Postnatal check',
      scheduledDate: DateTime.now(),
      status: FollowUpStatus.dueToday,
      riskLevel: RiskLevel.medium,
    ),
    FollowUp(
      id: 'FU002',
      patientName: 'Ravi Kumar',
      category: PatientCategory.child,
      followUpReason: 'Immunization follow-up',
      scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
      status: FollowUpStatus.overdue,
      riskLevel: RiskLevel.high,
    ),
    FollowUp(
      id: 'FU003',
      patientName: 'Laxmi Bai',
      category: PatientCategory.elderly,
      followUpReason: 'Blood pressure monitoring',
      scheduledDate: DateTime.now().subtract(const Duration(days: 1)),
      status: FollowUpStatus.overdue,
      riskLevel: RiskLevel.high,
    ),
    FollowUp(
      id: 'FU004',
      patientName: 'Anita Sharma',
      category: PatientCategory.pregnant,
      followUpReason: 'Antenatal check-up',
      scheduledDate: DateTime.now(),
      status: FollowUpStatus.dueToday,
      riskLevel: RiskLevel.low,
    ),
    FollowUp(
      id: 'FU005',
      patientName: 'Baby Priya',
      category: PatientCategory.child,
      followUpReason: 'Fever review',
      scheduledDate: DateTime.now().add(const Duration(days: 2)),
      status: FollowUpStatus.upcoming,
      riskLevel: RiskLevel.medium,
    ),
    FollowUp(
      id: 'FU006',
      patientName: 'Ram Singh',
      category: PatientCategory.elderly,
      followUpReason: 'Diabetes check-up',
      scheduledDate: DateTime.now().add(const Duration(days: 3)),
      status: FollowUpStatus.upcoming,
      riskLevel: RiskLevel.low,
    ),
  ];

  List<FollowUp> get _filteredFollowUps {
    List<FollowUp> filtered;

    switch (_selectedFilter) {
      case 'Due Today':
      case 'आज देय':
        filtered = _allFollowUps.where((f) => f.status == FollowUpStatus.dueToday && !f.isCompleted).toList();
        break;
      case 'Overdue':
      case 'विलंबित':
        filtered = _allFollowUps.where((f) => f.status == FollowUpStatus.overdue && !f.isCompleted).toList();
        break;
      case 'Upcoming':
      case 'आगामी':
        filtered = _allFollowUps.where((f) => f.status == FollowUpStatus.upcoming && !f.isCompleted).toList();
        break;
      case 'High Risk':
      case 'उच्च जोखिम':
        filtered = _allFollowUps.where((f) => f.riskLevel == RiskLevel.high && !f.isCompleted).toList();
        break;
      default:
        filtered = _allFollowUps.where((f) => !f.isCompleted).toList();
    }

    // Sort: Overdue first, then Due Today, then Upcoming
    filtered.sort((a, b) {
      if (a.status == b.status) {
        return a.scheduledDate.compareTo(b.scheduledDate);
      }
      if (a.status == FollowUpStatus.overdue) return -1;
      if (b.status == FollowUpStatus.overdue) return 1;
      if (a.status == FollowUpStatus.dueToday) return -1;
      if (b.status == FollowUpStatus.dueToday) return 1;
      return 0;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLighter,
      appBar: CommonAppBar(
        title: _isEnglish ? 'Follow-ups' : 'फॉलो-अप्स',
        isEnglish: _isEnglish,
        onLanguageToggle: () => setState(() => _isEnglish = !_isEnglish),
        onHomePressed: () {
          Navigator.of(context).pop();
        },
        showHomeIcon: true,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _filteredFollowUps.isEmpty
                ? _buildEmptyState()
                : _buildFollowUpList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    final filters = _isEnglish
        ? ['Due Today', 'Overdue', 'Upcoming', 'High Risk']
        : ['आज देय', 'विलंबित', 'आगामी', 'उच्च जोखिम'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.lg, vertical: AppTheme.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter ||
                (_isEnglish && _selectedFilter == filter) ||
                (!_isEnglish && _getEnglishFilter(filter) == _selectedFilter);
            
            return Padding(
              padding: const EdgeInsets.only(right: AppTheme.sm),
              child: FilterChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.primaryTeal,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = _isEnglish ? filter : _getEnglishFilter(filter);
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: AppTheme.primaryTeal,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryTeal : AppTheme.borderColor,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.md, vertical: AppTheme.sm),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getEnglishFilter(String hindiFilter) {
    switch (hindiFilter) {
      case 'आज देय':
        return 'Due Today';
      case 'विलंबित':
        return 'Overdue';
      case 'आगामी':
        return 'Upcoming';
      case 'उच्च जोखिम':
        return 'High Risk';
      default:
        return hindiFilter;
    }
  }

  Widget _buildFollowUpList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.lg),
      itemCount: _filteredFollowUps.length,
      itemBuilder: (context, index) {
        return _buildFollowUpCard(_filteredFollowUps[index]);
      },
    );
  }

  Widget _buildFollowUpCard(FollowUp followUp) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.lg),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: BorderSide(
          color: _getRiskColor(followUp.riskLevel).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and risk indicator
            Row(
              children: [
                // Risk indicator dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getRiskColor(followUp.riskLevel),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppTheme.sm),
                Expanded(
                  child: Text(
                    followUp.patientName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
                _buildStatusBadge(followUp.status),
              ],
            ),
            const SizedBox(height: AppTheme.md),
            
            // Patient category
            Row(
              children: [
                Icon(
                  _getCategoryIcon(followUp.category),
                  size: 18,
                  color: AppTheme.primaryTeal,
                ),
                const SizedBox(width: AppTheme.sm),
                Text(
                  _getCategoryText(followUp.category),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.mediumText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.sm),
            
            // Follow-up reason
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.medical_services_outlined,
                  size: 18,
                  color: AppTheme.primaryTeal,
                ),
                const SizedBox(width: AppTheme.sm),
                Expanded(
                  child: Text(
                    followUp.followUpReason,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.sm),
            
            // Scheduled date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppTheme.primaryTeal,
                ),
                const SizedBox(width: AppTheme.sm),
                Text(
                  _formatDate(followUp.scheduledDate),
                  style: TextStyle(
                    fontSize: 14,
                    color: followUp.status == FollowUpStatus.overdue
                        ? AppTheme.emergencyRed
                        : AppTheme.mediumText,
                    fontWeight: followUp.status == FollowUpStatus.overdue
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.lg),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showMarkCompletedDialog(followUp);
                    },
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(
                      _isEnglish ? 'Mark Completed' : 'पूर्ण करें',
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.successGreen,
                      side: const BorderSide(color: AppTheme.successGreen),
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showPatientDetails(followUp);
                    },
                    icon: const Icon(Icons.visibility, size: 18),
                    label: Text(
                      _isEnglish ? 'View Details' : 'विवरण देखें',
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(FollowUpStatus status) {
    String text;
    Color color;

    switch (status) {
      case FollowUpStatus.dueToday:
        text = _isEnglish ? 'Due Today' : 'आज देय';
        color = AppTheme.warningOrange;
        break;
      case FollowUpStatus.overdue:
        text = _isEnglish ? 'Overdue' : 'विलंबित';
        color = AppTheme.emergencyRed;
        break;
      case FollowUpStatus.upcoming:
        text = _isEnglish ? 'Upcoming' : 'आगामी';
        color = AppTheme.secondaryBlue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.md, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.high:
        return AppTheme.riskHigh;
      case RiskLevel.medium:
        return AppTheme.riskMedium;
      case RiskLevel.low:
        return AppTheme.riskLow;
    }
  }

  IconData _getCategoryIcon(PatientCategory category) {
    switch (category) {
      case PatientCategory.pregnant:
        return Icons.pregnant_woman;
      case PatientCategory.child:
        return Icons.child_care;
      case PatientCategory.elderly:
        return Icons.elderly;
    }
  }

  String _getCategoryText(PatientCategory category) {
    switch (category) {
      case PatientCategory.pregnant:
        return _isEnglish ? 'Pregnant' : 'गर्भवती';
      case PatientCategory.child:
        return _isEnglish ? 'Child' : 'बच्चा';
      case PatientCategory.elderly:
        return _isEnglish ? 'Elderly' : 'वृद्ध';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return _isEnglish ? 'Today' : 'आज';
    } else if (dateOnly == yesterday) {
      return _isEnglish ? 'Yesterday' : 'कल';
    } else if (dateOnly == tomorrow) {
      return _isEnglish ? 'Tomorrow' : 'कल';
    } else if (dateOnly.isBefore(today)) {
      final daysDiff = today.difference(dateOnly).inDays;
      return _isEnglish ? '$daysDiff days overdue' : '$daysDiff दिन विलंबित';
    } else {
      final daysDiff = dateOnly.difference(today).inDays;
      return _isEnglish ? 'In $daysDiff days' : '$daysDiff दिनों में';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppTheme.xl),
            Text(
              _isEnglish
                  ? 'No follow-ups pending today'
                  : 'आज कोई फॉलो-अप लंबित नहीं है',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.md),
            Text(
              _isEnglish
                  ? 'Great job! All follow-ups are up to date.'
                  : 'बहुत बढ़िया! सभी फॉलो-अप अप-टू-डेट हैं।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showMarkCompletedDialog(FollowUp followUp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.successGreen, size: 28),
            const SizedBox(width: AppTheme.md),
            Expanded(
              child: Text(
                _isEnglish ? 'Mark as Completed?' : 'पूर्ण के रूप में चिह्नित करें?',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          _isEnglish
              ? 'Confirm that the follow-up for ${followUp.patientName} has been completed.'
              : '${followUp.patientName} के लिए फॉलो-अप पूरा हो गया है, पुष्टि करें।',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_isEnglish ? 'Cancel' : 'रद्द करें'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                followUp.isCompleted = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isEnglish
                        ? '✓ Follow-up marked as completed!'
                        : '✓ फॉलो-अप पूर्ण के रूप में चिह्नित!',
                  ),
                  backgroundColor: AppTheme.successGreen,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successGreen,
              foregroundColor: Colors.white,
            ),
            child: Text(_isEnglish ? 'Confirm' : 'पुष्टि करें'),
          ),
        ],
      ),
    );
  }

  void _showPatientDetails(FollowUp followUp) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(AppTheme.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getRiskColor(followUp.riskLevel),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppTheme.md),
                  Expanded(
                    child: Text(
                      followUp.patientName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.xl),
              
              // Patient details
              _buildDetailRow(
                Icons.category,
                _isEnglish ? 'Category' : 'श्रेणी',
                _getCategoryText(followUp.category),
              ),
              const SizedBox(height: AppTheme.lg),
              _buildDetailRow(
                Icons.medical_services,
                _isEnglish ? 'Follow-up Reason' : 'फॉलो-अप कारण',
                followUp.followUpReason,
              ),
              const SizedBox(height: AppTheme.lg),
              _buildDetailRow(
                Icons.calendar_today,
                _isEnglish ? 'Scheduled Date' : 'निर्धारित तिथि',
                _formatDate(followUp.scheduledDate),
              ),
              const SizedBox(height: AppTheme.lg),
              _buildDetailRow(
                Icons.warning_amber,
                _isEnglish ? 'Risk Level' : 'जोखिम स्तर',
                _getRiskLevelText(followUp.riskLevel),
                valueColor: _getRiskColor(followUp.riskLevel),
              ),
              const SizedBox(height: AppTheme.xxl),
              
              // Note
              Container(
                padding: const EdgeInsets.all(AppTheme.lg),
                decoration: BoxDecoration(
                  color: AppTheme.bgLighter,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  _isEnglish
                      ? 'Note: Full patient profile integration coming soon. This screen currently shows follow-up details only.'
                      : 'नोट: पूर्ण रोगी प्रोफ़ाइल एकीकरण जल्द ही आ रहा है। यह स्क्रीन वर्तमान में केवल फॉलो-अप विवरण दिखाती है।',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryTeal),
        const SizedBox(width: AppTheme.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? AppTheme.darkText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getRiskLevelText(RiskLevel level) {
    switch (level) {
      case RiskLevel.high:
        return _isEnglish ? 'High Risk' : 'उच्च जोखिम';
      case RiskLevel.medium:
        return _isEnglish ? 'Medium Risk' : 'मध्यम जोखिम';
      case RiskLevel.low:
        return _isEnglish ? 'Low Risk' : 'कम जोखिम';
    }
  }
}
