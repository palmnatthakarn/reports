import 'package:flutter/material.dart';
import 'package:report/screens/report_screen/widgets/report_processor.dart';

import '../../../component/report_screen/Select_product.dart';
import '../../../component/report_screen/Show_inventory.dart';
import '../../../component/report_screen/date_filter_section.dart';
import '../../../component/report_screen/type_filter_section.dart';
import 'process_step_content.dart';

class StepContentBuilder {
  static Widget buildContentByStep(
    int index, {
    required DateTime? startDate,
    required DateTime? endDate,
    required String? savedConditionName,
    required TabController tabController,
    required Function(DateTime, DateTime) onDatePicked,
    required Function(String?) onSavedConditionNameChanged,
    required Function(bool) onProcessingChanged,
    required BuildContext context,
  }) {
    switch (index) {
      case 0:
        return TypeFilterSection();
        
      case 1:
        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                'โปรดเลือกวันที่ที่ต้องการทราบยอดคงเหลือ (ระบบจะคำนวณยอด ณ สิ้นวันของวันที่เลือก)',
                style: ThemeData().textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            DateFilterSection(
              onConditionSaved: onSavedConditionNameChanged,
              startDate: startDate,
              endDate: endDate,
              tabController: tabController,
              onDatePicked: onDatePicked,
            ),
          ],
        );
        
      case 2:
        return ShowInventory();
        
      case 3:
        return SelectProduct();
        
      case 4:
        return ProcessStepContent(
          startDate: startDate,
          endDate: endDate,
          reportProcessor: ReportProcessor(
            context: context,
            tabController: tabController,
            onProcessingChanged: onProcessingChanged,
          ),
        );
        
      default:
        return const SizedBox.shrink();
    }
  }
}