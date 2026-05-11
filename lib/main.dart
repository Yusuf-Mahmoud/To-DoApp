import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D9E75)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const TodoScreen(),
    );
  }
}

enum TaskFilter { all, active, done }

class Task {
  final int id;
  String text;
  bool done;

  Task({required this.id, required this.text, this.done = false});
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  TaskFilter _filter = TaskFilter.all;
  int _nextId = 1;

  List<Task> get _filtered {
    switch (_filter) {
      case TaskFilter.active:
        return _tasks.where((t) => !t.done).toList();
      case TaskFilter.done:
        return _tasks.where((t) => t.done).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  int get _doneCount => _tasks.where((t) => t.done).length;
  int get _activeCount => _tasks.where((t) => !t.done).length;

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks.insert(0, Task(id: _nextId++, text: text));
    });
    _controller.clear();
  }

  void _toggleTask(int id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.done = !task.done;
    });
  }

  void _deleteTask(int id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  void _clearDone() {
    setState(() {
      _tasks.removeWhere((t) => t.done);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Tasks',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0EA),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFFDDDDD5), width: 0.5),
                        ),
                        child: Text(
                          '${_tasks.length} ${_tasks.length == 1 ? 'task' : 'tasks'}',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF888780)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _tasks.isEmpty
                        ? 'Add your first task below'
                        : _activeCount == 0
                            ? 'All tasks complete!'
                            : '$_activeCount remaining',
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFFAAAAAA)),
                  ),
                ],
              ),
            ),

            // Add Task Input
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _addTask(),
                      decoration: InputDecoration(
                        hintText: 'What needs to be done?',
                        hintStyle:
                            const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F0),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFDDDDD5), width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFDDDDD5), width: 0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF1D9E75), width: 1),
                        ),
                      ),
                      style:
                          const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _addTask,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Tabs
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: TaskFilter.values.map((f) {
                  final label = f.name[0].toUpperCase() + f.name.substring(1);
                  final isActive = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF1A1A1A)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive
                                ? const Color(0xFF1A1A1A)
                                : const Color(0xFFDDDDD5),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF888780),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const Divider(height: 0.5, color: Color(0xFFDDDDD5)),

            // Task List
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = filtered[index];
                        return _buildTaskCard(task);
                      },
                    ),
            ),

            // Footer
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _doneCount > 0 ? '$_doneCount completed' : '',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFFAAAAAA)),
                  ),
                  TextButton(
                    onPressed: _doneCount > 0 ? _clearDone : null,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFE24B4A),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Clear done',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: task.done ? 0.55 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: const Color(0xFFDDDDD5), width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _toggleTask(task.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.done
                      ? const Color(0xFF1D9E75)
                      : Colors.transparent,
                  border: Border.all(
                    color: task.done
                        ? const Color(0xFF1D9E75)
                        : const Color(0xFFCCCCC5),
                    width: 1.5,
                  ),
                ),
                child: task.done
                    ? const Icon(Icons.check,
                        color: Colors.white, size: 13)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.text,
                style: TextStyle(
                  fontSize: 14,
                  color: task.done
                      ? const Color(0xFFAAAAAA)
                      : const Color(0xFF1A1A1A),
                  decoration: task.done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: const Color(0xFFAAAAAA),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _deleteTask(task.id),
              child: const Icon(Icons.delete_outline,
                  size: 18, color: Color(0xFFCCCCC5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    final messages = {
      TaskFilter.all: ('📋', 'No tasks yet — add one above!'),
      TaskFilter.active: ('✅', 'No active tasks'),
      TaskFilter.done: ('○', 'Nothing completed yet'),
    };
    final (icon, msg) = messages[_filter]!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          Text(msg,
              style:
                  const TextStyle(fontSize: 14, color: Color(0xFFAAAAAA))),
        ],
      ),
    );
  }
}
