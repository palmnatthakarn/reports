// lib/repositories/report_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/data_model.dart';

class ReportRepository {
  Future<({List<Data> reports, Meta meta})> fetchReports() async {
    try {
      print('📄 Loading multiple JSON files...');
      
      final List<String> filePaths = [
        'assets/reports.json',
        'assets/รายงานการขายตามวันที่ หน้า 1.json',
        'assets/รายงานการขายตามวันที่ หน้า 2.json',
        'assets/รายงานการขายตามวันที่ หน้า 3.json',
      ];

      final List<String> responses = await Future.wait(
        filePaths.map((path) => rootBundle.loadString(path))
      );

      print('📄 Loaded ${responses.length} files');

      final List<Data> allReports = [];
      Meta? combinedMeta;
      int totalRecords = 0;

      for (int i = 0; i < responses.length; i++) {
        try {
          final jsonData = json.decode(responses[i]);
          final dataField = jsonData['data'];
          
          if (dataField != null) {
            final List dataList = dataField is List ? dataField : [];
            
            for (final item in dataList) {
              try {
                allReports.add(Data.fromJson(item as Map<String, dynamic>));
              } catch (e) {
                print('❌ Error parsing item in file ${filePaths[i]}: $e');
              }
            }
            totalRecords += dataList.length;
          }
          
          if (combinedMeta == null && jsonData['meta'] != null) {
            combinedMeta = Meta.fromJson(jsonData['meta']);
          }
        } catch (e) {
          print('❌ Error processing file ${filePaths[i]}: $e');
        }
      }

      final meta = combinedMeta ?? Meta(page: 1, size: totalRecords, total: totalRecords, totalPage: 1);
      print('📄 Combined ${allReports.length} reports from ${responses.length} files');
      
      return (reports: allReports, meta: meta);
    } catch (e, stackTrace) {
      print('❌ Repository Error: $e');
      print('📛 Stack: $stackTrace');
      rethrow;
    }
  }
}
