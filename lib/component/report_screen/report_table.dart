import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../bloc/state.dart';
import '../../theme/app_theme.dart';

class ReportTable extends StatelessWidget {
  final ReportLoaded state;

  const ReportTable({super.key, required this.state});

  // รายการหัวข้อทั้งหมด
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

  // ฟังก์ชันสำหรับดึงข้อมูลตาม index
  String _getDataByIndex(dynamic item, int index) {
    switch (index) {
      case 0: // วันที่
        return DateFormat('dd/MM/yyyy').format(item.docDate);
      case 1: // มูลค่าสินค้า
        return item.totalValue > 0 ? item.totalValue.toStringAsFixed(2) : '-';
      case 2: // มูลค่าส่วนลดก่อนชำระเงิน
        return item.detailTotalDiscount > 0
            ? item.detailTotalDiscount.toStringAsFixed(2)
            : '-';
      case 3: // มูลค่ายกเว้นภาษี
        return item.totalExceptVat > 0
            ? item.totalExceptVat.toStringAsFixed(2)
            : '-';
      case 4: // มูลค่าก่อนภาษี
        return item.totalBeforeVat > 0
            ? item.totalBeforeVat.toStringAsFixed(2)
            : '-';
      case 5: // ภาษีมูลค่าเพิ่ม
        return item.totalVatValue > 0
            ? item.totalVatValue.toStringAsFixed(2)
            : '-';
      case 6: // มูลค่าหลังหักส่วนลด
        return item.detailTotalAmount > 0
            ? item.detailTotalAmount.toStringAsFixed(2)
            : '-';
      case 7: // มูลค่าส่วนลดท้ายบิล
        return item.totalDiscount > 0
            ? item.totalDiscount.toStringAsFixed(2)
            : '-';
      case 8: // มูลค่าสุทธิ
        return item.totalAmount > 0 ? item.totalAmount.toStringAsFixed(2) : '-';
      default:
        return '-';
    }
  }

  // ฟังก์ชันสำหรับดึงสีของข้อความ
  Color? _getAlternatingRowColor(int index) {
    return index.isEven ? null : Colors.grey[100];
  }

  // ฟังก์ชันสำหรับคำนวณผลรวมตาม index
  String _getTotalByIndex(int index, Map<String, double> totals) {
    double getSafe(String key) => totals[key] ?? 0.0;

    switch (index) {
      case 0: // วันที่
        return 'รวม';
      case 1: // มูลค่าสินค้า
        final discount = getSafe('totalValue');
        return discount > 0 ? discount.toStringAsFixed(2) : '-';
      case 2: // มูลค่าส่วนลดก่อนชำระเงิน
        final discount = getSafe('totalDiscount');
        return discount > 0 ? discount.toStringAsFixed(2) : '-';
      case 3: // มูลค่ายกเว้นภาษี
        final discount = getSafe('totalExceptVat');
        return discount > 0 ? discount.toStringAsFixed(2) : '-';
      case 4: // มูลค่าก่อนภาษี
        final discount = getSafe('totalBeforeVat');
        return discount > 0 ? discount.toStringAsFixed(2) : '-';
      case 5: // ภาษีมูลค่าเพิ่ม
        final discount = getSafe('totalVatValue');
        return discount > 0 ? discount.toStringAsFixed(2) : '-';
      case 6: // มูลค่าหลังหักส่วนลด
        final discount = getSafe('totalAfterDiscount');
        return discount > 0 ? discount.toStringAsFixed(2) : '-';
      case 7: // มูลค่าส่วนลดท้ายบิล
        final discount = getSafe('totalFinalDiscount');
        return discount > 0 ? discount.toStringAsFixed(2) : '-';
      case 8: // มูลค่าสุทธิ
        final discount = getSafe('totalAmount');
        return discount > 0 ? discount.toStringAsFixed(2) : '-';
      default:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    // รับ selectedIndexes จาก state หรือใช้ค่าเริ่มต้น (แสดงทุกคอลัมน์)
    final selectedIndexes = (state.selectedIndexes.isEmpty);

    final visibleIndexes = selectedIndexes
        ? List.generate(9, (index) => index)
        : state.selectedIndexes;

    Map<String, double> calculateTotal() {
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

    final totals = calculateTotal();

    print('จำนวนรายการ: ${state.filteredReports.length}');
    if (state.reports.isEmpty) {
      return const Center(child: Text('ไม่มีข้อมูล'));
    }
    print('🧩 selectedIndexes = ${state.selectedIndexes}');
    print('👀 visibleIndexes = $visibleIndexes');

    return SizedBox(
      height: 600,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.indigo[100],
            child: Row(
              children: visibleIndexes.map((index) {
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
              }).toList(),
            ),
          ),
          // Divider
          if (visibleIndexes.isNotEmpty)
            Row(
              children: [
                for (int i = 0; i < visibleIndexes.length; i++)
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),

              ],
            ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: state.pagedReports.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Container(
                    color: _getAlternatingRowColor(index),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: visibleIndexes.map((i) {
                        return Expanded(
                          flex: 2,
                          child: Text(
                            _getDataByIndex(item, i),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Total Row
          Container(
            color: Colors.indigo[50],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: visibleIndexes.map((index) {
                return Expanded(
                  flex: 2,
                  child: Text(
                    _getTotalByIndex(index, totals),
                    textAlign: TextAlign.center,
                    style: AppTheme.thaiFont(
                      fontWeight:
                          index == 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
