import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/bloc.dart';
import '../../../bloc/state.dart';
import '../../../component/utils/pdf_export.dart';
import '../../../component/utils/pdf_preview.dart';
import '../../../theme/app_theme.dart';

class ReportScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const ReportScreenAppBar({
    super.key,
    required this.tabController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 82);

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Future<void> _handlePdfExport(BuildContext context) async {
    final state = context.read<ReportBloc>().state;
    if (state is ReportLoaded) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Container(
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'กำลังสร้างไฟล์ PDF...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        await generatePdfWithSaveDialog(
          state.filteredReports,
          startDate: state.startDate,
          endDate: state.endDate,
        );

        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.successSnackBar('บันทึกไฟล์ PDF สำเร็จ'),
        );
      } catch (e) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar('เกิดข้อผิดพลาด: $e'),
        );
      }
    } else if (state is ReportLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.warningSnackBar('กำลังโหลดข้อมูล...'),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.warningSnackBar('ไม่มีข้อมูลให้ส่งออกเป็น PDF'),
      );
    }
  }

  void _handlePdfPreview(BuildContext context) {
    final state = context.read<ReportBloc>().state;
    if (state is ReportLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportPreviewPage(
            reports: state.filteredReports,
            startDate: state.startDate,
            endDate: state.endDate,
            selectedColumns: state.selectedIndexes,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: AppTheme.gradientDecoration,
        child: Column(
          children: [
            // AppBar section
            AppBar(
              title: const Text(
                'รายงานยอดขาย',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ),
              actions: [
                _buildActionButton(
                  icon: Icons.picture_as_pdf,
                  tooltip: 'ส่งออก PDF',
                  backgroundColor: Colors.red.withOpacity(0.2),
                  onPressed: () => _handlePdfExport(context),
                ),
                _buildActionButton(
                  icon: Icons.preview,
                  tooltip: 'ดูตัวอย่าง PDF',
                  backgroundColor: Colors.green.withOpacity(0.2),
                  onPressed: () => _handlePdfPreview(context),
                ),
                const SizedBox(width: 16),
              ],
            ),
            // TabBar section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.settings, size: 20),
                    text: 'เงื่อนไข',
                  ),
                  Tab(
                    icon: Icon(Icons.table_chart, size: 20),
                    text: 'แสดงผล',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}