import 'package:flutter/material.dart';

class NoDataPlaceholder extends StatelessWidget {
  final TabController tabController;

  const NoDataPlaceholder({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade50, Colors.white],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_document,
              size: 80,
              color: Colors.orange.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'กรุณากรอกเงื่อนไขก่อน',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ไปที่แท็บ "เงื่อนไข" เพื่อกรอกข้อมูลสำหรับรายงาน',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => tabController.animateTo(0),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              label: const Text('กลับไปกรอกเงื่อนไข'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}