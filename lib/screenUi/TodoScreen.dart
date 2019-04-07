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
  
  int _currentState = 0 ;
  int _countList = 0 ;
  int _countListDone = 0 ;
  List<Todo> listTodo;
  List<Todo> listDone;

  TodoProvider db = TodoProvider();
  @override
  void getTodoLists() async {
    await db.open("todo.db");
    db.getAllListTodo().then((listTodo) {
      setState(() {
        this.listTodo = listTodo;
        this._countList = listTodo.length;
      });
    });
    db.getAllListDoneTodo().then((listDone) {
      setState(() {
        this.listDone = listDone;
        this._countListDone = listDone.length;
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
      _countList == 0
          ? Text("No data found..", style: TextStyle(fontSize: 20),)
          : ListView.builder(
              itemCount: _countList,
              itemBuilder: (context, int position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 5.0,
                    ),
                    ListTile(
                      title: Text(
                        this.listTodo[position].title,
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
      _countListDone == 0
          ? Text("No data found..", style: TextStyle(fontSize: 20),)
          : ListView.builder(
              itemCount: _countListDone,
              itemBuilder: (context, int position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 5.0,
                    ),
                    ListTile(
                      title: Text(
                        this.listDone[position].title,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      trailing: Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              listDone[position].done = value;
                            });
                            db.update(listDone[position]);
                          },
                          value: listDone[position].done),
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
            _currentState == 0 ? current_tab[0] : current_tab[1]
          ],
          backgroundColor: Colors.pink,
        ),
        body: Center(
            child: _currentState == 0 ? current_screen[0] : current_screen[1]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentState,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Task'),),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), title: Text('Complete'))
          ],
          onTap: (int index) {
            setState(() {
              _currentState = index;
            });
          },
        ),
      ),
    );
  }
}
