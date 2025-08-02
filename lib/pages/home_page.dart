import 'package:flutter/material.dart';

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