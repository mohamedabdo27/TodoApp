import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/cubits/todo_cubit/todo_cubit.dart';
import 'package:todo/cubits/todo_cubit/todo_states.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController timeTextController = TextEditingController();
  final TextEditingController dateTextController = TextEditingController();
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (BuildContext context, TodoStates state) {
          if (state is InsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, TodoStates state) {
          TodoCubit cubit = TodoCubit.getCubit(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text(cubit.appBarText[cubit.currentIndex])),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.bottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(
                        title: titleTextController.text,
                        time: timeTextController.text,
                        date: dateTextController.text);

                    // print(tasks.length);
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        elevation: 20,
                        (context) => Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(15),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "the title must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  controller: titleTextController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Title text"),
                                    prefixIcon: Icon(Icons.title),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeTextController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "the time must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.datetime,
                                  controller: timeTextController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Task time"),
                                    prefixIcon:
                                        Icon(Icons.watch_later_outlined),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(
                                          now.year + 1, now.month, now.day),
                                    ).then((value) {
                                      dateTextController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "the date must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  controller: dateTextController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Task date"),
                                      prefixIcon: Icon(Icons.calendar_today)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeFloatButton(
                        iconData: Icons.edit, isShow: false);
                  });
                  cubit.changeFloatButton(iconData: Icons.add, isShow: true);
                }
              },
              child: Icon(cubit.icon),
            ),
            body: state is! LoadingState
                ? cubit.screens[cubit.currentIndex]
                : const CircularProgressIndicator(),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeNafBar(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: "Archived"),
                ]),
          );
        },
      ),
    );
  }
}


// createDatabase() async {
//   Database database = await openDatabase(
//     "todo.db",
//     version: 1,
//     onCreate: (database, version) {
//       database.execute("").then((value) {
//         print("table created");
//       }).catchError((Error){

//       print(Error.toString());
//       });
//     },
//     onOpen: (database) {},
//   );
// }
