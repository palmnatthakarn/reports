import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart';
import '../../bloc/event.dart';

class PopupFilterDialog extends StatefulWidget {
  final List<String> filterOptions;
  final Set<int> selectedIndexes;
  final void Function(Set<int>) onApply;

  const PopupFilterDialog({
    super.key,
    required this.filterOptions,
    required this.selectedIndexes,
    required this.onApply,
  });

  @override
  State<PopupFilterDialog> createState() => _PopupFilterDialogState();
}

class _PopupFilterDialogState extends State<PopupFilterDialog> {
  late Set<int> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = Set<int>.of(widget.selectedIndexes);
  }

  void _clearSelection() {
    setState(() {
      _tempSelected.clear();
    });
  }

  void _resetToAll() {
    setState(() {
      // รีเซ็ตเป็นการเลือกทั้งหมด (หรือกำหนดค่าเริ่มต้นตามต้องการ)
      _tempSelected = Set<int>.from(
          List.generate(widget.filterOptions.length, (index) => index));
    });
  }

  void _resetToDefault() {
    setState(() {
      _tempSelected = Set<int>.from(List.generate(5, (index) => index));
    });
  }


  void _applyFilter() {
    // ส่ง event กลับไปยัง Bloc
    context.read<ReportBloc>().add(ApplyFilterEvent(_tempSelected));

    // เรียก callback function ที่ส่งมาจาก parent widget
    widget.onApply(_tempSelected);

    // ปิด dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_alt, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'เลือกคอลัมน์ที่จะแสดง',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'notoSansThai',
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'ปิด',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // แสดงจำนวนที่เลือก
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.blue.shade600, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'เลือกแล้ว ${_tempSelected.length} จาก ${widget.filterOptions.length} คอลัมน์',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                      fontFamily: 'notoSansThai',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 12 / 2,
                padding: const EdgeInsets.all(8),
                children: List.generate(widget.filterOptions.length, (index) {
                  final isSelected = _tempSelected.contains(index);
                  return Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue.shade300
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      color:
                          isSelected ? Colors.blue.shade50 : Colors.transparent,
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        widget.filterOptions[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'notoSansThai',
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? Colors.blue.shade700
                              : Colors.black87,
                        ),
                      ),
                      value: isSelected,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.blue.shade600,
                      onChanged: (bool? newValue) {
                        setState(() {
                          if (newValue == true) {
                            _tempSelected.add(index);
                          } else {
                            _tempSelected.remove(index);
                          }
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
            const Divider(),
            // ปุ่มควบคุม
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _resetToAll,
                 // icon: const Icon(Icons.refresh, size: 20),
                  label: const Text(
                    'เลือกทั้งหมด',
                    style: TextStyle(fontFamily: 'notoSansThai'),
                  ),
                ),
                TextButton.icon(
                  onPressed: _resetToDefault,
                 // icon: const Icon(Icons.settings),
                  label: const Text(
                    'ค่าเริ่มต้น',
                    style: TextStyle(fontFamily: 'notoSansThai'),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    TextButton(
                      onPressed: _clearSelection,
                      child: const Text(
                        'ล้าง',
                        style: TextStyle(
                          fontFamily: 'notoSansThai',
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _tempSelected.isEmpty ? null : _applyFilter,
                      icon: const Icon(Icons.check, size: 20, color: Colors.white),
                      label: const Text(
                        'ตกลง',
                        style: TextStyle(fontFamily: 'notoSansThai'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
