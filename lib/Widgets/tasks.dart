import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Widgets/tasks_builder.dart';
import 'package:todo/cubits/todo_cubit/todo_cubit.dart';
import 'package:todo/cubits/todo_cubit/todo_states.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = TodoCubit.getCubit(context).newTasks;

          return TasksBuilder(tasks: tasks);
        });
  }
}
