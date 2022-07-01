import 'package:flutter/material.dart';
import 'package:taskist/controller/getx_controller.dart';
import '../tasks.dart';

import 'package:localstore/localstore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditTask extends StatelessWidget {
  const EditTask({Key? key, required this.item}) : super(key: key);

  final Tasks item;

  static final _db = Localstore.instance;

  static final ColorGetx cColor = Get.put(ColorGetx());

  static final TaskListGetx cTaskList = Get.put(TaskListGetx());

  static final TasksGetx cTasks = Get.put(TasksGetx());

  static final TaskListsGetx cTaskLists = Get.find();

  static var myController = TextEditingController();

  void goBack(BuildContext context) {
    item.update(cTaskList.taskListObx.value, _db);
    cTaskLists.getData();
    cTaskList.progressObx.value = 0;
    cColor.resetColor();
    Navigator.pop(context);
  }

  Widget colorPickerButton(BuildContext context) {
    return IconButton(
        onPressed: () => showDialog(
            context: context, builder: (context) => showColorPicker(context)),
        icon: Obx(() => Icon(Icons.circle,
            color: Color(cColor.currentColorObs.value), size: 35)));
  }

  Widget showColorPicker(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: Color(cColor.pickerColorObs.value),
          onColorChanged: (color) => cColor.changeColor(color.value),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Got it'),
          onPressed: () {
            cColor.getColor();
            cTaskList.updateColor(cColor.currentColorObs.value);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget cancelButton(BuildContext context) {
    return IconButton(
        onPressed: () => goBack(context),
        icon: Obx(() => Icon(Icons.cancel_outlined,
            color: Color(cColor.currentColorObs.value), size: 35)));
  }

  Widget deleteButton(BuildContext context) {
    return IconButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Delete: ${item.name}'),
                  content: const Text('Are you sure want to delete this list'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color(cColor.currentColorObs.value)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        var nav = Navigator.of(context);
                        nav.pop();
                        nav.pop();
                        item.delete(_db);
                        cTaskLists.taskListsObx.remove(item);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color(cColor.currentColorObs.value)),
                    )
                  ],
                )),
        icon: Obx(() => Icon(
          Icons.delete,
          color: Color(cColor.currentColorObs.value),
          size: 40,
        )));
  }

  Obx progressBar() {
    return Obx(() => Row(children: [
          Expanded(
            flex: 11,
            child: LinearProgressIndicator(
              value: cTaskList.progressObx.value,
              minHeight: 6,
              color: Color(cColor.currentColorObs.value),
              backgroundColor: const Color(0xFFecf0f1),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                alignment: Alignment.topRight,
                child: Text('${(cTaskList.progressObx.value * 100).round()} %',
                    style: const TextStyle(
                      fontSize: 14,
                    ))),
          )
        ]));
  }

  Widget buildTaskList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 250,
      // height: 200,
      alignment: Alignment.topLeft,
      child: Obx(() => ListView.builder(
            itemCount: cTasks.tasksObx.length,
            itemBuilder: (BuildContext context, index) {
              // return buildTask(cTaskList.taskListObx.value.tasks[index], index);
              return buildTask(cTasks.tasksObx[index], index);
            },
          )),
    );
  }

  void doNothing(BuildContext context) {}

  Widget buildTask(Task task, int index) {
    Color getColor(Set<MaterialState> states) {
      return Color(cColor.currentColorObs.value);
    }

    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: doNothing,
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              icon: Icons.save,
              label: '',
            ),
            SlidableAction(
              onPressed: (context) {
                cTasks.removeTask(task);
                cTaskList.removeTask(index);
                // cTaskList.refreshTasks();
                // cTaskList.getProgess();
              },
              backgroundColor: Color(cColor.currentColorObs.value),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Row(
          children: [
            Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: task.status,
                onChanged: (bool? value) {
                  // item.updateTask(index, !task.values.toList().first,
                  //     cColor.currentColorObs.value, _db);
                  cTaskList.taskCheck(index);
                  cTasks.getData(cTaskList.taskListObx.value.tasks);
                  cTaskList.getProgess();
                }),
            Text(task.name,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: task.status
                        ? Color(cColor.currentColorObs.value)
                        : Colors.black,
                    decoration:
                        task.status ? TextDecoration.lineThrough : null)),
          ],
        ));
  }

  Widget addTaskButton(BuildContext context) {
    return Obx(() => FloatingActionButton(
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            final TasksGetx cTasks = Get.find();
            return AlertDialog(
              content: TextField(
                controller: myController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Item',
                ),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF7f8c8d)),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // cTaskList.addTask({myController.text: false});
                    cTaskList.addTask({myController.text: false});
                    // cTaskList.getProgess();
                    Navigator.pop(context, 'OK');
                    myController.clear();
                  },
                  child: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                      primary: Color(cColor.currentColorObs.value)),
                )
              ],
            );
          }),
      child: const Icon(Icons.add, color: Colors.white),
      backgroundColor: Color(cColor.currentColorObs.value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    cTaskList.taskListObx.value = item;
    cTaskList.getProgess();

    cTasks.getData(cTaskList.taskListObx.value.tasks);

    cColor.currentColorObs.value = item.color;
    cColor.pickerColorObs.value = item.color;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: colorPickerButton(context),
        actions: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: cancelButton(context))
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Task list name
                        Text(item.name,
                            style: const TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        deleteButton(context),
                      ]),
                  progressBar(),
                  buildTaskList(context),
                ])),
      ),
      floatingActionButton: addTaskButton(context),
    );
  }
}
