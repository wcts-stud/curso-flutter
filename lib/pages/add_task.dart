import 'package:flutter/material.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/services/task.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key key}) : super(key: key);

  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _taskService = TaskService();

  void _save() {
    if(_formKey.currentState.validate()) {
      Task task = Task(
        title: _titleController.text
      );

      _taskService.saveTask(task)
        .then((res) {
          print('res $res');
          if(res) {
            Navigator.of(context).pop();
          } else {

          }
        });
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova tarefa"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if(value.isEmpty) {
                      return 'Digite um título';
                    } 

                    return null;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder()
                  )
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: Icon(Icons.check),
      ),
    );
  }
}