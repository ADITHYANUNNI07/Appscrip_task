import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/model/task_model.dart';

late Database _database;
Future<void> initializeDatabase() async {
  _database = await openDatabase("task.db", version: 1,
      onCreate: (Database database, int version) async {
    await database.execute(
        'CREATE TABLE task (id INTEGER PRIMARY KEY, title TEXT, description TEXT, duedate TEXT, priority TEXT, status TEXT, userId INTEGER, createAt TEXT)');
  });
}

Future<int> insertTask(TaskModel task) async {
  final db = _database;
  print(task.toMap());
  return await db.insert(
    'task',
    task.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
