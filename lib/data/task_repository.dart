import 'package:cloud_firestore/cloud_firestore.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getTasksStream(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> addTask(String title, String userId) {
    return _firestore.collection('tasks').add({
      'title': title,
      'isCompleted': false,
      'userId': userId,
    });
  }

  Future<void> toggleTaskStatus(String docId, bool currentStatus) {
    return _firestore.collection('tasks').doc(docId).update({
      'isCompleted': !currentStatus,
    });
  }

  Future<void> deleteTask(String docId) {
    return _firestore.collection('tasks').doc(docId).delete();
  }
}

// Instance globale pour simplifier l'accès
final taskRepository = TaskRepository();