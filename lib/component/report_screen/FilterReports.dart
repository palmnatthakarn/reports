import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';

class FilterReports extends StatefulWidget {
  const FilterReports({super.key});

  @override
  State<FilterReports> createState() => _FilterReportsState();
}

class _FilterReportsState extends State<FilterReports> {
  int? selectedMonth;
  int? selectedYear;

  final List<int> years = List.generate(5, (i) => 2022 + i); // 2022-2026

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        DropdownButton<int?>(
          hint: const Text('เดือน'),
          value: selectedMonth,
          items: [
            const DropdownMenuItem(value: null, child: Text('ทั้งหมด')),
            ...List.generate(12, (i) => DropdownMenuItem(
              value: i + 1,
              child: Text('เดือน ${i + 1}'),
            )),
          ],
          onChanged: (value) {
            setState(() => selectedMonth = value);
            context.read<ReportBloc>().add(FilterReportsEvent(
              month: value,
              year: selectedYear,
            ));
          },
        ),
        const SizedBox(width: 16),
        DropdownButton<int?>(
          hint: const Text('ปี'),
          value: selectedYear,
          items: [
            const DropdownMenuItem(value: null, child: Text('ทั้งหมด')),
            ...years.map((y) => DropdownMenuItem(value: y, child: Text('$y')))
          ],
          onChanged: (value) {
            setState(() => selectedYear = value);
            context.read<ReportBloc>().add(FilterReportsEvent(
              month: selectedMonth,
              year: value,
            ));
          },
        ),
      ],
    );
  }
}
