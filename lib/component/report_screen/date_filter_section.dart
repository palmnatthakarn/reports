import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:report/bloc/state.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';

class DateFilterSection extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final TabController tabController;
  final void Function(DateTime start, DateTime end) onDatePicked;
  final void Function(String name) onConditionSaved;

  const DateFilterSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.tabController,
    required this.onDatePicked,
    required this.onConditionSaved,
  });

  @override
  State<DateFilterSection> createState() => _DateFilterSectionState();
}

class _DateFilterSectionState extends State<DateFilterSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize Thai locale data
    _initializeLocale();
    _controller = TextEditingController(
      text: _formatDateRange(widget.startDate, widget.endDate),
    );
  }

  // Initialize Thai locale
  Future<void> _initializeLocale() async {
    await initializeDateFormatting('th', null);
  }

  @override
  void didUpdateWidget(covariant DateFilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.text = _formatDateRange(widget.startDate, widget.endDate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '';
    // Use Thai locale for date formatting
    final formatter = DateFormat('dd/MM/yyyy', 'th');
    final startStr = formatter.format(start);
    final endStr = formatter.format(end);
    return '$startStr - $endStr';
  }

  Future<void> _pickDateRange(BuildContext context) async {
    DateTime currentMonth = DateTime.now();
    DateTime? selectedStart;
    DateTime? selectedEnd;
    bool isSelectingRange = false;
    String? selectedQuickOption; // เพิ่มตัวแปรเพื่อเก็บตัวเลือกที่เลือก

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          Widget buildCalendar() {
            final daysInMonth =
                DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
            final firstDayOfMonth =
                DateTime(currentMonth.year, currentMonth.month, 1);
            final startingWeekday = firstDayOfMonth.weekday % 7;

            return Column(
              children: [
                // Month navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => setState(() => currentMonth =
                          DateTime(currentMonth.year, currentMonth.month - 1)),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      DateFormat('MMMM yyyy', 'th').format(currentMonth),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      onPressed: () => setState(() => currentMonth =
                          DateTime(currentMonth.year, currentMonth.month + 1)),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Weekday headers
                Row(
                  children: ['อา.', 'จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.']
                      .map((day) => Expanded(
                            child: Center(
                              child: Text(day,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12)),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                // Calendar grid
                ...List.generate(6, (weekIndex) {
                  return Row(
                    children: List.generate(7, (dayIndex) {
                      final dayNumber =
                          weekIndex * 7 + dayIndex - startingWeekday + 1;
                      if (dayNumber < 1 || dayNumber > daysInMonth) {
                        return const Expanded(child: SizedBox(height: 32));
                      }

                      final date = DateTime(
                          currentMonth.year, currentMonth.month, dayNumber);
                      final isSelected = (selectedStart != null &&
                              _isSameDay(date, selectedStart!)) ||
                          (selectedEnd != null &&
                              _isSameDay(date, selectedEnd!));
                      final isInRange = selectedStart != null &&
                          selectedEnd != null &&
                          date.isAfter(selectedStart!) &&
                          date.isBefore(selectedEnd!);

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // รีเซ็ต quick option selection เมื่อเลือกจากปฏิทิน
                              selectedQuickOption = null;

                              if (selectedStart == null ||
                                  (selectedStart != null &&
                                      selectedEnd != null)) {
                                selectedStart = date;
                                selectedEnd = null;
                                isSelectingRange = true;
                              } else if (selectedEnd == null) {
                                if (date.isBefore(selectedStart!)) {
                                  selectedEnd = selectedStart;
                                  selectedStart = date;
                                } else {
                                  selectedEnd = date;
                                }
                                isSelectingRange = false;
                              }
                            });
                          },
                          child: Container(
                            height: 32,
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.deepPurpleAccent
                                  : (isInRange
                                      ? Colors.deepPurple.shade100
                                      : null),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                dayNumber.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
                const SizedBox(height: 16),
                // Date range display
                if (selectedStart != null || selectedEnd != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('วันเริ่มต้น',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            selectedStart != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(selectedStart!)
                                : '',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('วันสิ้นสุด',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            selectedEnd != null
                                ? DateFormat('dd/MM/yyyy').format(selectedEnd!)
                                : '',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            );
          }

          Widget buildQuickOptionItem(
              String text, String optionKey, VoidCallback onTap) {
            final isSelected = selectedQuickOption == optionKey;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedQuickOption = optionKey;
                });
                onTap();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                margin: const EdgeInsets.only(bottom: 2),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.deepPurpleAccent : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }

          Widget buildQuickOptions() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                buildQuickOptionItem(
                  'วันนี้',
                  'today',
                  () {
                    final end = DateTime.now();
                    final start = end.subtract(const Duration(days: 0));
                    setState(() {
                      selectedStart = start;
                      selectedEnd = end;
                    });
                  },
                ),
                buildQuickOptionItem(
                  'เมื่อวานนี้',
                  'yesterday',
                  () {
                    final end = DateTime.now();
                    final start = end.subtract(const Duration(days: 1));
                    setState(() {
                      selectedStart = start;
                      selectedEnd = end;
                    });
                  },
                ),
                buildQuickOptionItem(
                  'สัปดาห์นี้',
                  'this_week',
                  () {
                    final now = DateTime.now();
                    // วันแรกของสัปดาห์นี้ (เริ่มวันจันทร์)
                    final start = now.subtract(Duration(days: now.weekday - 1));
                    // วันสุดท้ายของสัปดาห์นี้ (วันอาทิตย์)
                    final end = start.add(const Duration(days: 6));
                    setState(() {
                      selectedStart = start;
                      selectedEnd = end;
                    });
                  },
                ),
                buildQuickOptionItem(
                  'สัปดาห์ที่แล้ว',
                  'last_week',
                  () {
                    final now = DateTime.now();
                    final startOfThisWeek =
                        now.subtract(Duration(days: now.weekday - 1));
                    final start =
                        startOfThisWeek.subtract(const Duration(days: 7));
                    // วันสุดท้ายของสัปดาห์ที่แล้ว (ก่อนเริ่มสัปดาห์นี้ 1 วัน)
                    final end =
                        startOfThisWeek.subtract(const Duration(days: 1));
                    setState(() {
                      selectedStart = start;
                      selectedEnd = end;
                    });
                  },
                ),
                buildQuickOptionItem(
                  'เดือนนี้',
                  'this_month',
                  () {
                    final now = DateTime.now();
                    final start = DateTime(now.year, now.month, 1);
                    final end = DateTime(now.year, now.month + 1, 0);
                    setState(() {
                      selectedStart = start;
                      selectedEnd = end;
                    });
                  },
                ),
                buildQuickOptionItem(
                  'เดือนที่แล้ว',
                  'last_month',
                  () {
                    final now = DateTime.now();
                    final start = DateTime(now.year, now.month - 1, 1);
                    final end =
                        DateTime(now.year, now.month - 1, 30, 31, 29, 28);
                    setState(() {
                      selectedStart = start;
                      selectedEnd = end;
                    });
                  },
                ),
                buildQuickOptionItem(
                  '7 วันล่าสุด',
                  'last_7_days',
                  () {
                    final end = DateTime.now();
                    final start = end.subtract(const Duration(days: 6));
                    setState(() {
                      selectedStart = start;
                      selectedEnd = end;
                    });
                  },
                ),
                buildQuickOptionItem(
                  '30 วันล่าสุด',
                  'last_30_days',
                  () {
                    final end = DateTime.now();
                    final start = end.subtract(const Duration(days: 29));
                    setState(() {
                      selectedStart = start;
                      selectedEnd = end;
                    });
                  },
                ),
                buildQuickOptionItem(
                  '3 เดือนที่แล้ว',
                  'last_3_month',
                  () {
                    final now = DateTime.now();
                    final start = DateTime(now.year, now.month - 3, 1);
                    final end =
                        DateTime(now.year, now.month - 1, 30, 31, 29, 28);
                    setState(() {
                      selectedStart = start;
                      selectedEnd = end;
                    });
                  },
                ),
              ],
            );
          }

          return Dialog(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: buildCalendar()),
                      const SizedBox(width: 16),
                      Expanded(child: buildQuickOptions()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('ยกเลิก'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: selectedStart != null && selectedEnd != null
                            ? () {
                                Navigator.pop(context);
                                final rangeText = _formatDateRange(
                                    selectedStart, selectedEnd);
                                setState(() {
                                  _controller.text = rangeText;
                                });
                                widget.onDatePicked(
                                    selectedStart!, selectedEnd!);
                                // ส่งข้อมูลไปยัง BLoC
                                context.read<ReportBloc>().add(
                                      SetDateRangeEvent(
                                        startDate: selectedStart,
                                        endDate: selectedEnd,
                                      ),
                                    );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text('เสร็จแล้ว',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  //
  static void filterReportsByDate(
      BuildContext context, DateTime start, DateTime end) {
    final reportBloc = context.read<ReportBloc>();
    final state = reportBloc.state;

    if (state is ReportLoaded) {
      print('🔍 Filtering reports by date...');
      print('📊 Total reports before filter: ${state.allReports.length}');

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
            '📄 First item date: ${DateFormat('dd/MM/yyyy', 'th').format(firstItem.docDate)}');
      }

      // อัปเดต filteredReports ใน state
      reportBloc.add(UpdateFilteredReportsEvent(filtered));
    } else {
      print('❌ State is not ReportLoaded: ${state.runtimeType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'เลือกช่วงวันที่สำหรับรายงาน',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
          ),
          const SizedBox(height: 12),
          TextField(
            readOnly: true,
            controller: _controller,
            onTap: () => _pickDateRange(context),
            decoration: InputDecoration(
              labelText: 'คลิกเพื่อเลือกช่วงวันที่',
              labelStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              hintText: 'เลือกวันที่เริ่มต้นและสิ้นสุด',
              suffixIcon: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.blue.shade600,
                  size: 20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (widget.startDate != null && widget.endDate != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'เลือกช่วงวันที่แล้ว: ${_formatDateRange(widget.startDate, widget.endDate)}',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
