import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report/screens/report_screen/widgets/no_data_placehodwe.dart';

import '../../../bloc/bloc.dart';
import '../../../bloc/state.dart';
import '../../../component/report_screen/pagination_controls.dart';
//import '../../../component/report_screen/report_table.dart';
import '../../../component/report_screen/dataTable.dart';

import '../../../theme/app_theme.dart';
import 'results_header.dart';

class ResultsTab extends StatelessWidget {
  final TabController tabController;

  const ResultsTab({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        if (state is ReportLoaded) {
          // ตรวจสอบว่าได้เลือกวันที่แล้วหรือยัง
          if (state.startDate == null || state.endDate == null) {
            return NoDataPlaceholder(
              tabController: tabController,
            );
          }

          return Column(
            children: [
              // Header สำหรับ tab แสดงผล
              ResultsHeader(
                startDate: state.startDate!,
                endDate: state.endDate!,
                onDatePicked: (start, end) {
                  // Handle date change if needed
                },
              ),
              // แสดง ReportTable
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.borderColor.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                        height: 500, child: ReportDataTable(state: state)),
                  ),
                ),
              ),

              const PaginationControls(),
              const SizedBox(height: 16),
            ],
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'กำลังโหลดข้อมูล...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
