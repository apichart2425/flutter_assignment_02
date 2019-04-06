import 'package:flutter/material.dart';
import '../model/todo.dart';
import './AddScreen.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoScreenState();
  }
}

class TodoScreenState extends State {
  int _current_state = 0;
  int countTodo = 0;
  int countDone = 0;
  List<Todo> listTodo;
  List<Todo> listTodoDone;

  TodoProvider db = TodoProvider();
  @override
  void getTodoLists() async {
    await db.open("todo.db");
    db.getAllTodos().then((listTodo) {
      setState(() {
        this.listTodo = listTodo;
        this.countTodo = listTodo.length;
      });
    });
    db.getAllDoneTodos().then((listTodoDone) {
      setState(() {
        this.listTodoDone = listTodoDone;
        this.countDone = listTodoDone.length;
      });
    });
  }

  Widget build(BuildContext context) {
    List current_tab = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddSrceen()));
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          db.deleteAllDoneTodo();
        },
      )
    ];

    List current_screen = [
      countTodo == 0
          ? Text("No data found..", style: TextStyle(fontSize: 20),)
          : ListView.builder(
              itemCount: countTodo,
              itemBuilder: (context, int position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 5.0,
                    ),
                    ListTile(
                      title: Text(
                        this.listTodo[position].subject,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      trailing: Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              listTodo[position].done = value;
                            });
                            db.update(listTodo[position]);
                          },
                          value: listTodo[position].done),
                    )
                  ],
                );
              },
            ),
      countDone == 0
          ? Text("No data found..", style: TextStyle(fontSize: 20),)
          : ListView.builder(
              itemCount: countDone,
              itemBuilder: (context, int position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 5.0,
                    ),
                    ListTile(
                      title: Text(
                        this.listTodoDone[position].subject,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      trailing: Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              listTodoDone[position].done = value;
                            });
                            db.update(listTodoDone[position]);
                          },
                          value: listTodoDone[position].done),
                    )
                  ],
                );
              },
            ),
    ];
    getTodoLists();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            _current_state == 0 ? current_tab[0] : current_tab[1]
          ],
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: _current_state == 0 ? current_screen[0] : current_screen[1]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _current_state,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Task')),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), title: Text('Complete'))
          ],
          onTap: (int index) {
            setState(() {
              _current_state = index;
            });
          },
        ),
      ),
    );
  }
}
