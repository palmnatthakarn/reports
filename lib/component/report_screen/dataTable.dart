import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../../bloc/state.dart';
import '../../models/data_model.dart';
import '../../theme/app_theme.dart';
import 'popup_flter_dialog.dart';

final _numberFormat = NumberFormat('#,##0.00', 'en_US');

class ReportDataSource extends DataTableSource {
  final List<Data> data;
  final List<String> headers;

  ReportDataSource(this.data, this.headers);

  String _getDataByIndex(Data item, int index) {
    switch (index) {
      case 0:
        return DateFormat('dd/MM/yyyy').format(item.docDate);
      case 1:
        return item.totalValue > 0
            ? _numberFormat.format(item.totalValue)
            : '-';
      case 2:
        return item.detailTotalDiscount > 0
            ? _numberFormat.format(item.detailTotalDiscount)
            : '-';
      case 3:
        return item.totalExceptVat > 0
            ? _numberFormat.format(item.totalExceptVat)
            : '-';
      case 4:
        return item.totalBeforeVat > 0
            ? _numberFormat.format(item.totalBeforeVat)
            : '-';
      case 5:
        return item.totalVatValue > 0
            ? _numberFormat.format(item.totalVatValue)
            : '-';
      case 6:
        return item.detailTotalAmount > 0
            ? _numberFormat.format(item.detailTotalAmount)
            : '-';
      case 7:
        return item.totalDiscount > 0
            ? _numberFormat.format(item.totalDiscount)
            : '-';
      case 8:
        return item.totalAmount > 0
            ? _numberFormat.format(item.totalAmount)
            : '-';
      default:
        return '-';
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];
    return DataRow2(
      color: WidgetStateProperty.all(
        index.isEven ? null : Colors.grey[100],
      ),
      cells: List.generate(
        headers.length,
        (cellIndex) => DataCell(
          Container(
            alignment: Alignment.center,
            child: Text(
              _getDataByIndex(item, cellIndex),
              style: AppTheme.thaiFont(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class ReportDataTable extends StatelessWidget {
  final ReportLoaded state;

  const ReportDataTable({super.key, required this.state});

  static const List<String> reportHeaders = [
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

  String _getDataByIndex(Data item, int index) {
    switch (index) {
      case 0:
        return DateFormat('dd/MM/yyyy').format(item.docDate);
      case 1:
        return item.totalValue > 0
            ? _numberFormat.format(item.totalValue)
            : '-';
      case 2:
        return item.detailTotalDiscount > 0
            ? _numberFormat.format(item.detailTotalDiscount)
            : '-';
      case 3:
        return item.totalExceptVat > 0
            ? _numberFormat.format(item.totalExceptVat)
            : '-';
      case 4:
        return item.totalBeforeVat > 0
            ? _numberFormat.format(item.totalBeforeVat)
            : '-';
      case 5:
        return item.totalVatValue > 0
            ? _numberFormat.format(item.totalVatValue)
            : '-';
      case 6:
        return item.detailTotalAmount > 0
            ? _numberFormat.format(item.detailTotalAmount)
            : '-';
      case 7:
        return item.totalDiscount > 0
            ? _numberFormat.format(item.totalDiscount)
            : '-';
      case 8:
        return item.totalAmount > 0
            ? _numberFormat.format(item.totalAmount)
            : '-';
      default:
        return '-';
    }
  }

  String _getTotalByIndex(int index, Map<String, double> totals) {
    double getSafe(String key) => totals[key] ?? 0.0;

    switch (index) {
      case 0:
        return 'รวม';
      case 1:
        final value = getSafe('totalValue');
        return value > 0 ? _numberFormat.format(value) : '-';
      case 2:
        final value = getSafe('totalDiscount');
        return value > 0 ? _numberFormat.format(value) : '-';
      case 3:
        final value = getSafe('totalExceptVat');
        return value > 0 ? _numberFormat.format(value) : '-';
      case 4:
        final value = getSafe('totalBeforeVat');
        return value > 0 ? _numberFormat.format(value) : '-';
      case 5:
        final value = getSafe('totalVatValue');
        return value > 0 ? _numberFormat.format(value) : '-';
      case 6:
        final value = getSafe('totalAfterDiscount');
        return value > 0 ? _numberFormat.format(value) : '-';
      case 7:
        final value = getSafe('totalFinalDiscount');
        return value > 0 ? _numberFormat.format(value) : '-';
      case 8:
        final value = getSafe('totalAmount');
        return value > 0 ? _numberFormat.format(value) : '-';
      default:
        return '-';
    }
  }

  Map<String, double> _calculateTotal() {
    double totalValue = 0;
    double totalDiscount = 0;
    double totalExceptVat = 0;
    double totalBeforeVat = 0;
    double totalVatValue = 0;
    double totalAfterDiscount = 0;
    double totalFinalDiscount = 0;
    double totalAmount = 0;

    for (var item in state.filteredReports) {
      totalValue += item.totalValue;
      totalDiscount += item.detailTotalDiscount;
      totalExceptVat += item.totalExceptVat;
      totalBeforeVat += item.totalBeforeVat;
      totalVatValue += item.totalVatValue;
      totalAfterDiscount += item.detailTotalAmount;
      totalFinalDiscount += item.totalDiscount;
      totalAmount += item.totalAmount;
    }

    return {
      'totalValue': totalValue,
      'totalDiscount': totalDiscount,
      'totalExceptVat': totalExceptVat,
      'totalBeforeVat': totalBeforeVat,
      'totalVatValue': totalVatValue,
      'totalAfterDiscount': totalAfterDiscount,
      'totalFinalDiscount': totalFinalDiscount,
      'totalAmount': totalAmount,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (state.reports.isEmpty) {
      return const Center(child: Text('ไม่มีข้อมูล'));
    }

    final totals = _calculateTotal();

    // กรองคอลัมน์ตาม selectedIndexes
    final visibleIndexes = (state.selectedIndexes.isEmpty ?? true)
        ? List.generate(9, (index) => index)
        : state.selectedIndexes.toList();

    return Column(
      children: [
        // Header พร้อมปุ่ม filter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          color: Colors.indigo[100],
          child: Row(
            children: [
              ...visibleIndexes.map((index) { 
                return Expanded(
                  flex: 2,
                  child: Text(
                    reportHeaders[index],
                    textAlign: TextAlign.center,
                    style: AppTheme.thaiFont(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
              IconButton(
                icon:
                    const Icon(Icons.filter_alt, color: Colors.grey, size: 20),
                tooltip: 'หัวข้ออื่นๆ',
                onPressed: () {
                  final state = context.read<ReportBloc>().state;
                  if (state is ReportLoaded) {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return BlocProvider.value(
                          value: context.read<ReportBloc>(),
                          child: PopupFilterDialog(
                            filterOptions: ReportDataTable.reportHeaders,
                            selectedIndexes: state.selectedIndexes ?? {},
                            onApply: (selected) {
                              context
                                  .read<ReportBloc>()
                                  .add(ApplyFilterEvent(selected));
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
        // ตารางข้อมูลหลัก (สามารถเลื่อนได้)
        Expanded(
          child: DataTable2(
            columnSpacing: 5,
            horizontalMargin: 5,
            minWidth: 800,
            headingRowHeight: 0,
            dataRowHeight: 36,
            columns: visibleIndexes
                .map((index) => DataColumn2(
                      label: const SizedBox.shrink(),
                      size: ColumnSize.M,
                    ))
                .toList(),
            rows: state.pagedReports.asMap().entries.map((entry) {
              final rowIndex = entry.key;
              final item = entry.value;
              return DataRow2(
                color: WidgetStateProperty.all(
                  rowIndex.isEven ? null : Colors.grey[100],
                ),
                cells: visibleIndexes
                    .map((index) => DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              _getDataByIndex(item, index),
                              style: AppTheme.thaiFont(fontSize: 14),
                            ),
                          ),
                        ))
                    .toList(),
              );
            }).toList(),
          ),
        ),
        // แถวผลรวมที่แสดงค้างไว้ด้านล่าง
        Container(
          color: Colors.indigo[50],
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Row(
            children: visibleIndexes.map((index) {
              return Expanded(
                child: Center(
                  child: Text(
                    _getTotalByIndex(index, totals),
                    style: AppTheme.thaiFont(
                      fontSize: 14,
                      fontWeight:
                          index == 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
