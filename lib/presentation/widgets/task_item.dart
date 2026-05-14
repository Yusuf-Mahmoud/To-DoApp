import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF121417),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF22252D)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.done,
            onChanged: onToggle,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            activeColor: const Color(0xFF1F8EF1),
            checkColor: Colors.black,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.text,
              style: TextStyle(
                color: task.done ? Colors.white54 : Colors.white,
                decoration: task.done
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                fontSize: 15,
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
