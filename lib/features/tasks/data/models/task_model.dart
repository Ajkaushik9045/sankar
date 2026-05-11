import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus {
  todo,
  inProgress,
  completed;

  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  static TaskStatus fromString(String status) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => TaskStatus.todo,
    );
  }
}

class TaskModel extends Equatable {
  final String id;
  final String uid;
  final String title;
  final String description;
  final DateTime date;
  final TaskStatus status;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.date,
    this.status = TaskStatus.todo,
    required this.createdAt,
  });

  bool get isCompleted => status == TaskStatus.completed;

  TaskModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    DateTime? date,
    TaskStatus? status,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TaskModel(
      id: documentId,
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      status: TaskStatus.fromString(map['status'] ?? 'todo'),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props => [id, uid, title, description, date, status, createdAt];
}
