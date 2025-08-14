import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../../bloc/state.dart';
import '../../models/data_model.dart';

class SelectProduct extends StatelessWidget {
  const SelectProduct({super.key});

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
                List<Data> productSelected = [];
                if (state is ReportLoaded) {
                  productSelected = state.productSelected;
                }
                return Checkbox(
                  value: productSelected.isNotEmpty,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      context
                          .read<ReportBloc>()
                          .add(ProductSelectedEvent(productSelected));
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
                    'เลือกสินค้าที่ต้องการ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'หากเลือก จะสามารถกรองรายงานตามสินค้าที่เลือกได้',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),  



      
      
      )
    );
  }
}
