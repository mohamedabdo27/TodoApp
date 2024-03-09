import 'package:flutter/material.dart';
import 'package:todo/Widgets/task_item.dart';

class TasksBuilder extends StatelessWidget {
  const TasksBuilder({super.key, required this.tasks});
  final List<Map> tasks;
  @override
  Widget build(BuildContext context) {
    return tasks.isNotEmpty
        ? ListView.separated(
            itemBuilder: (context, index) {
              return TaskItem(model: tasks[index]);
            },
            separatorBuilder: (context, index) {
              return Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              );
            },
            itemCount: tasks.length)
        : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  color: Colors.grey,
                  size: 100,
                ),
                Text(
                  "No tasks yet ,try add some",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          );
  }
}
