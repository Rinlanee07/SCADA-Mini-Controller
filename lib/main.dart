// main.dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const SCADAApp());
}

class SCADAApp extends StatelessWidget {
  const SCADAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCADA Mini Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Models
class MachineState {
  bool isRunning;
  double speed;
  DateTime? startTime;
  double progress;
  int elapsedSeconds;

  MachineState({
    this.isRunning = false,
    this.speed = 5.0,
    this.startTime,
    this.progress = 0.0,
    this.elapsedSeconds = 0,
  });
}

class WorkLog {
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final double speed;
  final bool completed;

  WorkLog({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.speed,
    required this.completed,
  });
}

class AppSettings {
  bool soundEnabled;
  bool darkMode;
  bool autoSave;

  AppSettings({
    this.soundEnabled = false,
    this.darkMode = false,
    this.autoSave = true,
  });
}

// Main Navigation
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final MachineState _machineState = MachineState();
  final List<WorkLog> _logs = [];
  final AppSettings _settings = AppSettings();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(onNavigateToMachine: () => setState(() => _currentIndex = 1)),
      MachineControlPage(
        machineState: _machineState,
        onStateChanged: _updateMachineState,
        onLogSaved: _addLog,
        settings: _settings,
      ),
      HistoryPage(logs: _logs, onClearLogs: _clearLogs),
      SettingsPage(settings: _settings, onSettingsChanged: _updateSettings),
    ];
  }

  void _updateMachineState() {
    setState(() {});
  }

  void _addLog(WorkLog log) {
    setState(() {
      _logs.insert(0, log);
      if (_logs.length > 50) {
        _logs.removeRange(50, _logs.length);
      }
    });
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  void _updateSettings() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Column(
                children: [
                  // Status Bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2d3748), Color(0xFF4a5568)],
                      ),
                    ),
                    child: const Text(
                      '⚡ SCADA Controller • สถานะ: เชื่อมต่อแล้ว',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Page Content
                  Expanded(
                    child: _pages[_currentIndex],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFF667eea),
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            unselectedFontSize: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'หน้าหลัก',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_remote_rounded),
                label: 'ควบคุม',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: 'ประวัติ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                label: 'ตั้งค่า',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  final VoidCallback onNavigateToMachine;

  const HomePage({super.key, required this.onNavigateToMachine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // App Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.precision_manufacturing_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'SCADA Mini Controller',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d3748),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ระบบควบคุมเครื่องจักรจำลอง',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 40),
          // Main Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNavigateToMachine,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF48bb78),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                shadowColor: const Color(0xFF48bb78).withOpacity(0.3),
              ),
              child: const Text(
                '🚀 เริ่มควบคุมเครื่องจักร',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Feature Cards
          Expanded(
            child: Column(
              children: [
                _buildFeatureCard(
                  icon: Icons.speed_rounded,
                  title: 'ควบคุมความเร็ว',
                  subtitle: 'ปรับความเร็วเครื่องจักรได้ตามต้องการ',
                ),
                const SizedBox(height: 15),
                _buildFeatureCard(
                  icon: Icons.analytics_rounded,
                  title: 'ติดตามประสิทธิภาพ',
                  subtitle: 'ดูสถิติและประวัติการทำงาน',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFf7fafc),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFe2e8f0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2d3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Machine Control Page
class MachineControlPage extends StatefulWidget {
  final MachineState machineState;
  final VoidCallback onStateChanged;
  final Function(WorkLog) onLogSaved;
  final AppSettings settings;

  const MachineControlPage({
    super.key,
    required this.machineState,
    required this.onStateChanged,
    required this.onLogSaved,
    required this.settings,
  });

  @override
  State<MachineControlPage> createState() => _MachineControlPageState();
}

class _MachineControlPageState extends State<MachineControlPage>
    with TickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  void _startMachine() {
    setState(() {
      widget.machineState.isRunning = true;
      widget.machineState.startTime = DateTime.now();
      widget.machineState.progress = 0;
      widget.machineState.elapsedSeconds = 0;
    });

    _rotationController.repeat();
    _startTimer();
    widget.onStateChanged();
  }

  void _stopMachine() {
    setState(() {
      widget.machineState.isRunning = false;
    });

    _timer?.cancel();
    _rotationController.stop();

    // Save log if auto-save enabled
    if (widget.settings.autoSave && widget.machineState.startTime != null) {
      _saveLog();
    }

    widget.onStateChanged();
  }

  void _resetMachine() {
    _stopMachine();
    setState(() {
      widget.machineState.progress = 0;
      widget.machineState.elapsedSeconds = 0;
      widget.machineState.startTime = null;
    });
    _rotationController.reset();
    widget.onStateChanged();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        widget.machineState.elapsedSeconds++;
        widget.machineState.progress = 
            (widget.machineState.elapsedSeconds / 60) * 100; // 60 seconds = 100%
      });

      // Auto stop at 100%
      if (widget.machineState.progress >= 100) {
        _stopMachine();
        _showCompletionDialog();
      }
    });
  }

  void _saveLog() {
    final log = WorkLog(
      startTime: widget.machineState.startTime!,
      endTime: DateTime.now(),
      duration: widget.machineState.elapsedSeconds,
      speed: widget.machineState.speed,
      completed: widget.machineState.progress >= 100,
    );
    widget.onLogSaved(log);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 เสร็จสิ้น!'),
        content: const Text('เครื่องจักรทำงานเสร็จสิ้นแล้ว'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  void _updateSpeed(double value) {
    setState(() {
      widget.machineState.speed = value;
    });

    // Update animation speed
    if (widget.machineState.isRunning) {
      _rotationController.duration = Duration(
        milliseconds: (3000 / widget.machineState.speed).round(),
      );
      _rotationController.repeat();
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header
          const Text(
            'ควบคุมเครื่องจักร',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d3748),
            ),
          ),
          const SizedBox(height: 10),
          // Status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: widget.machineState.isRunning 
                      ? const Color(0xFF48bb78) 
                      : const Color(0xFFe53e3e),
                  shape: BoxShape.circle,
                ),
                child: widget.machineState.isRunning 
                    ? null 
                    : const SizedBox(),
              ),
              const SizedBox(width: 8),
              Text(
                widget.machineState.isRunning ? 'กำลังทำงาน' : 'หยุดทำงาน',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: widget.machineState.isRunning 
                      ? const Color(0xFF48bb78) 
                      : const Color(0xFFe53e3e),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Machine Visual
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFf7fafc), Color(0xFFedf2f7)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * 3.14159,
                      child: Icon(
                        Icons.settings_rounded,
                        size: 60,
                        color: widget.machineState.isRunning 
                            ? const Color(0xFF48bb78) 
                            : const Color(0xFF4a5568),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                Text(
                  widget.machineState.isRunning
                      ? 'ทำงานด้วยความเร็ว ${widget.machineState.speed.toInt()}'
                      : 'เครื่องจักรพร้อมใช้งาน',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4a5568),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Speed Control
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFf7fafc),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.speed_rounded, color: Color(0xFF667eea)),
                    SizedBox(width: 8),
                    Text(
                      'ควบคุมความเร็ว',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2d3748),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Slider(
                  value: widget.machineState.speed,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: const Color(0xFF667eea),
                  onChanged: _updateSpeed,
                ),
                Text(
                  'ความเร็ว: ${widget.machineState.speed.toInt()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667eea),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Progress Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFf7fafc),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.analytics_rounded, color: Color(0xFF667eea)),
                    SizedBox(width: 8),
                    Text(
                      'ความคืบหน้า',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2d3748),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                LinearProgressIndicator(
                  value: widget.machineState.progress / 100,
                  backgroundColor: const Color(0xFFe2e8f0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF48bb78)),
                  minHeight: 8,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.machineState.startTime != null
                          ? 'เวลาเริ่ม: ${TimeOfDay.fromDateTime(widget.machineState.startTime!).format(context)}'
                          : 'เวลาเริ่ม: --:--',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                    Text(
                      'เวลาที่ผ่าน: ${_formatTime(widget.machineState.elapsedSeconds)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Control Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.machineState.isRunning ? null : _startMachine,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('เริ่ม'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48bb78),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: !widget.machineState.isRunning ? null : _stopMachine,
                  icon: const Icon(Icons.stop_rounded),
                  label: const Text('หยุด'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf56565),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _resetMachine,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('รีเซ็ต'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFedf2f7),
                    foregroundColor: const Color(0xFF4a5568),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFe2e8f0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// History Page
class HistoryPage extends StatelessWidget {
  final List<WorkLog> logs;
  final VoidCallback onClearLogs;

  const HistoryPage({
    super.key,
    required this.logs,
    required this.onClearLogs,
  });

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            '📊 ประวัติการใช้งาน',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d3748),
            ),
          ),
          const SizedBox(height: 20),
          
          if (logs.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.history_rounded,
                      size: 64,
                      color: Color(0xFF718096),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'ยังไม่มีประวัติการใช้งาน',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFe2e8f0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${log.completed ? '✅' : '⏹️'} ${_formatDuration(log.duration)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2d3748),
                              ),
                            ),
                            Text(
                              '${log.startTime.day}/${log.startTime.month} ${TimeOfDay.fromDateTime(log.startTime).format(context)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF718096),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ความเร็ว: ${log.speed.toInt()}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4a5568),
                              ),
                            ),
                            Text(
                              'สถานะ: ${log.completed ? 'เสร็จสิ้น' : 'หยุดกลางคัน'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: log.completed 
                                    ? const Color(0xFF48bb78) 
                                    : const Color(0xFFf56565),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          if (logs.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('ยืนยันการลบ'),
                      content: const Text('คุณต้องการลบประวัติทั้งหมดใช่หรือไม่?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('ยกเลิก'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onClearLogs();
                          },
                          child: const Text('ลบ'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete_rounded),
                label: const Text('ลบประวัติทั้งหมด'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf56565),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
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
}

// Settings Page
class SettingsPage extends StatelessWidget {
  final AppSettings settings;
  final VoidCallback onSettingsChanged;

  const SettingsPage({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            '⚙️ การตั้งค่า',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d3748),
            ),
          ),
          const SizedBox(height: 30),

          // Sound Setting
          _buildSettingItem(
            context: context,
            title: 'แจ้งเตือนเสียง',
            subtitle: 'เปิด/ปิดเสียงแจ้งเตือน',
            value: settings.soundEnabled,
            onChanged: (value) {
              settings.soundEnabled = value;
              onSettingsChanged();
            },
          ),

          const SizedBox(height: 15),

          // Dark Mode Setting
          _buildSettingItem(
            context: context,
            title: 'โหมดมืด',
            subtitle: 'เปลี่ยนธีมแอป',
            value: settings.darkMode,
            onChanged: (value) {
              settings.darkMode = value;
              onSettingsChanged();
              // Show demo message for dark mode
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value ? '🌙 โหมดมืดเปิดใช้งาน' : '☀️ โหมดสว่างเปิดใช้งาน'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          // Auto Save Setting
          _buildSettingItem(
            context: context,
            title: 'บันทึกอัตโนมัติ',
            subtitle: 'บันทึกประวัติการใช้งานอัตโนมัติ',
            value: settings.autoSave,
            onChanged: (value) {
              settings.autoSave = value;
              onSettingsChanged();
            },
          ),

          const SizedBox(height: 30),

          // App Info Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFf7fafc),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFe2e8f0)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 32,
                  color: Color(0xFF667eea),
                ),
                const SizedBox(height: 10),
                const Text(
                  'SCADA Mini Controller',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2d3748),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'เวอร์ชัน 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'แอปจำลองการควบคุมเครื่องจักรสำหรับการเรียนรู้',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Reset App Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('รีเซ็ตแอป'),
                    content: const Text('คุณต้องการรีเซ็ตการตั้งค่าทั้งหมดใช่หรือไม่?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('ยกเลิก'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Reset all settings
                          settings.soundEnabled = false;
                          settings.darkMode = false;
                          settings.autoSave = true;
                          onSettingsChanged();
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('🔄 รีเซ็ตการตั้งค่าเรียบร้อยแล้ว'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('รีเซ็ต'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.restore_rounded),
              label: const Text('รีเซ็ตการตั้งค่า'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFf56565),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
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

  Widget _buildSettingItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFe2e8f0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2d3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          // Custom Toggle Switch
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: value ? const Color(0xFF48bb78) : const Color(0xFFe2e8f0),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}