import 'package:flutter/material.dart';
import 'pages/add_task.dart';
import 'models/task.dart';
import 'services/auth.dart';
import 'services/task.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService _authService = AuthService();
  TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
  }

  void _handleGoogleSignIn() {
    _authService.googleSignIn();
  }

  void _handleLogout() {
    _authService.signOut();
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    return GestureDetector(
      onLongPress: () {
        _taskService.deleteTask(task).then((res) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(res ? "Apagado!" : "Erro ao apagar."),
          ));
        });
      },
      onDoubleTap: () {
        _taskService.completeTask(task, status: !task.done).then((res) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(res ? "Salvo!" : "Erro ao salvar."),
          ));
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.0),
        padding: EdgeInsets.all(15.0),
        color: task.done ? Colors.green[300] : Colors.grey[400],
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.user,
      builder: (context, userSnapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Tarefas"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(userSnapshot.hasData
                      ? Icons.exit_to_app
                      : Icons.account_circle),
                  onPressed: () {
                    userSnapshot.hasData
                        ? _handleLogout()
                        : _handleGoogleSignIn();
                  })
            ],
          ),
          body: Stack(
            children: <Widget>[
              if (userSnapshot.hasError) ...[
                Center(
                  child: Text("Erro ao carregar."),
                )
              ],
              if (!userSnapshot.hasData) ...[
                Center(
                  child: Text("Faça login."),
                )
              ],
              if(userSnapshot.hasData) ... [
                StreamBuilder<Iterable<Task>>(
                stream: _taskService.stream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Erro ao carregar tarefas"),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("Nenhuma tarefa adicionada"),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return _buildTaskItem(
                          context, snapshot.data.elementAt(index));
                    },
                  );
                },
              ),
              ]
              
            ],
          ),
          floatingActionButton: Visibility(
            visible: userSnapshot.hasData,
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
