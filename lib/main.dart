import 'package:flutter/material.dart';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo List",
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        fontFamily: "arial",
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoTask {
  String title;
  bool isCompleted;

  TodoTask({
    required this.title,
    this.isCompleted = false,
  });
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController _taskController =
      TextEditingController();

  final List<TodoTask> _tasks = [
    TodoTask(title: "contoh 1"),
    TodoTask(title: "contoh 2", isCompleted: true),
    TodoTask(title: "contoh 3"),
  ];

  String _selectedFilter = "semua";

  int get _remainingTasks =>
      _tasks.where((task) => !task.isCompleted).length;

  List<TodoTask> get _filteredTasks {
    if (_selectedFilter == "aktif") {
      return _tasks.where((task) => !task.isCompleted).toList();
    }

    if (_selectedFilter == "selesai") {
      return _tasks.where((task) => task.isCompleted).toList();
    }

    return _tasks;
  }

  void _addTask() {
    final taskName = _taskController.text.trim();

    if (taskName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nama tugas tidak boleh kosong."),
        ),
      );
      return;
    }

    setState(() {
      _tasks.add(TodoTask(title: taskName));
      _taskController.clear();
      _selectedFilter = 'All';
    });

    FocusScope.of(context).unfocus();
  }

  void _toggleTask(TodoTask task, bool? value) {
    setState(() {
      task.isCompleted = value ?? false;
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF3F4F6),
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            children: [
              // Input nya
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _addTask(),
                      decoration: InputDecoration(
                        hintText: "Type your task disini...",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E5E5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text("+ Add"),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // jumlah tugas sisA
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      children: [
                        _buildFilter("semua"),
                        const Text(
                          '|',
                          style: TextStyle(color: Colors.grey),
                        ),
                        _buildFilter("aktif"),
                        const Text(
                          '|',
                          style: TextStyle(color: Colors.grey),
                        ),
                        _buildFilter("selesai"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_remainingTasks tasks left',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Expanded(
                child: _filteredTasks.isEmpty
                    ? const Center(
                        child: Text(
                          "ga ada task yang ditampilkan",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 12),
                        itemCount: _filteredTasks.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final task = _filteredTasks[index];

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFEAEAEA),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x18000000),
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CheckboxListTile(
                              value: task.isCompleted,
                              onChanged: (value) =>
                                  _toggleTask(task, value),
                              controlAffinity:
                                  ListTileControlAffinity.leading,
                              activeColor: Colors.black,
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: task.isCompleted
                                      ? Colors.grey
                                      : const Color(0xFF333333),
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilter(String filter) {
    final isSelected = _selectedFilter == filter;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Text(
        filter,
        style: TextStyle(
          fontSize: 12,
          color: isSelected
              ? const Color(0xFF333333)
              : const Color(0xFF777777),
          fontWeight:
              isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}