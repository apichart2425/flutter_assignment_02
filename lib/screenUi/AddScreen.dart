import 'package:flutter/material.dart';
import '../model/todo.dart';

class AddSrceen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddlistSrceen();
  }
}

class AddlistSrceen extends State<AddSrceen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController TitleTodo = TextEditingController();
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
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: TitleTodo,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value.isEmpty) {
                    print("isEmtry");
                    return "Please fill subject";
                  }
                },
              ),
              RaisedButton(
                child: Text('Save'),
                onPressed: () async {
                  _formKey.currentState.validate();
                  if (TitleTodo.text.length > 0) {
                    await db.open("todo.db");
                    Todo _todo = Todo();
                    _todo.title = TitleTodo.text;
                    _todo.done = false;
                    await db.insert(_todo);
                    print('Save data in todo');
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
