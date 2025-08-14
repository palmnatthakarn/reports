// report_type.dart
import 'package:flutter/material.dart';


class ReportType {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;

  const ReportType({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  // ✅ static list เรียกใช้ได้จากทุกจุด
  static const List<ReportType> all = [
    ReportType(
      id: 'item_balance',
      icon: Icons.description,
      title: 'ยอดคงเหลือตามสินค้า',
      subtitle: 'แสดงสินค้าและยอดคงเหลือรวมทั้งหมด',
    ),
    ReportType(
      id: 'warehouse_balance',
      icon: Icons.storefront,
      title: 'ยอดคงเหลือตามคลัง',
      subtitle: 'แสดงสินค้าและแยกตามคลังสินค้า',
    ),
    ReportType(
      id: 'location_balance',
      icon: Icons.grid_4x4,
      title: 'ยอดคงเหลือตามที่เก็บ',
      subtitle: 'แสดงสินค้า คลัง และแยกตามที่เก็บ',
    ),
  ];

  static ReportType? fromId(String id) {
    return all.firstWhere((r) => r.id == id, orElse: () => all[0]);
  }
}
