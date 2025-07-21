import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final Function(DateTime start, DateTime end) onSelected;

  const DateSelector({Key? key, required this.onSelected}) : super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });

      widget.onSelected(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    String dateRangeText = 'เลือกช่วงวันที่';
    if (_startDate != null && _endDate != null) {
      dateRangeText =
          '${dateFormat.format(_startDate!)} - ${dateFormat.format(_endDate!)}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _pickDateRange,
            icon: Icon(Icons.date_range),
            label: Text(dateRangeText),
          ),
        ],
      ),
    );
  }
}
