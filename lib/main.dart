import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'excel_service.dart';
import 'widgets/data_table_widget.dart';
import 'widgets/data_input_form.dart';
import 'widgets/date_selector.dart';
import '../models/patient_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ExcelService excelService = ExcelService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Monitor',
      home: Scaffold(
        appBar: AppBar(title: Text('Kidney Monitor')),
        body: PatientMonitorScreen(excelService: excelService),
      ),
    );
  }
}

class PatientMonitorScreen extends StatefulWidget {
  final ExcelService excelService;
  const PatientMonitorScreen({required this.excelService});

  @override
  _PatientMonitorScreenState createState() => _PatientMonitorScreenState();
}

class _PatientMonitorScreenState extends State<PatientMonitorScreen> {
  DateTime? startDate;
  DateTime? endDate;
  Uint8List? excelBytes;

  List<PatientData> filteredData = [];

  void loadExcel() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null && result.files.single.bytes != null) {
      await widget.excelService.loadExcel(result.files.single.bytes!);
      setState(() {
        excelBytes = result.files.single.bytes!;
        filteredData = widget.excelService.getAllData();
      });
    }
  }

  void filterByDate(DateTime start, DateTime end) {
    setState(() {
      startDate = start;
      endDate = end;
      filteredData = widget.excelService.getDataInRange(start, end);
    });
  }

  void saveExcel() async {
    final bytes = widget.excelService.save();
    // Save to download or prompt download for web (implement file saving for web)
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(onPressed: loadExcel, child: Text("📁 Load Excel File")),
          DateSelector(onSelected: filterByDate),
          DataTableWidget(data: filteredData),
          DataInputForm(
            onSubmit: (data) {
              widget.excelService.addData(data);
              if (startDate != null && endDate != null) {
                filterByDate(startDate!, endDate!);
              }
            },
          ),
        ],
      ),
    );
  }
}
