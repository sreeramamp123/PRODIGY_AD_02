import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final task = TextEditingController();
  final edit = TextEditingController();
  Box<Task>? taskBox;

  @override
  void initState() {
    super.initState();
    Hive.openBox<Task>('tasks').then((box) {
      setState(() {
        taskBox = box;
      });
    });
  }

  void addTask(String title) {
    final newTask = Task(title: title);
    taskBox?.add(newTask);
    setState(() {});
  }

  void deleteTask(int index) {
    taskBox?.deleteAt(index);
    setState(() {});
  }

  void editTask(int index, String newTitle) {
    final task = taskBox?.getAt(index);
    if (task != null) {
      task.title = newTitle;
      task.save();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('tasks') || taskBox == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("To-Do List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
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
                  String taskStr = task.text.trim();
                  if (taskStr.isNotEmpty) {
                    addTask(taskStr);
                    task.clear();
                  }
                },
                label: Text("Add Task"),
                icon: Icon(Icons.add_task),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  taskBox?.clear();
                  setState(() {});
                },
                label: Text("Clear All"),
                icon: Icon(Icons.remove),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(20)),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: taskBox!.listenable(),
              builder: (context, Box<Task> box, _) {
                if (box.isEmpty) {
                  return Center(child: Text("No tasks yet.", style: TextStyle(color: Colors.white)));
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final task = box.getAt(index);

                    return CheckboxListTile(
                      title: Text(
                        task!.title,
                        style: TextStyle(
                          color: Colors.white,
                          decoration: task.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      value: task.isDone,
                      onChanged: (checked) {
                        if (checked == true) {
                          deleteTask(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Task completed!')),
                          );
                        }
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      secondary: IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          edit.text = task.title;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Color.fromARGB(255, 42, 42, 42),
                                title: Text("Edit Task", style: TextStyle(color: Colors.white)),
                                content: TextField(
                                  controller: edit,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintText: "Edit Task",
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
                                        editTask(index, edit.text.trim());
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
                    );
                  },
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
