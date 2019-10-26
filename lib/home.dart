import 'package:flutter/material.dart';
import 'package:task_app/add_task.dart';
import 'package:task_app/models/task.dart';
import 'services/auth.dart';
import 'services/task.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService _authService = AuthService();
  TaskService _taskService = TaskService();

  List<Task> _tasks;

  @override
  void initState() {
    super.initState();

    getTasks();
  }

  void getTasks() {
    _taskService.getTasks().then((result) {
      setState(() {
        _tasks = result;
      });
    }).catchError((error) {
      print(error);

      _tasks = [];
    });
  }

  void _handleGoogleSignIn() {
    _authService.googleSignIn();
  }

  void _handleLogout() {
    _authService.signOut();
  }

  Widget _buildTaskItem(BuildContext context, int index) {
    Task task = _tasks[index];

    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.all(15.0),
      color: Colors.grey[400],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            task.title,
            style: TextStyle(fontSize: 24.0),
          ),
          IconButton(
            icon: Icon(Icons.check_circle),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.user,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Falhou"),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Tarefas"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(snapshot.hasData
                      ? Icons.exit_to_app
                      : Icons.account_circle),
                  onPressed: () {
                    snapshot.hasData ? _handleLogout() : _handleGoogleSignIn();
                  })
            ],
          ),
          body: (_tasks == null)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskItem(context, index);
                  },
                ),
          floatingActionButton: Visibility(
            visible: snapshot.hasData,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
