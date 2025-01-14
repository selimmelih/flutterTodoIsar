import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app2/models/todo_model.dart';

class DatabaseService extends ChangeNotifier {
  static late Isar isar;

  // Isar başlatılsın
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([TodoSchema], directory: dir.path);
  }

  // Görevler için liste oluştur
  List<Todo> currentTodos = [];

  // Görev Ekle
  Future<void> addTodo(String text,
      {DateTime? dateTime,
      PriorityLevel priority = PriorityLevel.normal}) async {
    final newTodo = Todo()
      ..text = text
      ..dateTime = dateTime ?? DateTime.now()
      ..priority = priority;

    await isar.writeTxn(() => isar.todos.put(newTodo));
    await fetchTodos();
  }

  // Görevleri Getir
  Future<void> fetchTodos() async {
    currentTodos = await isar.todos.where().findAll();
    notifyListeners(); // bunu mutlaka yazmamız gerekli yoksa provider çalışmaz.
  }

  // Görev Güncelle
  Future<void> updateTodo(Todo todo) async {
    final existingTodo = await isar.todos.get(todo.id);
    if (existingTodo != null) {
      await isar.writeTxn(() => isar.todos.put(todo));
    }
    await fetchTodos();
  }

  // Görev Sil
  Future<void> deleteTodo(int id) async {
    await isar.writeTxn(() => isar.todos.delete(id));
    await fetchTodos();
  }
}
