import 'package:sqflite/sqflite.dart';

final String tableTodo = "todo";
final String _Id = "id";
final String _Title = "title";
final String _Done = "done";

class Todo {
  int _id;
  String title;
  bool done;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _Title: title,
      _Done: done,
    };
    if (_id != null) {
      map[_Id] = _id;
    }
    return map;
  }

  Todo();

  Todo.formMap(Map<String, dynamic> map) {
    this._id = map[_Id];
    this.title = map[_Title];
    this.done = map[_Done] == 1;
  }
}

class TodoProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableTodo (
        $_Id integer primary key autoincrement,
        $_Title text not null,
        $_Done integer not null
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
        columns: [_Id, _Title, _Done], where: '$_Id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return new Todo.formMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$_Id = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    print("Set State Done 0 or 1");
    return await db.update(tableTodo, todo.toMap(),
        where: '$_Id = ?', whereArgs: [todo._id]);
  }

  Future<List<Todo>> getAllListTodo() async {
    var todo = await db.query(tableTodo, where: '$_Done = 0');

    return todo.map((f) => Todo.formMap(f)).toList();
  }

  Future<List<Todo>> getAllListDoneTodo() async {
    var todo = await db.query(tableTodo, where: '$_Done = 1');
    return todo.map((f) => Todo.formMap(f)).toList();
  }

  Future<void> deleteAllDoneTodo() async {
    print('Delete Done list');
    await db.delete(tableTodo, where: '$_Done = 1');
  }
}
