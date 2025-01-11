import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../services/database_service.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;
  const EditTodoScreen({super.key, required this.todo});

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  late TextEditingController _textFieldController;
  late DateTime? _selectedDate;
  late PriorityLevel _priority;

  @override
  void initState() {
    super.initState();
    _textFieldController = TextEditingController(text: widget.todo.text);
    _selectedDate = widget.todo.dateTime;
    _priority = widget.todo.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görevi Düzenle'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                labelText: 'Görev',
                hintText: 'Görev açıklaması girin',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _selectedDate == null
                    ? 'Tarih Seç'
                    : 'Tarih: ${_formatDate(_selectedDate!)}',
              ),
              tileColor: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onTap: () {
                _selectDate(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.flag,
                color: _getPriorityColor(_priority),
              ),
              title: const Text('Öncelik'),
              trailing: DropdownButton<PriorityLevel>(
                value: _priority,
                items: PriorityLevel.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flag,
                            color: _getPriorityColor(priority), size: 20),
                        const SizedBox(width: 8),
                        Text(_getPriorityText(priority)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _priority = value);
                  }
                },
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (_textFieldController.text.isNotEmpty) {
                  final updatedTodo = widget.todo
                    ..text = _textFieldController.text
                    ..dateTime = _selectedDate ?? DateTime.now()
                    ..priority = _priority;

                  await context.read<DatabaseService>().updateTodo(updatedTodo);
                  if (mounted) Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen bir görev girin'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Değişiklikleri Kaydet',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(PriorityLevel priority) {
    switch (priority) {
      case PriorityLevel.low:
        return Colors.green;
      case PriorityLevel.normal:
        return Colors.orange;
      case PriorityLevel.high:
        return Colors.red;
    }
  }

  String _getPriorityText(PriorityLevel priority) {
    switch (priority) {
      case PriorityLevel.low:
        return 'Düşük';
      case PriorityLevel.normal:
        return 'Normal';
      case PriorityLevel.high:
        return 'Yüksek';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? currentDate,
      firstDate: DateTime(currentDate.year - 1),
      lastDate: DateTime(currentDate.year + 5),
      locale: const Locale('tr'),
      cancelText: 'İPTAL',
      confirmText: 'TAMAM',
      helpText: 'TARİH SEÇİN',
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${getTurkishMonth(date.month)} ${date.year} ${getTurkishDay(date.weekday)}';
  }
}
