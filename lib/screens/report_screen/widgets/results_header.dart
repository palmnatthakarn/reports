import 'package:flutter/material.dart';
import 'date_formatter.dart';


class ResultsHeader extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTime, DateTime) onDatePicked;

  const ResultsHeader({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDatePicked,
  });

  @override
  State<ResultsHeader> createState() => _ResultsHeaderState();
}

class _ResultsHeaderState extends State<ResultsHeader> with TickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF10B981), // Emerald-500
            Color(0xFF059669), // Emerald-600
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.table_chart, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'ตารางแสดงผลรายงาน',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // ให้ขนาดพอดีกับเนื้อหา
                children: [
                  // เว้นระยะระหว่างไอคอนกับข้อความ
                  Text(
                    'ช่วงวันที่: ${DateFormatter.formatDate(widget.startDate)} '
                    'ถึง ${DateFormatter.formatDate(widget.endDate)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
               
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
