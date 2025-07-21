import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patient_data.dart';

class DataInputForm extends StatefulWidget {
  final Function(PatientData) onSubmit;

  const DataInputForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _DataInputFormState createState() => _DataInputFormState();
}

class _DataInputFormState extends State<DataInputForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  final weightController = TextEditingController();
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final sugarController = TextEditingController();
  final kidneyController = TextEditingController();

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      final data = PatientData(
        date: selectedDate!,
        weight: double.parse(weightController.text),
        systolic: int.parse(systolicController.text),
        diastolic: int.parse(diastolicController.text),
        sugar: double.parse(sugarController.text),
        kidney: double.parse(kidneyController.text),
      );
      widget.onSubmit(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ ข้อมูลถูกเพิ่มเรียบร้อย')),
      );
      _clearForm();
    }
  }

  void _clearForm() {
    weightController.clear();
    systolicController.clear();
    diastolicController.clear();
    sugarController.clear();
    kidneyController.clear();
    setState(() {
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : 'เลือกวันที่';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("เพิ่มข้อมูลผู้ป่วย", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(onPressed: _pickDate, child: Text("📅 $dateText")),
              ],
            ),
            TextFormField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'น้ำหนัก (kg)'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'กรอกน้ำหนัก' : null,
            ),
            TextFormField(
              controller: systolicController,
              decoration: InputDecoration(labelText: 'ความดันบน (mmHg)'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'กรอกความดันบน' : null,
            ),
            TextFormField(
              controller: diastolicController,
              decoration: InputDecoration(labelText: 'ความดันล่าง (mmHg)'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'กรอกความดันล่าง' : null,
            ),
            TextFormField(
              controller: sugarController,
              decoration: InputDecoration(labelText: 'น้ำตาล (mg/dL)'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'กรอกค่าน้ำตาล' : null,
            ),
            TextFormField(
              controller: kidneyController,
              decoration: InputDecoration(labelText: 'การทำงานของไต'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'กรอกค่าการทำงานของไต' : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: Icon(Icons.save),
              label: Text('บันทึกข้อมูล'),
            )
          ],
        ),
      ),
    );
  }
}
