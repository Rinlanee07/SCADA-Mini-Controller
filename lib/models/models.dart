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