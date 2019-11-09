import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/services/auth.dart';

class TaskService {
  static final _path = 'tasks';
  static final Firestore _db = Firestore.instance;
  static final _collection = _db.collection(_path);
  AuthService _authService;

  TaskService() {
    _authService = AuthService();
  }

  Future<bool> deleteTask(Task task) async {
    try {
      await _collection.document(task.id).delete();

      return true;
    } catch (error) {
      print(error);

      return false;
    }
  }

  Future<bool> completeTask(Task task, {bool status = true}) async {
    try {
      await _collection.document(task.id).updateData({
        'done': status
      });

      return true;
    } catch (error) {
      print(error);
      
      return false;
    }
  }

  Future<bool> saveTask(Task task) async {
    FirebaseUser user = await _authService.currentUser();

    if(user == null) {
      return false;
    }

    try {
      _collection.add({
        'title': task.title,
        'done': false,
        'user': user.uid,
        'createdAt': DateTime.now()
      });

      return true;
    } catch (error) {
      print(error);

      return false;
    }
  }

  Stream<Iterable<Task>> stream() {
    if(AuthService.uid == null) {
      return null;
    }

    return _collection
            .where('user', isEqualTo: AuthService.uid)
            .orderBy('createdAt', descending: true)
            .snapshots()
            .map((QuerySnapshot _list)
              => _list.documents.map((DocumentSnapshot _doc)
              => Task.fromFirestore(_doc)));
  }

  Future<List<Task>> getTasks() async {
    try {
      QuerySnapshot tasks = await _collection.getDocuments();

      return tasks.documents
        .map((DocumentSnapshot document) => Task.fromFirestore(document))
        .toList();

    } catch (error) {
      print(error);
      return null;
    }
  }
}