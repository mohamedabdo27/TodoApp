import 'package:flutter/material.dart';
import 'package:todo/cubits/todo_cubit/todo_cubit.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.model});
  final Map model;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model["id"].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text("${model['time']}"),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${model['title']}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${model['date']}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(width: 80),
            IconButton(
              color: Colors.green,
              onPressed: () {
                TodoCubit.getCubit(context).updateData(
                  status: "done",
                  id: model["id"],
                );
              },
              icon: const Icon(Icons.check_box),
            ),
            IconButton(
              color: Colors.grey,
              onPressed: () {
                TodoCubit.getCubit(context).updateData(
                  status: "archived",
                  id: model["id"],
                );
              },
              icon: const Icon(Icons.archive),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        TodoCubit.getCubit(context).deleteData(id: model["id"]);
      },
    );
  }
}
