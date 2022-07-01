import 'package:flutter/material.dart';
import '../components/header.dart';
import 'package:localstore/localstore.dart';
import '../tasks.dart';
import 'edit_task.dart';
import '../controller/getx_controller.dart';
import 'package:get/get.dart';

class TaskDone extends StatelessWidget {
  const TaskDone({Key? key}) : super(key: key);

  static final TaskListsGetx cTasks = Get.put(TaskListsGetx());

  void navigateEditTask(BuildContext context, Tasks item) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditTask(item: item)));
  }

  Container buildTaskLists(BuildContext context) {
    return Container(
      height: 320,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Obx(() => ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemCount: cTasks.taskListsObx.length,
            itemBuilder: (BuildContext context1, index) {
              final item = cTasks.taskListsObx[index];
              if (item.status == false) {
                return const SizedBox.shrink();
              }
              return taskListItem(context, item);
            },
          )),
    );
  }

  InkWell taskListItem(BuildContext context, Tasks item) {
    return InkWell(
        onTap: () => navigateEditTask(context, item),
        child: Container(
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(item.color),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    child: Text(item.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ))),
                const Divider(
                  indent: 50,
                  thickness: 3,
                  color: Colors.white,
                ),
                SizedBox(
                    width: 180,
                    height: 200,
                    // margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: Column(
                      children: item.tasks.map((task) {
                        return Row(
                          children: <Widget>[
                            Checkbox(
                                checkColor: Colors.white,
                                shape: const CircleBorder(),
                                // fillColor: MaterialStateProperty.resolveWith(getColor),
                                activeColor: Color(item.color),
                                value: task.values.toList().first,
                                onChanged: (bool? value) {}),
                            Text(task.keys.toList().first,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: task.values.toList().first
                                        ? const Color(0xFFf7f1e3)
                                        : Colors.white,
                                    decoration: task.values.toList().first
                                        ? TextDecoration.lineThrough
                                        : null)),
                          ],
                        );
                      }).toList(),
                    ))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: <Widget>[
          const Header(title: 'Done'),
          const SizedBox(height: 120,),
          buildTaskLists(context),
        ],
      )),
    );
  }
}
