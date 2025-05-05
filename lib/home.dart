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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("To-Do List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.black),
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: task,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Add Task",
                icon: Icon(Icons.add_task_outlined),
                iconColor: Colors.white,
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),

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
          Padding(padding: EdgeInsets.all(20)),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _tasks[index],
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _tasks.removeAt(index);
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            edit.text = _tasks[index];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    42,
                                    42,
                                    42,
                                  ),
                                  title: Text(
                                    "Edit Task",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: TextField(
                                    controller: edit,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      hintText: "Add Task",
                                      icon: Icon(Icons.add_task_outlined),
                                      iconColor: Colors.white,
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
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
