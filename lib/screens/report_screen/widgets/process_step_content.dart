import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // ✅ อย่าลืม import

import '../../../bloc/bloc.dart';
import '../../../bloc/state.dart';
import 'report_processor.dart';
//import 'date_formatter.dart';

class ProcessStepContent extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ReportProcessor reportProcessor;

  const ProcessStepContent({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.reportProcessor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.yellow.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /*Icon(
                      Icons.info_outline,
                      color: Colors.yellow.shade800,
                      size: 20,
                    ),*/
                    const SizedBox(width: 8),
                    Text(
                      'เมื่อตั้งค่าเงื่อนไขเรียบร้อยแล้ว กดปุ่ม "ประมวลผล" เพื่อสร้างรายงาน',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.yellow.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // แสดงสถานะการเลือกวันที่
              /*if (startDate != null && endDate != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'เลือกวันที่แล้ว: ${startDate!.day}/${startDate!.month}/${startDate!.year} - ${endDate!.day}/${endDate!.month}/${endDate!.year}',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.orange.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'กรุณาเลือกวันที่ก่อนกดประมวลผล',
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],*/

              // ✅ แสดงข้อมูลที่เลือกไว้
              /*  if (state is ReportLoaded) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ข้อมูลที่เลือกไว้:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (state.startDate != null && state.endDate != null)
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: Colors.blue.shade600, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'ช่วงวันที่: ${DateFormatter.formatDate(state.startDate!)} ถึง ${DateFormatter.formatDate(state.endDate!)}',
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'ยังไม่ได้เลือกช่วงวันที่',
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],*/

              // ✅ ปุ่มประมวลผล
              ElevatedButton(
                onPressed: reportProcessor.isProcessing ||
                        (state is! ReportLoaded ||
                            (startDate == null || endDate == null))
                    ? null
                    : () {
                        // ใช้วันที่จาก local state
                        if (startDate != null && endDate != null) {
                          reportProcessor.filterReportsOnly(startDate!, endDate!);
                        }
                        // เรียกใช้ reportProcessor เดิม
                        reportProcessor.processReport();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      reportProcessor.isProcessing ? Colors.grey : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: reportProcessor.isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'กำลังประมวลผล...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            (startDate == null || endDate == null) 
                                ? 'เลือกวันที่ก่อน' 
                                : 'ประมวลผล',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
