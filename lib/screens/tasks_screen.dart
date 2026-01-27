import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_action_buttons.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Mock data for tasks
  final List<Task> _allTasks = [
    Task(
      id: '1',
      title: 'Home visit for pregnancy check',
      titleHindi: 'गर्भावस्था जांच के लिए घर का दौरा',
      patientName: 'Sunita Devi',
      patientNameHindi: 'सुनीता देवी',
      priority: 'HIGH',
      priorityHindi: 'उच्च',
      status: 'Pending',
      statusHindi: 'लंबित',
      dueDate: 'Today, 2:00 PM',
      dueDateHindi: 'आज, 2:00 PM',
      isCompleted: false,
      category: 'today',
    ),
    Task(
      id: '2',
      title: 'Vaccination follow-up',
      titleHindi: 'टीकाकरण अनुवर्ती',
      patientName: 'Baby Rahul',
      patientNameHindi: 'बच्चा राहुल',
      priority: 'NORMAL',
      priorityHindi: 'सामान्य',
      status: 'Pending',
      statusHindi: 'लंबित',
      dueDate: 'Today, 4:30 PM',
      dueDateHindi: 'आज, 4:30 PM',
      isCompleted: false,
      category: 'today',
    ),
    Task(
      id: '3',
      title: 'Blood pressure monitoring',
      titleHindi: 'रक्तचाप निगरानी',
      patientName: 'Ram Lal',
      patientNameHindi: 'राम लाल',
      priority: 'HIGH',
      priorityHindi: 'उच्च',
      status: 'Completed',
      statusHindi: 'पूर्ण',
      dueDate: 'Today, 10:00 AM',
      dueDateHindi: 'आज, 10:00 AM',
      isCompleted: true,
      category: 'today',
    ),
    Task(
      id: '4',
      title: 'Antenatal care visit',
      titleHindi: 'प्रसवपूर्व देखभाल दौरा',
      patientName: 'Geeta Sharma',
      patientNameHindi: 'गीता शर्मा',
      priority: 'NORMAL',
      priorityHindi: 'सामान्य',
      status: 'Pending',
      statusHindi: 'लंबित',
      dueDate: 'Tomorrow, 11:00 AM',
      dueDateHindi: 'कल, 11:00 AM',
      isCompleted: false,
      category: 'upcoming',
    ),
    Task(
      id: '5',
      title: 'Medication delivery',
      titleHindi: 'दवा वितरण',
      patientName: 'Anita Singh',
      patientNameHindi: 'अनीता सिंह',
      priority: 'HIGH',
      priorityHindi: 'उच्च',
      status: 'Pending',
      statusHindi: 'लंबित',
      dueDate: 'Jan 29, 3:00 PM',
      dueDateHindi: '29 जन, 3:00 PM',
      isCompleted: false,
      category: 'upcoming',
    ),
    Task(
      id: '6',
      title: 'Health education session',
      titleHindi: 'स्वास्थ्य शिक्षा सत्र',
      patientName: 'Community Center',
      patientNameHindi: 'सामुदायिक केंद्र',
      priority: 'NORMAL',
      priorityHindi: 'सामान्य',
      status: 'Completed',
      statusHindi: 'पूर्ण',
      dueDate: 'Yesterday',
      dueDateHindi: 'कल',
      isCompleted: true,
      category: 'completed',
    ),
    Task(
      id: '7',
      title: 'Newborn care visit',
      titleHindi: 'नवजात देखभाल दौरा',
      patientName: 'Baby Priya',
      patientNameHindi: 'बच्ची प्रिया',
      priority: 'HIGH',
      priorityHindi: 'उच्च',
      status: 'Completed',
      statusHindi: 'पूर्ण',
      dueDate: 'Jan 25',
      dueDateHindi: '25 जन',
      isCompleted: true,
      category: 'completed',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Task> get _todayTasks => _allTasks.where((t) => t.category == 'today').toList();
  List<Task> get _upcomingTasks => _allTasks.where((t) => t.category == 'upcoming').toList();
  List<Task> get _completedTasks => _allTasks.where((t) => t.category == 'completed').toList();

  int get _totalTasks => _allTasks.length;
  int get _completedCount => _allTasks.where((t) => t.isCompleted).length;

  void _toggleTaskCompletion(String taskId) {
    setState(() {
      final taskIndex = _allTasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        final task = _allTasks[taskIndex];
        
        // Prevent changing status of already completed tasks
        if (task.isCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEnglish 
                    ? '⚠ Task already completed. Cannot change status.' 
                    : '⚠ कार्य पहले से ही पूर्ण है। स्थिति नहीं बदल सकते।',
              ),
              backgroundColor: Colors.orange[700],
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        
        // Only allow marking as completed (one-way change)
        task.isCompleted = true;
        task.status = 'Completed';
        task.statusHindi = 'पूर्ण';
        
        // Update category based on completion
        if (task.category != 'completed') {
          task.category = 'completed';
        }
        
        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEnglish ? '✓ Task completed successfully!' : '✓ कार्य सफलतापूर्वक पूर्ण!',
            ),
            backgroundColor: Colors.green[600],
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: _isEnglish ? 'View' : 'देखें',
              textColor: Colors.white,
              onPressed: () {
                _tabController.animateTo(2); // Navigate to Completed tab
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // No navigation needed since we're in MainScreen's bottom nav
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.home_rounded, 
                  color: Colors.white, 
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          _isEnglish ? 'Tasks' : 'कार्य',
          style: const TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        elevation: 2,
        centerTitle: true,
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () => setState(() => _isEnglish = !_isEnglish),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language, size: 24, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          _isEnglish ? 'EN' : 'HI',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(118),
          child: Column(
            children: [
              // Progress Indicator
              Container(
                margin: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white, size: 30),
                    const SizedBox(width: 16),
                    Text(
                      _isEnglish
                          ? '$_completedCount of $_totalTasks completed'
                          : '$_completedCount / $_totalTasks पूर्ण',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Tabs
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 4,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    letterSpacing: 0.8,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                  labelPadding: const EdgeInsets.symmetric(vertical: 14),
                  tabs: [
                    Tab(text: _isEnglish ? 'Today' : 'आज'),
                    Tab(text: _isEnglish ? 'Upcoming' : 'आगामी'),
                    Tab(text: _isEnglish ? 'Completed' : 'पूर्ण'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildTaskList(_todayTasks),
              _buildTaskList(_upcomingTasks),
              _buildTaskList(_completedTasks),
            ],
          ),
          // Floating Action Buttons (SOS & Voice Assistant)
          FloatingActionButtonsWidget(
            isEnglish: _isEnglish,
            initialSosPosition: const Offset(16, 20),
            initialVoicePosition: const Offset(16, 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _isEnglish ? 'No tasks found' : 'कोई कार्य नहीं मिला',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(tasks[index]);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    // Check if task is overdue (simple check for "Today" in dueDate)
    final isOverdue = !task.isCompleted && 
        (task.dueDate.contains('Today') || task.dueDate.contains('Yesterday'));
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: task.isCompleted ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: task.isCompleted 
              ? Colors.green.withOpacity(0.3)
              : isOverdue 
                  ? Colors.red.withOpacity(0.3) 
                  : Colors.transparent,
          width: task.isCompleted || isOverdue ? 2 : 0,
        ),
      ),
      child: Opacity(
        opacity: task.isCompleted ? 0.7 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox - disabled for completed tasks
              Checkbox(
                value: task.isCompleted,
                onChanged: task.isCompleted 
                    ? null  // Disable checkbox for completed tasks
                    : (value) => _toggleTaskCompletion(task.id),
                activeColor: AppTheme.primaryTeal,
              ),
              const SizedBox(width: 12),
              // Task Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title with completion indicator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _isEnglish ? task.title : task.titleHindi,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: task.isCompleted ? Colors.grey : Colors.black87,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        if (task.isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, size: 14, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  _isEnglish ? 'Done' : 'पूर्ण',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Patient Name
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          _isEnglish ? task.patientName : task.patientNameHindi,
                          style: TextStyle(
                            fontSize: 14,
                            color: task.isCompleted ? Colors.grey[500] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Priority and Due Date
                    Row(
                      children: [
                        // Priority Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: task.priority == 'HIGH' 
                                ? Colors.red.withOpacity(0.1) 
                                : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: task.priority == 'HIGH' ? Colors.red : Colors.blue,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _isEnglish ? task.priority : task.priorityHindi,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: task.priority == 'HIGH' ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Due Date with overdue indicator
                        Icon(
                          isOverdue ? Icons.warning : Icons.schedule, 
                          size: 16, 
                          color: isOverdue ? Colors.red : Colors.grey[600]
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isEnglish ? task.dueDate : task.dueDateHindi,
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue ? Colors.red : Colors.grey[600],
                            fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    
                    // Status indicator for completed tasks
                    if (task.isCompleted) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock, size: 12, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              _isEnglish 
                                  ? 'Status locked' 
                                  : 'स्थिति लॉक है',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Task Model
class Task {
  final String id;
  final String title;
  final String titleHindi;
  final String patientName;
  final String patientNameHindi;
  final String priority;
  final String priorityHindi;
  String status;
  String statusHindi;
  final String dueDate;
  final String dueDateHindi;
  bool isCompleted;
  String category;

  Task({
    required this.id,
    required this.title,
    required this.titleHindi,
    required this.patientName,
    required this.patientNameHindi,
    required this.priority,
    required this.priorityHindi,
    required this.status,
    required this.statusHindi,
    required this.dueDate,
    required this.dueDateHindi,
    required this.isCompleted,
    required this.category,
  });
}
