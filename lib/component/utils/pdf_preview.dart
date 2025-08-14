import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import '../../models/data_model.dart';
import '../../theme/app_theme.dart';

final _numberFormat = NumberFormat('#,##0.00', 'en_US');

class ReportPreviewPage extends StatelessWidget {
  final List<Data> reports;
  final DateTime? startDate;
  final DateTime? endDate;
  final Set<int>? selectedColumns;

  const ReportPreviewPage({
    super.key,
    required this.reports,
    this.startDate,
    this.endDate,
    this.selectedColumns,
  });

  // สร้าง PDF และเตรียมข้อมูลเพื่อแสดงพรีวิว
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();
    final thaiFont = await PdfGoogleFonts.sarabunRegular();

    // กรองข้อมูลตามช่วงวันที่ที่เลือก
    List<Data> filteredReports = reports;
    if (startDate != null && endDate != null) {
      filteredReports = reports.where((item) {
        final itemDate =
            DateTime(item.docDate.year, item.docDate.month, item.docDate.day);
        final start =
            DateTime(startDate!.year, startDate!.month, startDate!.day);
        final end = DateTime(endDate!.year, endDate!.month, endDate!.day);

        return (itemDate.isAtSameMomentAs(start) || itemDate.isAfter(start)) &&
            (itemDate.isAtSameMomentAs(end) || itemDate.isBefore(end));
      }).toList();
    }

    // กำหนด headers และ data mappings ทั้งหมด
    final allHeaders = [
      'วันที่',
      'มูลค่าสินค้า',
      'ส่วนลดก่อนชำระ',
      'ยกเว้นภาษี',
      'ก่อนภาษี',
      'ภาษี VAT',
      'หลังหักส่วนลด',
      'ส่วนลดท้ายบิล',
      'มูลค่าสุทธิ'
    ];

    // สร้าง function สำหรับ map ข้อมูลแต่ละแถว
    List<String> mapReportData(Data item) {
      String formatValue(double value) {
        return value == 0.0 ? '' : _numberFormat.format(value);
      }

      return [
        DateFormat('dd/MM/yyyy').format(item.docDate),
        formatValue(item.totalValue),
        formatValue(item.detailTotalDiscount),
        formatValue(item.totalExceptVat),
        formatValue(item.totalBeforeVat),
        formatValue(item.totalVatValue),
        formatValue(item.detailTotalAmount),
        formatValue(item.totalDiscount),
        formatValue(item.totalAmount),
      ];
    }

    // กำหนดคอลัมน์ที่จะแสดง - ใช้จาก selectedColumns หรือแสดงทั้งหมด
    Set<int> columnsToShow =
        selectedColumns != null && selectedColumns!.isNotEmpty
            ? selectedColumns!
            : Set<int>.from(List.generate(allHeaders.length, (index) => index));

    // สร้าง headers และ data ที่กรองแล้ว
    final sortedColumns = columnsToShow.toList()..sort();
    final filteredHeaders =
        sortedColumns.map((index) => allHeaders[index]).toList();

    final filteredData = filteredReports.map((item) {
      final allData = mapReportData(item);
      return sortedColumns.map((index) => allData[index]).toList();
    }).toList();

    // คำนวณ summary ก่อนสร้างหน้า PDF
    final summary = Summary.calculate(filteredReports);

    // สร้าง summary data ที่กรองแล้ว
    String formatSummaryValue(double value) {
      return value == 0.0 ? '' : _numberFormat.format(value);
    }

    final allSummaryData = [
      'รวม',
      formatSummaryValue(summary.totalValue),
      formatSummaryValue(summary.totalDiscount),
      formatSummaryValue(summary.totalExceptVat),
      formatSummaryValue(summary.totalBeforeVat),
      formatSummaryValue(summary.totalVatValue),
      formatSummaryValue(summary.totalAfterDiscount),
      formatSummaryValue(summary.totalFinalDiscount),
      formatSummaryValue(summary.totalAmount),
    ];

    final filteredSummaryData =
        sortedColumns.map((index) => allSummaryData[index]).toList();

    // สร้าง column widths แบบ dynamic
    final columnWidths = <int, pw.TableColumnWidth>{};
    for (int i = 0; i < filteredHeaders.length; i++) {
      columnWidths[i] = const pw.FlexColumnWidth(1);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'รายงานยอดขาย',
                style: pw.TextStyle(
                  font: thaiFont,
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            if (startDate != null && endDate != null)
              pw.Center(
                child: pw.Text(
                  'รายงาน ณ วันที่: ${_formatDate(startDate)} ถึงวันที่: ${_formatDate(endDate)}',
                  style: pw.TextStyle(font: thaiFont, fontSize: 10),
                ),
              ),
            pw.SizedBox(height: 15),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'วันที่พิมพ์: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                style: pw.TextStyle(font: thaiFont, fontSize: 8),
                textAlign: pw.TextAlign.right,
              ),
            ),
            /* pw.Text(
              'คอลัมน์ที่แสดง: ${filteredHeaders.length} จาก ${allHeaders.length} คอลัมน์',
              style: pw.TextStyle(
                  font: thaiFont, fontSize: 9, fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.right,
            ),*/

            pw.SizedBox(height: 5),

            // ตารางข้อมูลหลัก
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                font: thaiFont,
                fontWeight: pw.FontWeight.bold,
                fontSize: 6,
                // color: PdfColors.blue900,
              ),
              headerDecoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
                ),
              ),
              cellStyle: pw.TextStyle(
                font: thaiFont,
                fontSize: 6,
                fontWeight: pw.FontWeight.normal,
              ),
              border: pw.TableBorder(
                horizontalInside: pw.BorderSide.none,
                verticalInside: pw.BorderSide.none,
                top: pw.BorderSide(color: PdfColors.black, width: 0.5),
                bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
              ),
              columnWidths: columnWidths,
              headers: filteredHeaders,
              data: filteredData,
              cellAlignments: Map.fromEntries(
                sortedColumns.asMap().entries.map((entry) {
                  final columnIndex = entry.key;
                  final originalIndex = entry.value;
                  return MapEntry(
                    columnIndex,
                    originalIndex == 0
                        ? pw.Alignment.center
                        : pw.Alignment.centerRight,
                  );
                }),
              ),
            ), // ✅ ชิดขวาใน cell
            // ตารางสรุปผลรวม
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                font: thaiFont,
                fontWeight: pw.FontWeight.bold,
                fontSize: 6,
              ),
              cellStyle: pw.TextStyle(
                  font: thaiFont,
                  fontSize: 6.5,
                  fontWeight: pw.FontWeight.normal),
              border: pw.TableBorder(
                horizontalInside: pw.BorderSide.none,
                verticalInside: pw.BorderSide.none,
                top: pw.BorderSide(color: PdfColors.black, width: 0.5),
                bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
              ),
              columnWidths: columnWidths,
              cellAlignments: Map.fromEntries(
                sortedColumns.asMap().entries.map((entry) {
                  final columnIndex = entry.key;
                  final originalIndex = entry.value;
                  return MapEntry(
                    columnIndex,
                    originalIndex == 0
                        ? pw.Alignment.center
                        : pw.Alignment.centerRight,
                  );
                }),
              ),
              data: [
                filteredSummaryData
                    .map((cell) => cell == 'รวม'
                        ? pw.Text(cell,
                            style: pw.TextStyle(
                                font: thaiFont,
                                fontSize: 6,
                                fontWeight: pw.FontWeight.bold))
                        : cell)
                    .toList()
              ],
            ),
            // แสดงรายละเอียดคอลัมน์ที่ซ่อน (ถ้ามี)
            /* if (columnsToShow.length < allHeaders.length) ...[
              pw.SizedBox(height: 15),
              pw.Text(
                'คอลัมน์ที่ซ่อน:',
                style: pw.TextStyle(
                  font: thaiFont,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                _getHiddenColumns(allHeaders, columnsToShow),
                style: pw.TextStyle(font: thaiFont, fontSize: 8),
              ),
            ],*/
          ],
        ),
      ),
    );

    return pdf.save();
  }

  String _formatDate(DateTime? date) {
    return date != null
        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(4, '0')}'
        : '';
  }

  // Helper function เพื่อแสดงรายชื่อคอลัมน์ที่ซ่อน
  /* String _getHiddenColumns(List<String> allHeaders, Set<int> selectedColumns) {
    final hiddenIndexes = <int>[];
    for (int i = 0; i < allHeaders.length; i++) {
      if (!selectedColumns.contains(i)) {
        hiddenIndexes.add(i);
      }
    }

    return hiddenIndexes.map((index) => allHeaders[index]).join(', ');
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.gradientAppBar(
        title: 'Preview PDF',
        actions: [
          // แสดงข้อมูลคอลัมน์ที่เลือก
          if (selectedColumns != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                final allHeaders = [
                  'วันที่',
                  'มูลค่าสินค้า',
                  'ส่วนลดก่อนชำระ',
                  'ยกเว้นภาษี',
                  'ก่อนภาษี',
                  'ภาษี VAT',
                  'หลังหักส่วนลด',
                  'ส่วนลดท้ายบิล',
                  'มูลค่าสุทธิ'
                ];

                final sortedSelectedColumns = selectedColumns!.toList()..sort();
                final selectedHeaders = sortedSelectedColumns
                    .map((index) => allHeaders[index])
                    .toList();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      'คอลัมน์ที่แสดงใน PDF',
                      style: TextStyle(fontFamily: 'thaisans'),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'แสดง ${selectedHeaders.length} จาก ${allHeaders.length} คอลัมน์:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'thaisans',
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...selectedHeaders.map((header) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  const Icon(Icons.check,
                                      color: Colors.green, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      header,
                                      style: const TextStyle(
                                          fontFamily: 'thaisans'),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'ปิด',
                          style: TextStyle(
                              fontFamily: 'thaisans', color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: FutureBuilder<Uint8List>(
        future: _generatePdf(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'กำลังสร้าง PDF...',
                    style: TextStyle(fontFamily: 'notoSansThai'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            return PdfPreview(
              build: (format) => snapshot.data!,
              canChangePageFormat: false,
              canDebug: false,
              canChangeOrientation: false,
              allowPrinting: true,
              allowSharing: true,
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'เกิดข้อผิดพลาดในการสร้าง PDF',
                    style: TextStyle(fontFamily: 'notoSansThai'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
