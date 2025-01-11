import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app2/models/todo_model.dart';
import 'package:todo_app2/screens/add_todo_screen.dart';
import 'package:todo_app2/services/database_service.dart';
import 'package:todo_app2/screens/edit_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Görev Uygulaması"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTodoScreen()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<DatabaseService>(
        builder: (context, db, child) => ListView.builder(
          itemCount: db.currentTodos.length,
          itemBuilder: (context, index) {
            final todo = db.currentTodos[index];
            return ListTile(
              title: Text(todo.text),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => db.deleteTodo(todo.id),
              ),
            );
          },
        ),
      ),
    );
  }
}
