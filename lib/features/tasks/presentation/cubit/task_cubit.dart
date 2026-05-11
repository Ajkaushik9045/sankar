import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sankar/features/tasks/domain/repositories/task_repository.dart';
import 'package:sankar/features/tasks/data/models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _taskRepository;
  StreamSubscription? _taskSubscription;

  TaskCubit(this._taskRepository) : super(TaskInitial());

  /// Starts listening to tasks for a specific user.
  /// Automatically cancels any existing subscription.
  void getTasks(String uid) {
    print('DEBUG: TaskCubit.getTasks called for UID: $uid');
    
    // Safety check: Don't start a listener for an empty UID
    if (uid.isEmpty) {
      print('DEBUG: TaskCubit.getTasks - UID is empty, clearing tasks.');
      clearTasks();
      return;
    }

    emit(TaskLoading());
    _cancelSubscription();
    
    _taskSubscription = _taskRepository.getTasks(uid).listen(
      (tasks) {
        print('DEBUG: TaskCubit received ${tasks.length} tasks');
        emit(TaskLoaded(tasks));
      },
      onError: (error) {
        // If we get a permission-denied error, it usually means the user logged out
        // or the session expired. We should handle this gracefully.
        print('DEBUG: TaskCubit error: $error');
        if (error.toString().contains('permission-denied')) {
          print('DEBUG: Permission denied detected. Silently clearing tasks.');
          emit(TaskInitial());
        } else {
          emit(TaskError(error.toString()));
        }
      },
    );
  }

  /// Explicitly cancels the task listener and resets state.
  /// Call this during logout to prevent permission errors.
  void clearTasks() {
    print('DEBUG: TaskCubit.clearTasks called.');
    _cancelSubscription();
    emit(TaskInitial());
  }

  void _cancelSubscription() {
    _taskSubscription?.cancel();
    _taskSubscription = null;
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _taskRepository.addTask(task);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _taskRepository.updateTask(task);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepository.deleteTask(taskId);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      await _taskRepository.updateTaskStatus(taskId, status);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _cancelSubscription();
    return super.close();
  }
}
