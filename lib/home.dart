import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final task = TextEditingController();
  List<String> _tasks = [];

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
                onPressed: () {},
                label: Text("Delete Task"),
                icon: Icon(Icons.remove),
              ),
              FloatingActionButton.extended(
                onPressed: () {},
                label: Text("Clear All Tasks"),
                icon: Icon(Icons.delete_forever_sharp),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_tasks[index]));
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
