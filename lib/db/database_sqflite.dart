import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/model/task_model.dart';
import 'package:task_manager/core/model/todo_model.dart';
import 'package:task_manager/core/model/user_model.dart';

late Database _database;
Future<void> initializeDatabase() async {
  _database = await openDatabase("task.db", version: 1,
      onCreate: (Database database, int version) async {
    await database.execute(
        'CREATE TABLE todos (id INTEGER PRIMARY KEY, userId INTEGER, title TEXT, completed INTEGER)');
    await database.execute(
        'CREATE TABLE task (id INTEGER PRIMARY KEY, title TEXT, description TEXT, duedate TEXT, priority TEXT, status TEXT, userId INTEGER, createAt TEXT)');
    await database.execute(
        'CREATE TABLE users (id INTEGER PRIMARY KEY, email TEXT, first_name TEXT, last_name TEXT, avatar TEXT)');
  });
}

Future<int> insertTask(TaskModel task) async {
  final db = _database;
  return await db.insert(
    'task',
    task.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<TaskModel>> fetchAllTasks() async {
  final List<Map<String, dynamic>> maps = await _database.query('task');

  return List.generate(maps.length, (i) {
    return TaskModel.fromMap(maps[i], AppDevConfig.userList);
  });
}

Future<List<UserModel>> fetchAllUsers() async {
  final List<Map<String, dynamic>> maps = await _database.query('users');

  return List.generate(maps.length, (i) {
    return UserModel.userListfromJson(maps[i]);
  });
}

Future<void> insertUsers(List<UserModel> users) async {
  final db = _database;
  await db.transaction((txn) async {
    for (UserModel user in users) {
      final List<Map<String, dynamic>> existingUser = await txn.query(
        'users',
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (existingUser.isEmpty) {
        await txn.insert(
          'users',
          user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        log('User with id ${user.id} already exists.');
      }
    }
  });
}

Future<void> insertTodos(List<TodoModel> todos) async {
  final db = _database;

  await db.transaction((txn) async {
    for (TodoModel todo in todos) {
      final List<Map<String, dynamic>> existingTodo = await txn.query(
        'todos',
        where: 'id = ?',
        whereArgs: [todo.id],
      );
      if (existingTodo.isEmpty) {
        await txn.insert(
          'todos',
          todo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        log('Todo with id ${todo.id} already exists.');
      }
    }
  });
}

Future<List<TodoModel>> fetchTodos() async {
  final db = _database;

  final List<Map<String, dynamic>> maps = await db.query('todos');

  List<TodoModel> tasks = List.generate(
    maps.length,
    (i) {
      return TodoModel(
          userId: maps[i]['userId'] as int,
          id: maps[i]['id'] as int,
          title: maps[i]['title'] as String,
          completed: maps[i]['completed'] == 1);
    },
  );
  tasks = tasks.map((task) {
    final user = AppDevConfig.userList.firstWhere(
      (user) => user.id == task.userId,
    );
    return TodoModel(
        userId: task.userId,
        id: task.id,
        title: task.title,
        completed: task.completed,
        user: user);
  }).toList();
  return tasks;
}
