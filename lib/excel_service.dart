import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'models/patient_data.dart';
import 'package:intl/intl.dart';

class ExcelService {
  late Excel excel;
  late Sheet sheet;

  Future<void> loadExcel(Uint8List bytes) async {
    excel = Excel.decodeBytes(bytes);
    sheet = excel['Sheet1'];
  }

  List<PatientData> getDataInRange(DateTime start, DateTime end) {
    List<PatientData> data = [];
    for (var row in sheet.rows.skip(1)) {
      final date = DateFormat('yyyy-MM-dd').parse(row[0]!.value.toString());
      if (date.isAfter(start.subtract(Duration(days: 1))) &&
          date.isBefore(end.add(Duration(days: 1)))) {
        data.add(PatientData(
          date: date,
          weight: double.parse(row[1]!.value.toString()),
          systolic: int.parse(row[2]!.value.toString()),
          diastolic: int.parse(row[3]!.value.toString()),
          sugar: double.parse(row[4]!.value.toString()),
          kidney: double.parse(row[5]!.value.toString()),
        ));
      }
    }
    return data;
  }

  void addData(PatientData patientData) {
    sheet.appendRow([
      patientData.date.toIso8601String().split('T').first,
      patientData.weight,
      patientData.systolic,
      patientData.diastolic,
      patientData.sugar,
      patientData.kidney
    ]);
  }

  List<PatientData> getAllData() {
    return getDataInRange(DateTime(2000), DateTime(2100));
  }

  List<PatientData> getDataByDate(DateTime selectedDate) {
    return getAllData()
        .where((d) =>
            d.date.year == selectedDate.year &&
            d.date.month == selectedDate.month &&
            d.date.day == selectedDate.day)
        .toList();
  }

  Uint8List save() {
    List<int> bytes = excel.encode()!;         // ได้เป็น List<int>
    return Uint8List.fromList(bytes);
  }
}
