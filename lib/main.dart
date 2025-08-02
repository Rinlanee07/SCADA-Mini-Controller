import 'package:flutter/material.dart';
import 'models/models.dart';
import 'pages/home_page.dart';
import 'pages/control_page.dart';
import 'pages/history_page.dart';
import 'pages/settings_page.dart';

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
      ControlPage(
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
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
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
    );
  }
}