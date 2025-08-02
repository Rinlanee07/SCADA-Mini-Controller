import 'package:flutter/material.dart';
import '../models/models.dart';

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