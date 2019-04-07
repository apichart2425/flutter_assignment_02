import 'package:sqflite/sqflite.dart';

final String tableTodo = "todo";
final String Id = "_id";
final String Title = "Title";
final String Done = "done";

class Todo {
  int _id;
  String title;
  bool done;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      Title: title,
      Done: done,
    };
    if (_id != null) {
      map[Id] = _id;
    }
    return map;
  }

  Todo();

  Todo.formMap(Map<String, dynamic> map) {
    this._id = map[Id];
    this.title = map[Title];
    this.done = map[Done] == 1;
  }
}

class TodoProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableTodo (
        $Id integer primary key autoincrement,
        $Title text not null,
        $Done integer not null
      )
      ''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    // print("Insert data in todolist");
    todo._id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [Id, Title, Done], where: '$Id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return new Todo.formMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$Id = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    print("Set State Done 0 or 1");
    return await db.update(tableTodo, todo.toMap(),
        where: '$Id = ?', whereArgs: [todo._id]);
  }

  Future<List<Todo>> getAllListTodo() async {
    var todo = await db.query(tableTodo, where: '$Done = 0');

    return todo.map((f) => Todo.formMap(f)).toList();
  }

  Future<List<Todo>> getAllListDoneTodo() async {
    var todo = await db.query(tableTodo, where: '$Done = 1');
    return todo.map((f) => Todo.formMap(f)).toList();
  }

  Future<void> deleteAllDoneTodo() async {
    print('Delete Done list');
    await db.delete(tableTodo, where: '$Done = 1');
  }
}
