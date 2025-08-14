import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:report/bloc/bloc.dart';
import 'package:report/repository/repository.dart';
import 'package:report/theme/app_theme.dart';

import 'screens/report_screen/report_screen.dart';

// ฟังก์ชันหลักของแอปพลิเคชัน
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // เริ่มต้นข้อมูลรูปแบบวันที่ภาษาไทย
  await initializeDateFormatting('th', null);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'รายงานยอดขาย', // ชื่อแอปพลิเคชัน
      theme: AppTheme.themeData, // ธีมของแอป
      debugShowCheckedModeBanner: false, // ซ่อนแบนเนอร์ debug
      
      // เพิ่มการรองรับภาษาไทย
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('th', 'TH'), // ภาษาไทย
        Locale('en', 'US'), // ภาษาอังกฤษ
      ],
      
      // ตั้งค่าภาษาไทยเป็นค่าเริ่มต้น
      locale: const Locale('th', 'TH'),
      
      home: BlocProvider(
        create: (_) => ReportBloc(ReportRepository()),
        child: const ReportScreen(), // หน้าจอรายงาน
      ),
    );
  }
}
