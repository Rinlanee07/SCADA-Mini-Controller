import 'package:flutter/material.dart';
import '../models/models.dart';
import 'dart:async';

class ControlPage extends StatefulWidget {
  final MachineState machineState;
  final VoidCallback onStateChanged;
  final Function(WorkLog) onLogSaved;
  final AppSettings settings;

  const ControlPage({
    super.key,
    required this.machineState,
    required this.onStateChanged,
    required this.onLogSaved,
    required this.settings,
  });

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> with TickerProviderStateMixin {
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
            (widget.machineState.elapsedSeconds / 60) * 100;
      });

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

    if (widget.machineState.isRunning) {
      _rotationController.duration =
          Duration(milliseconds: (3000 / widget.machineState.speed).round());
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
          const Text(
            'ควบคุมเครื่องจักร',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d3748),
            ),
          ),
          const SizedBox(height: 10),
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
                child: widget.machineState.isRunning ? null : const SizedBox(),
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
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF48bb78)),
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
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      widget.machineState.isRunning ? null : _startMachine,
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
                  onPressed:
                      !widget.machineState.isRunning ? null : _stopMachine,
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