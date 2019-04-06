import 'package:flutter/material.dart';
import '../model/todo.dart';

class AddSrceen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddlistSrceen();
  }
}

class AddlistSrceen extends State<AddSrceen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController subjectTodo = TextEditingController();
  TodoProvider db = TodoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: subjectTodo,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill subject";
                  }
                },
              ),
              RaisedButton(
                child: Text('Save'),
                onPressed: () async {
                  _formkey.currentState.validate();
                  if (subjectTodo.text.length > 0) {
                    await db.open("todo.db");
                    Todo todo = Todo();
                    todo.subject = subjectTodo.text;
                    todo.done = false;
                    await db.insert(todo);
                    print(todo);
                    Navigator.pop(context, true);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
