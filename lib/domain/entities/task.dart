enum TaskFilter { all, active, done }

class Task {
  final int id;
  final String text;
  final bool done;

  Task({required this.id, required this.text, this.done = false});

  Task copyWith({int? id, String? text, bool? done}) {
    return Task(
      id: id ?? this.id,
      text: text ?? this.text,
      done: done ?? this.done,
    );
  }
}
