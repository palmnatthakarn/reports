// ✅ ปรับให้ PaginationControls ใช้ข้อมูลจาก meta (totalPages)
// ✅ ใช้ currentPage, itemsPerPage, totalPages จาก ReportLoaded state

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../../bloc/state.dart';

class PaginationControls extends StatelessWidget {
  const PaginationControls({super.key});

  Widget _buildStyledDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20.0, color: Colors.black),
          style: const TextStyle(color: Colors.black, fontSize: 14.0),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<T>>((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text('$item'),
            );
          }).toList(),
          isDense: true,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _buildStyledIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: Colors.black,
        disabledColor: Colors.grey[400],
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        splashRadius: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        if (state is ReportLoaded) {
          final bloc = context.read<ReportBloc>();

          final currentPage = state.currentPage;
          final totalPages = state.totalPages;
          final itemsPerPage = state.itemsPerPage;
          final pageNumbers = List<int>.generate(totalPages, (index) => index + 1);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildStyledDropdown<int>(
                  value: itemsPerPage,
                  items: state.itemsPerPageOptions,
                  onChanged: (value) {
                    if (value != null) {
                      bloc.add(ChangeItemsPerPageEvent(value));
                    }
                  },
                ),
                const SizedBox(width: 8),
                const Text('รายการ / หน้า',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                const SizedBox(width: 16),
                _buildStyledDropdown<int>(
                  value: currentPage,
                  items: pageNumbers,
                  onChanged: (value) {
                    if (value != null) {
                      bloc.add(ChangePageEvent(value));
                    }
                  },
                ),
                const SizedBox(width: 8),
                Text('หน้า $currentPage จาก $totalPages',
                    style: const TextStyle(fontSize: 14, color: Colors.black)),
                const SizedBox(width: 16),
                _buildStyledIconButton(
                  icon: Icons.chevron_left,
                  onPressed: currentPage > 1
                      ? () => bloc.add(ChangePageEvent(currentPage - 1))
                      : null,
                ),
                const SizedBox(width: 8),
                _buildStyledIconButton(
                  icon: Icons.chevron_right,
                  onPressed: currentPage < totalPages
                      ? () => bloc.add(ChangePageEvent(currentPage + 1))
                      : null,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
