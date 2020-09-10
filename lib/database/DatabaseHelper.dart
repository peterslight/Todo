import 'package:flutter_app/models/TaskModel.dart';
import 'package:flutter_app/models/Todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'todo.db'),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
      await db.execute(
          "CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");
      return db;
    }, version: 1);
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database db = await getDatabase();
    await db
        .insert("tasks", task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        //return the value of the operation
        .then((resultCode) => taskId = resultCode);
    return taskId;
  }

  Future<int> updateTask(int id, String taskTitle, String desc) async {
    int result = -10;
    Database db = await getDatabase();
    await db
        .rawUpdate(
            "UPDATE tasks SET (title, description) = ('$taskTitle', '$desc') WHERE id = '$id'")
        .then((value) {
      result = value;
    });
    return result;
  }

  Future<int> deleteTask(int id) async {
    int result = -10;
    Database db = await getDatabase();
    await db.rawDelete("DELETE FROM tasks WHERE id = '$id'").then((value) {
      result = value;
    });
    await db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");

    return result;
  }

  Future<void> insertTodo(Todo todo) async {
    Database db = await getDatabase();
    await db.insert("todo", todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> taskMap = await db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description'],
      );
    });
  }

  Future<List<Todo>> getTodos(int taskId) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> todoMap =
        await db.rawQuery('SELECT * FROM todo WHERE taskId = $taskId');
    return List.generate(todoMap.length, (index) {
      return Todo(
        id: todoMap[index]['id'],
        taskId: todoMap[index]['taskId'],
        title: todoMap[index]['title'],
        isDone: todoMap[index]['isDone'],
      );
    });
  }

  Future<int> todoIsDone(int todoId, int doneStatus) async {
    Database db = await getDatabase();
    await db.rawUpdate("UPDATE todo SET isDone = '$doneStatus' WHERE id = '$todoId'");
  }
}
