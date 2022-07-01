import 'dart:async';
import 'package:localstore/localstore.dart';

// TaskList taskListFromJson(String str) => TaskList.fromJson(json.decode(str));

// String taskListToJson(TaskList data) => json.encode(data.toJson());

class Task {
  final String name;
  bool status;

  Task({
    required this.name,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {name: status};
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        name: map.keys.toList().first, status: map.values.toList().first);
  }
}

class Tasks {
  final String name;
  final List<dynamic> tasks;
  bool status;
  int color;

  Tasks(
      {required this.name,
      required this.tasks,
      required this.status,
      required this.color});

  Map<String, dynamic> toMap() {
    return {'name': name, 'tasks': tasks, 'status': status, 'color': color};
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
      name: map['name'],
      tasks: map['tasks'],
      status: map['status'],
      color: map['color'],
    );
  }
}

extension ExtTasks on Tasks {
  Future save(Localstore db) async {
    // final _db = Localstore.instance;
    return db.collection('TaskLists').doc(name).set(toMap());
  }

  Future delete(Localstore db) async {
    // final _db = Localstore.instance;
    return db.collection('TaskLists').doc(name).delete();
  }

  Future update(Tasks tasks, Localstore db) async {
    final item = Tasks(
        name: tasks.name,
        tasks: tasks.tasks,
        status: tasks.status,
        color: tasks.color);
    return db.collection('TaskLists').doc(name).set(item.toMap());
  }
}
