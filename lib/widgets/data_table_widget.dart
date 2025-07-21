import 'package:flutter/material.dart';
import '../models/patient_data.dart';
import 'package:intl/intl.dart';

class DataTableWidget extends StatelessWidget {
  final List<PatientData> data;

  const DataTableWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('วันที่')),
          DataColumn(label: Text('น้ำหนัก (kg)')),
          DataColumn(label: Text('ความดันบน (mmHg)')),
          DataColumn(label: Text('ความดันล่าง (mmHg)')),
          DataColumn(label: Text('น้ำตาล (mg/dL)')),
          DataColumn(label: Text('การทำงานของไต')),
        ],
        rows: data.map((entry) {
          return DataRow(cells: [
            DataCell(Text(dateFormat.format(entry.date))),
            DataCell(Text(entry.weight.toStringAsFixed(1))),
            DataCell(Text(entry.systolic.toString())),
            DataCell(Text(entry.diastolic.toString())),
            DataCell(Text(entry.sugar.toStringAsFixed(1))),
            DataCell(Text(entry.kidney.toStringAsFixed(1))),
          ]);
        }).toList(),
      ),
    );
  }
}
