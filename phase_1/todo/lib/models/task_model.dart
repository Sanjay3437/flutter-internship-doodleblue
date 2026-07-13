import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  bool isCompleted;

  TaskModel({
    required this.task,
    this.isCompleted = false,
  });
}