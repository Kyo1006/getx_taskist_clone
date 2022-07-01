import 'package:get/get.dart';
import 'package:localstore/localstore.dart';
import '../tasks.dart';
import '../theme_management/theme.dart';
import 'package:flutter/material.dart';
import '../theme_management/storage_manager.dart';


class ThemeGetx extends GetxController {
  Rx<ThemeData> themeObx = TaskistTheme.lightTheme.obs;

  @override
  void onInit() {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if(themeMode == 'light') {
        themeObx.value = TaskistTheme.lightTheme;
      } else {
        themeObx.value = TaskistTheme.darkTheme;
      }
    });
    super.onInit();
  }

  void changeTheme(value) {
    if(value) {
      themeObx.value = TaskistTheme.darkTheme;
      StorageManager.saveData('themeMode', 'dark');
    } else {
      themeObx.value = TaskistTheme.lightTheme;
      StorageManager.saveData('themeMode', 'light');
    }
  }
}

class TaskListsGetx extends GetxController {
  RxList<Tasks> taskListsObx = <Tasks>[].obs;

  final _db = Localstore.instance;

  void getData() {
    taskListsObx.clear();
    _db.collection('TaskLists').get().then((value) {
      for (var key in value!.keys) {
        taskListsObx.add(Tasks.fromMap(value[key]));
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit

    getData();
    super.onInit();
  }
}

class TaskListGetx extends GetxController {
  Rx<Tasks> taskListObx =
      Tasks(name: 'example', tasks: [], color: 0, status: false).obs;

  RxDouble progressObx = 0.0.obs;

  addTask(Map<String, dynamic> task) => taskListObx.value.tasks.add(task);

  removeTask(int index) => taskListObx.value.tasks.removeAt(index);

  updateColor(int color) => taskListObx.value.color = color;

  void taskCheck(int index) {
    String taskName = taskListObx.value.tasks[index].keys.toList().first;
    taskListObx.value.tasks[index][taskName] =
        !taskListObx.value.tasks[index][taskName];
    updateStatus();
  }

  void updateStatus() {
    var done = true;
    var tasks = taskListObx.value.tasks;
    for (var task in tasks) {
      if (task.values.toList().first == false) {
        done = false;
        break;
      }
    }
    taskListObx.value.status = done;
  }

  void getProgess() {
    var tasks = taskListObx.value.tasks;
    if (tasks.isNotEmpty) {
      var countDone = tasks
          .where((element) => element.values.toList().first)
          .toList()
          .length;
      progressObx.value = countDone / tasks.length;
    }
  }

  void refreshTasks() {
    // var tempTasks = taskListObx.value.tasks;
    taskListObx.value.tasks.clear();
    // taskListObx.value.tasks.addAll(tempTasks);
    // tempTasks.clear();
  }
}

class TasksGetx extends GetxController {
  RxList<Task> tasksObx = <Task>[].obs;

  removeTask(Task task) => tasksObx.remove(task);
  getData(List<dynamic> tasks) {
    tasksObx.clear();
    tasksObx.value = tasks.map((e) => Task.fromMap(e)).toList();
  }
}

class ColorGetx extends GetxController {
  RxInt currentColorObs = 0xFF8e44ad.obs;
  RxInt pickerColorObs = 0xFF8e44ad.obs;

  changeColor(int color) => pickerColorObs.value = color;

  getColor() => currentColorObs.value = pickerColorObs.value;

  void resetColor() {
    currentColorObs.value = 0xFF8e44ad;
    pickerColorObs.value = 0xFF8e44ad;
  }
}
