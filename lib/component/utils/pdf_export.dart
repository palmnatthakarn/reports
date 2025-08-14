import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:file_selector/file_selector.dart';
import 'package:printing/printing.dart';
import '../../models/data_model.dart';

Future<bool> generatePdfWithSaveDialog(
  List<Data> reports, {
  DateTime? startDate,
  DateTime? endDate,
  Set<int>? selectedColumns, // เพิ่มพารามิเตอร์สำหรับคอลัมน์ที่เลือก
}) async {
  try {
    // ตรวจสอบว่ามีข้อมูลหรือไม่
    if (reports.isEmpty) {
      print('No data to export');
      return false;
    }

    final pdf = pw.Document();

    final thaiFont = await PdfGoogleFonts.sarabunRegular();
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
      return [
        DateFormat('dd/MM/yyyy').format(item.docDate),
        item.totalValue.toStringAsFixed(2),
        item.detailTotalDiscount.toStringAsFixed(2),
        item.totalExceptVat.toStringAsFixed(2),
        item.totalBeforeVat.toStringAsFixed(2),
        item.totalVatValue.toStringAsFixed(2),
        item.detailTotalAmount.toStringAsFixed(2),
        item.totalDiscount.toStringAsFixed(2),
        item.totalAmount.toStringAsFixed(2),
      ];
    }

    // กำหนดคอลัมน์ที่จะแสดง
    Set<int> columnsToShow = selectedColumns ?? 
        Set<int>.from(List.generate(allHeaders.length, (index) => index));

    // สร้าง headers และ data ที่กรองแล้ว
    final sortedColumns = columnsToShow.toList()..sort();
    final filteredHeaders = sortedColumns
        .map((index) => allHeaders[index])
        .toList();

    final filteredData = reports.map((item) {
      final allData = mapReportData(item);
      return sortedColumns
          .map((index) => allData[index])
          .toList();
    }).toList();

    String formatDate(DateTime date) {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(4, '0')}';
    }

    // คำนวณ summary ก่อนสร้างหน้า PDF
    final summary = Summary.calculate(reports);
    
    // สร้าง summary data ที่กรองแล้ว
    final allSummaryData = [
      'รวม',
      summary.totalValue.toStringAsFixed(2),
      summary.totalDiscount.toStringAsFixed(2),
      summary.totalExceptVat.toStringAsFixed(2),
      summary.totalBeforeVat.toStringAsFixed(2),
      summary.totalVatValue.toStringAsFixed(2),
      summary.totalAfterDiscount.toStringAsFixed(2),
      summary.totalFinalDiscount.toStringAsFixed(2),
      summary.totalAmount.toStringAsFixed(2),
    ];

    final filteredSummaryData = sortedColumns
        .map((index) => allSummaryData[index])
        .toList();

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
                  'รายงาน ณ วันที่: ${formatDate(startDate)} ถึงวันที่: ${formatDate(endDate)}',
                  style: pw.TextStyle(font: thaiFont, fontSize: 10),
                ),
              ),
            pw.SizedBox(height: 15),
            pw.Text(
              'วันที่พิมพ์: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
              style: pw.TextStyle(font: thaiFont, fontSize: 10),
              textAlign: pw.TextAlign.left,
            ),
            pw.Text(
              'คอลัมน์ที่แสดง: ${filteredHeaders.length} จาก ${allHeaders.length} คอลัมน์',
              style: pw.TextStyle(font: thaiFont, fontSize: 9),
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(height: 10),
            
            // ตารางข้อมูลหลัก
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                  font: thaiFont,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 7),
              cellStyle: pw.TextStyle(font: thaiFont, fontSize: 7, fontWeight: pw.FontWeight.normal),
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              columnWidths: columnWidths,
              headers: filteredHeaders,
              data: filteredData,
            ),
            
            pw.SizedBox(height: 10),
            
            // ตารางสรุปผลรวม
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                  font: thaiFont,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 7),
              cellStyle: pw.TextStyle(font: thaiFont, fontSize: 7, fontWeight: pw.FontWeight.normal),
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              columnWidths: columnWidths,
              data: [filteredSummaryData],
            ),
            
            // แสดงรายละเอียดคอลัมน์ที่ซ่อน (ถ้ามี)
            if (columnsToShow.length < allHeaders.length) ...[
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
            ],
          ],
        ),
      ),
    );

    // สร้างไฟล์ PDF
    final Uint8List bytes = await pdf.save();

    // เปิดหน้าต่างให้ผู้ใช้เลือกที่บันทึกไฟล์
    final FileSaveLocation? saveLocation = await getSaveLocation(
      suggestedName:
          'รายงานยอดขาย_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.pdf',
      acceptedTypeGroups: [
        XTypeGroup(label: 'PDF Files', extensions: ['pdf']),
      ],
    );

    // ตรวจสอบว่าผู้ใช้เลือกที่เก็บไฟล์หรือไม่
    if (saveLocation != null) {
      // ตรวจสอบและเพิ่มนามสกุล .pdf หากจำเป็น
      String filePath = saveLocation.path;
      if (!filePath.toLowerCase().endsWith('.pdf')) {
        filePath += '.pdf';
      }

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      print('PDF file saved successfully at: $filePath');
      return true;
    } else {
      print('File save operation was cancelled by user');
      return false;
    }
  } catch (e) {
    print('Error generating PDF: $e');
    rethrow;
  }
}

// Helper function เพื่อแสดงรายชื่อคอลัมน์ที่ซ่อน
String _getHiddenColumns(List<String> allHeaders, Set<int> selectedColumns) {
  final hiddenIndexes = <int>[];
  for (int i = 0; i < allHeaders.length; i++) {
    if (!selectedColumns.contains(i)) {
      hiddenIndexes.add(i);
    }
  }
  
  return hiddenIndexes.map((index) => allHeaders[index]).join(', ');
}