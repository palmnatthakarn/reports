import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/bloc.dart';
import '../../../bloc/event.dart';
import '../../../bloc/state.dart';

class ReportProcessor {
  final BuildContext context;
  final TabController tabController;
  final Function(bool) onProcessingChanged;
  bool _isProcessing = false;

  ReportProcessor({
    required this.context,
    required this.tabController,
    required this.onProcessingChanged,
  });

  bool get isProcessing => _isProcessing;

  /// ฟังก์ชันสำหรับประมวลผลข้อมูลตามเงื่อนไขที่เลือก
  Future<void> processReport() async {
    final reportBloc = context.read<ReportBloc>();
    final state = reportBloc.state;

    if (state is ReportLoaded) {
      // ตรวจสอบว่ามีการเลือกวันที่หรือไม่
      if (state.startDate != null && state.endDate != null) {
        _isProcessing = true;
        onProcessingChanged(true);

        print('🚀 เริ่มประมวลผลรายงาน...');
        print('📅 ช่วงวันที่: ${state.startDate} - ${state.endDate}');
        
        try { 
          // กรองข้อมูลตามวันที่ก่อนประมวลผล
          _filterReportsByDate(state.startDate!, state.endDate!);
          
          // จำลองการประมวลผล
          await Future.delayed(const Duration(seconds: 2));

          // รอให้ state อัปเดตก่อนตรวจสอบ
          await Future.delayed(const Duration(milliseconds: 500));
          final updatedState = reportBloc.state;
          
          if (updatedState is ReportLoaded && updatedState.filteredReports.isNotEmpty) {
            print('✅ ประมวลผลสำเร็จ: ${updatedState.filteredReports.length} รายการ');
            print('📊 ข้อมูลที่กรองแล้ว: ${updatedState.filteredReports.length} รายการ');
            
            // อัปเดต step ไปยังขั้นตอนถัดไป
            reportBloc.add(SetStepEvent(1));
            
            // บันทึกข้อมูลการประมวลผล
            reportBloc.add(UpdateCardDataEvent(0, {
              'dateRange': '${DateFormat('dd/MM/yyyy').format(state.startDate!)} - ${DateFormat('dd/MM/yyyy').format(state.endDate!)}',
              'totalReports': updatedState.filteredReports.length,
              'processed': true,
            }));
            
            _isProcessing = false;
            onProcessingChanged(false);

            // เปลี่ยนไป tab ถัดไป
            if (tabController.index < tabController.length - 1) {
              tabController.animateTo(tabController.index + 1);
            }
            // แสดงข้อความสำเร็จ
            _showSuccessSnackBar();
          } else {
            _isProcessing = false;
            onProcessingChanged(false);
            _showNoDataSnackBar();
          }
        } catch (e) {
          _isProcessing = false;
          onProcessingChanged(false);
          print('❌ เกิดข้อผิดพลาดในการประมวลผล: $e');
          _showErrorSnackBar();
        }
      } else {
        // แสดงข้อความเตือนถ้าไม่ได้เลือกวันที่
        _showWarningSnackBar();
      }
    } else {
      _showErrorSnackBar();
    }
  }

  /// ฟังก์ชันกรองข้อมูลตามวันที่
  void _filterReportsByDate(DateTime start, DateTime end) {
    final reportBloc = context.read<ReportBloc>();
    final state = reportBloc.state;

    if (state is ReportLoaded) {
      print('🔍 Filtering reports by date...');
      print('📊 Total reports before filter: ${state.allReports.length}');
      print('📅 Date range: ${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}');

      // ใช้ allReports เป็นฐานข้อมูลในการกรอง
      final allReports = state.allReports;

      final filtered = allReports.where((item) {
        // เปรียบเทียบเฉพาะวันที่ โดยไม่สนใจเวลา
        final itemDate =
            DateTime(item.docDate.year, item.docDate.month, item.docDate.day);
        final startDate = DateTime(start.year, start.month, start.day);
        final endDate = DateTime(end.year, end.month, end.day);

        return (itemDate.isAtSameMomentAs(startDate) ||
                itemDate.isAfter(startDate)) &&
            (itemDate.isAtSameMomentAs(endDate) || itemDate.isBefore(endDate));
      }).toList();

      print('📊 Filtered reports count: ${filtered.length}');

      if (filtered.isEmpty) {
        print('⚠️ No reports found in selected date range');
      } else {
        print('✅ Found ${filtered.length} reports in date range');
        // แสดงข้อมูลตัวอย่างของรายการแรก
        final firstItem = filtered.first;
        print(
            '📄 First item date: ${DateFormat('dd/MM/yyyy').format(firstItem.docDate)}');
      }
      // อัปเดต filteredReports ใน state
      reportBloc.add(UpdateFilteredReportsEvent(filtered));
    } else {
      print('❌ State is not ReportLoaded: ${state.runtimeType}');
    }
  }

  // ฟังก์ชันเสริมสำหรับเรียกใช้การกรองแยกจากการประมวลผล
  void filterReportsOnly(DateTime start, DateTime end) {
    _filterReportsByDate(start, end);
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('ประมวลผลรายงานสำเร็จ'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showWarningSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.warning, color: Colors.white),
            SizedBox(width: 8),
            Text('กรุณาเลือกช่วงวันที่ก่อนประมวลผล'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showNoDataSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 8),
            Text('ไม่พบข้อมูลในช่วงวันที่ที่เลือก'),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Text('ไม่สามารถประมวลผลได้ กรุณาโหลดข้อมูลใหม่'),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}