import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sankar/features/tasks/domain/repositories/task_repository.dart';
import 'package:sankar/features/tasks/data/models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<TaskModel>> getTasks(String uid) {
    print('DEBUG: Starting getTasks stream for UID: $uid');
    return _firestore
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      print('DEBUG: Received snapshot with ${snapshot.docs.length} documents');
      final tasks = snapshot.docs.map((doc) {
        try {
          return TaskModel.fromMap(doc.data(), doc.id);
        } catch (e) {
          print('DEBUG: Error parsing task ${doc.id}: $e');
          rethrow;
        }
      }).toList();
      
      // Sort in memory to avoid needing a composite index
      tasks.sort((a, b) => a.date.compareTo(b.date));
      return tasks;
    });
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await _firestore.collection('tasks').add(task.toMap());
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  @override
  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': status.name,
    });
  }
}
