import 'package:sqflite/sqflite.dart';

final String tableTodo = "todo";
final String columnId = "_id";
final String columnSubject = "subject";
final String columnDone =  "done";

class Todo {
  int _id;
  String subject;
  bool done;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnSubject: subject,
      columnDone: done,
    };
    if (_id != null) {
      map[columnId] = _id;
    }
    return map;
  }

  Todo();

  Todo.formMap(Map<String, dynamic> map) {
    this._id = map[columnId];
    this.subject = map[columnSubject];
    this.done = map[columnDone] == 1;
  }
}

class TodoProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableTodo (
        $columnId integer primary key autoincrement,
        $columnSubject text not null,
        $columnDone integer not null
      )
      ''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    todo._id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnSubject, columnDone],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Todo.formMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo._id]);
  }

  Future<List<Todo>> getAllTodos() async {
    var todo = await db.query(tableTodo, where: '$columnDone = 0');
    return todo.map((f) => Todo.formMap(f)).toList();
  }

  Future<List<Todo>> getAllDoneTodos() async {
    var todo = await db.query(tableTodo, where: '$columnDone = 1');
    return todo.map((f) => Todo.formMap(f)).toList();
  }

  Future<void> deleteAllDoneTodo() async {
    await db.delete(tableTodo, where: '$columnDone = 1');
  }

  Future close() async => db.close();
}
