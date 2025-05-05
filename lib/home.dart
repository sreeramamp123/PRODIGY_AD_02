import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final task = TextEditingController();
  final edit = TextEditingController();
  final List<String> _tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: task),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  String task_str = task.text.trim();
                  if (task_str.isNotEmpty) {
                    setState(() {
                      _tasks.add(task_str);
                      task.clear();
                    });
                  }
                },
                label: Text("Add Task"),
                icon: Icon(Icons.add_task),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    _tasks.clear();
                  });
                },
                label: Text("Clear All Tasks"),
                icon: Icon(Icons.remove),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index]),
                  trailing: SizedBox(
                    width: 90,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _tasks.removeAt(index);
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            edit.text = _tasks[index];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit Task"),
                                  content: TextField(controller: edit),
                                  actions: [
                                    FloatingActionButton.extended(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      label: Text("Cancel"),
                                      icon: Icon(Icons.cancel),
                                    ),
                                    FloatingActionButton.extended(
                                      onPressed: () {
                                        if (edit.text.trim().isNotEmpty) {
                                          setState(() {
                                            _tasks[index] = edit.text.trim();
                                          });
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      label: Text("Edit"),
                                      icon: Icon(Icons.edit),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    task.dispose();
    super.dispose();
  }
}
