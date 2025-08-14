// report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report/screens/report_screen/widgets/conditions_tab.dart';
import 'package:report/screens/report_screen/widgets/report_screen_app_bar.dart';
import 'package:report/screens/report_screen/widgets/results_tab.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';


class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? startDate;
  DateTime? endDate;
  int? selectedMonth;
  int? selectedYear;
  String? savedConditionName;

  @override
  void initState() {
    super.initState();
    print('🧠 ReportScreen created');
    _tabController = TabController(length: 2, vsync: this);
    // โหลดข้อมูลทันทีเมื่อ screen เปิด
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportBloc>().add(LoadReportsEvent());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onDatePicked(DateTime start, DateTime end) {
    print('ฟังก์ชัน _onDatePicked ถูกเรียก: $start - $end');
    setState(() {
      startDate = start;
      endDate = end;
    });
    // ส่งข้อมูลไปยัง BLoC ด้วย
    context.read<ReportBloc>().add(
      SetDateRangeEvent(
        startDate: start,
        endDate: end,
      ),
    );
    print('ส่ง SetDateRangeEvent ไปยัง BLoC แล้ว');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: ReportScreenAppBar(
        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab แรก: เงื่อนไข
          ConditionsTab(
            startDate: startDate,
            endDate: endDate,
            savedConditionName: savedConditionName,
            tabController: _tabController,
            onDatePicked: _onDatePicked,
            onSavedConditionNameChanged: (name) {
              setState(() {
                savedConditionName = name;
              });
            },
          ),
          // Tab ที่สอง: แสดงผล
          ResultsTab(tabController: _tabController),
        ],
      ),
    );
  }
}