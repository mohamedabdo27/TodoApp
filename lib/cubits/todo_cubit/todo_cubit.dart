import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/Widgets/archived_tasks.dart';
import 'package:todo/Widgets/done_tasks.dart';
import 'package:todo/Widgets/tasks.dart';
import 'package:todo/cubits/todo_cubit/todo_states.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(InitialState());
//=====================================================
  static TodoCubit getCubit(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks()
  ];
  List<String> appBarText = ["New Tasks", "Done Tasks", "Archived Tasks"];
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  ///====================================================
  void changeNafBar(int index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

//=======================================
  void createDatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, vertion) {
        database
            .execute(
              "CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)",
            )
            .then((value) {});
      },
      onOpen: (database) {
        getFromDatabase(database);
      },
    ).then((value) {
      database = value;

      emit(CreateDatabasetate());
    });
  }

//=-======================================================
  updateData({required String status, required int id}) {
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      emit(UpdateDatabasetate());
      getFromDatabase(database!);
    });
  }

  ///=======================================================
  deleteData({required int id}) {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(DeleteFromDatabaseState());
      getFromDatabase(database!);
    });
  }

//========================================================
  getFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(LoadingState());
    database.rawQuery('SELECT * FROM tasks').then(
      (value) {
        // value.forEach((element)
        for (final element in value) {
          if (element["status"] == "new") {
            newTasks.add(element);
            // print(newTasks);
          } else if (element["status"] == "done") {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        }
        //  );

        emit(GetFromDatabaseState());
      },
    );
  }

//=======================================================
  insertDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database!.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title,time,date,status) VALUES( "$title","$time","$date","new")')
          .then((value) {
        emit(InsertToDatabaseState());
        getFromDatabase(database!);
      });
    });
  }

//============================================================
  bool bottomSheetShow = false;
  IconData icon = Icons.edit;

  void changeFloatButton({required iconData, required bool isShow}) {
    icon = iconData;
    bottomSheetShow = isShow;

    emit(ChangeFloatButton());
  }
}
