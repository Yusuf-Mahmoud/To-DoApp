import 'package:hive/hive.dart';

import '../../domain/entities/task.dart';

class TaskModel {
  final int id;
  final String text;
  final bool done;

  TaskModel({required this.id, required this.text, required this.done});

  factory TaskModel.fromTask(Task task) {
    return TaskModel(id: task.id, text: task.text, done: task.done);
  }

  Task toTask() {
    return Task(id: id, text: text, done: done);
  }
}

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final id = reader.readInt();
    final text = reader.readString();
    final done = reader.readBool();
    return TaskModel(id: id, text: text, done: done);
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.text);
    writer.writeBool(obj.done);
  }
}
