import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'services/auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    // _handleGoogleSignIn();
  }

  void _handleGoogleSignIn() {
    _authService.googleSignIn();
  }

  void _handleLogout() {
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: _authService.user,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Center(child: Text("Falhou"),);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Tarefas"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                      snapshot.hasData ? Icons.exit_to_app : Icons.account_circle),
                  onPressed: () {
                    snapshot.hasData ? _handleLogout() : _handleGoogleSignIn();
                  })
            ],
          ),
          body: Container(
            child: FlatButton(
              onPressed: () {},
              child: Text("Ola"),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: snapshot.hasData,
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
