import 'package:sankar/features/tasks/data/models/task_model.dart';

abstract class TaskRepository {
  Stream<List<TaskModel>> getTasks(String uid);
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<void> updateTaskStatus(String taskId, TaskStatus status);
}
