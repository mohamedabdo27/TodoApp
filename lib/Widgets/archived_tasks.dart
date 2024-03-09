import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Widgets/tasks_builder.dart';
import 'package:todo/cubits/todo_cubit/todo_cubit.dart';
import 'package:todo/cubits/todo_cubit/todo_states.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = TodoCubit.getCubit(context).archivedTasks;

          return TasksBuilder(tasks: tasks);
        });
  }
}
