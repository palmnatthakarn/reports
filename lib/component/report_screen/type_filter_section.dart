import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:report/bloc/bloc.dart';
import 'package:report/bloc/event.dart';
import 'package:report/bloc/state.dart';
import 'report_type.dart';

class TypeFilterSection extends StatelessWidget {
  const TypeFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final reportTypes = ReportType.all;

    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        String? selectedId;
        if (state is ReportLoaded) {
          selectedId = state.selectedReportType;
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownButtonFormField<String>(
            value: selectedId ?? reportTypes.first.id,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'เลือกประเภทรายงาน',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            selectedItemBuilder: (BuildContext context) {
              return reportTypes.map<Widget>((ReportType type) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    type.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList();
            },
            items: reportTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type.id,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        type.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        type.subtitle,
                        style: const TextStyle(
                          fontSize: 12, 
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<ReportBloc>().add(SelectReportType(value));
              }
            },
            menuMaxHeight: 400,
            icon: const Icon(Icons.arrow_drop_down),
          ),
        );
      },
    );
  }
}