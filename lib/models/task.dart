import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  Task({
    this.id,
    this.done = false,
    @required this.title,
    this.user
  });

  final String id;
  final bool done;
  final String title;
  final String user;

  factory Task.fromFirestore(DocumentSnapshot taskSnapshot) {
    Map data = taskSnapshot.data;

    return Task(
      id: taskSnapshot.documentID,
      done: data['done'] ?? false,
      title: data['title'] ?? '',
      user: data['user'] ?? null
    );
  }
}