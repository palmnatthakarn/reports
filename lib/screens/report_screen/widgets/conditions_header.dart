import 'package:flutter/material.dart';

class ConditionsHeader extends StatelessWidget {
  const ConditionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3B82F6), // Blue-500
            Color(0xFF1D4ED8), // Blue-700
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.settings, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'การตั้งค่ารายงาน',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'กำหนดเงื่อนไขสำหรับรายงานที่ต้องการ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
          Text('โปรดเลือกวันที่ที่ต้องการทราบยอดคงเหลือ (ระบบจะคำนวณยอด ณ สิ้นวันของวันที่เลือก)',
          style: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 12),)
        ],
      ),
    );
  }
}