import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart';
import '../../bloc/state.dart';
import '../../bloc/event.dart';

class ShowInventory extends StatelessWidget {
  const ShowInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                bool showOnlyInStock = false;
                if (state is ReportLoaded) {
                  showOnlyInStock = state.showOnlyInStock;
                }
                return Checkbox(
                  value: showOnlyInStock,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      context
                          .read<ReportBloc>()
                          .add(ToggleInStockFilterEvent(newValue));
                    }
                  },
                  activeColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                );
              },
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'แสดงเฉพาะสินค้าที่มีสินค้าคงเหลือ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'หากเลือก จะไม่แสดงสินค้าที่มียอดเป็นศูนย์ ทำให้รายงานกระชับขึ้น',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                bool showOnlyInStock = false;
                if (state is ReportLoaded) {
                  showOnlyInStock = state.showOnlyInStock;
                }
                return Icon(
                  showOnlyInStock ? Icons.visibility: Icons.visibility_off ,
                  color: Colors.blue[700],
                  size: 20,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
