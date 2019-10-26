import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/models/task.dart';

class TaskService {
  static final _path = 'tasks';
  static final Firestore _db = Firestore.instance;
  static final _collection = _db.collection(_path);

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