import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {

  @HiveField(0)
  String task;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isCompleted;

  TaskModel({
    required this.task,
    required this.description,
    this.isCompleted = false,
  });

  TaskModel copyWith({
    String? task,
    String? description,
    bool? isCompleted,
  }) {
    return TaskModel(
      task: task ?? this.task,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}