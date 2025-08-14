import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ContentCard extends StatelessWidget {
  final String title;
  final Widget activeContentWidget;
  final GestureTapCallback? onTap;
  final int stepIndex;
  final bool isCurrentStep;
  final bool hasData; // เพิ่มพารามิเตอร์นี้เพื่อตรวจสอบว่ามีข้อมูลหรือไม่

  const ContentCard({
    super.key,
    required this.title,
    required this.activeContentWidget,
    this.onTap,
    required this.stepIndex,
    required this.isCurrentStep,
    this.hasData = false, // ค่าเริ่มต้น
  });

  @override
  Widget build(BuildContext context) {
    final Widget inactiveContentPlaceholder = Container(
      height:
          MediaQuery.of(context).size.height * 0.19, // ปรับความสูงให้เหมาะสม
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      alignment: Alignment.center,
      child: hasData
          ? Text('ไม่ใช่งาน', style: AppTheme.thaiFont(color: AppTheme.textSecondary))
          : IgnorePointer(child: activeContentWidget),
    );

    // สร้าง Widget สำหรับแสดงข้อมูลที่มีอยู่แล้ว (เมื่อไม่ active แต่มีข้อมูล)
    final Widget dataPreviewWidget = Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.successColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            // แสดงข้อมูลจริงแทนที่จะใช้ opacity
            child: IgnorePointer(
              // ป้องกันการ interact เมื่อไม่ active
              child: activeContentWidget,
            ),
          ),
        ],
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 2.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    title,
                    style: AppTheme.thaiFont(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // แสดงไอคอนเมื่อมีข้อมูลแล้ว
                  if (hasData && !isCurrentStep)
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.successColor,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              AnimatedCrossFade(
                firstChild: activeContentWidget,
                secondChild: isCurrentStep
                    ? const SizedBox.shrink()
                    : hasData
                        ? dataPreviewWidget
                        : const SizedBox.shrink(),
                crossFadeState: isCurrentStep
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.topLeft,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
