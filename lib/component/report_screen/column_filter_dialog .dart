import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../../bloc/state.dart';

class ColumnFilterDialog extends StatefulWidget {
  const ColumnFilterDialog({super.key});

  @override
  State<ColumnFilterDialog> createState() => _ColumnFilterDialogState();
}

class _ColumnFilterDialogState extends State<ColumnFilterDialog> {
  late Set<int> _tempSelected;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<ReportBloc>().state;
    if (currentState is ReportLoaded) {
      _tempSelected = Set<int>.from(
        currentState.selectedIndexes,
      );
    } else {
      _tempSelected = <int>{};
    }
  }

  void _resetToDefault() {
    setState(() {
      _tempSelected = Set<int>.from(List.generate(5, (i) => i));
    });
  }

  void _clearSelection() {
    setState(() {
      _tempSelected.clear();
    });
  }

  void _applyFilter() {
    context.read<ReportBloc>().add(ApplyFilterEvent(_tempSelected));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final columnNames = [
      'วันที่',
      'มูลค่าสินค้า',
      'มูลค่าส่วนลดก่อนชำระเงิน',
      'มูลค่ายกเว้นภาษี',
      'มูลค่าก่อนภาษี',
      'ภาษีมูลค่าเพิ่ม',
      'มูลค่าหลังหักส่วนลด',
      'มูลค่าส่วนลดท้ายบิล',
      'มูลค่าสุทธิ',
    ];

    return AlertDialog(
      title: Row(
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_list, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'รายการเพิ่มเติม',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'notoSansThai',
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'ปิด',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 12 / 2,
                padding: const EdgeInsets.all(8),
                children: List.generate(columnNames.length, (index) {
                  final isSelected = _tempSelected.contains(index);
                  return CheckboxListTile(
                    value: isSelected,
                    title: Text(columnNames[index], style: const TextStyle(fontSize: 14 , fontWeight: FontWeight.bold), ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          _tempSelected.add(index);
                        } else {
                          _tempSelected.remove(index);
                        }
                      });
                    },
                  );
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _resetToDefault,
                  icon: const Icon(Icons.refresh),
                  label: const Text('ค่าเริ่มต้น'),
                ),
                ElevatedButton(
                  onPressed: _applyFilter,
                  child: const Text('ตกลง'),
                ),
                ElevatedButton(
                  onPressed: _clearSelection,
                  child: const Text('ล้าง'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
