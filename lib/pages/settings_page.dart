import 'package:flutter/material.dart';
import '../models/models.dart';

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
          _buildSettingItem(
            context: context,
            title: 'โหมดมืด',
            subtitle: 'เปลี่ยนธีมแอป',
            value: settings.darkMode,
            onChanged: (value) {
              settings.darkMode = value;
              onSettingsChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value ? '🌙 โหมดมืดเปิดใช้งาน' : '☀️ โหมดสว่างเปิดใช้งาน'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
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