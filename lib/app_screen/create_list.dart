import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:localstore/localstore.dart';
import '../tasks.dart';
import '../controller/getx_controller.dart';
import 'package:get/get.dart';

class CreateList extends StatelessWidget {
  const CreateList({Key? key}) : super(key: key);

  static final _db = Localstore.instance;

  static final TaskListsGetx cTasks = Get.find();

  static final ColorGetx cColor = Get.put(ColorGetx());

  static final myController = TextEditingController();

  void goBack(BuildContext context) {
    myController.clear();
    cColor.resetColor();
    _onWillPop(context);
    Navigator.pop(context);
  }

  static final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () => goBack(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 36),
            ),
            title: const Text(
              'New List',
            ),
            centerTitle: true,
            elevation: 0,
            // backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          // backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Add the name of your list',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      // color: Color(0xFF95a5a6)
                    )),
                buildListNameInput(),
                colorPickerButton(context)
              ],
            ),
          ),
          floatingActionButton: createTaskListButton(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
        onWillPop: () => _onWillPop(context));
  }

  Future<bool> _onWillPop(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    return true;
  }

  // @override
  TextField buildListNameInput() {
    return TextField(
      autofocus: true,
      controller: myController,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Your List...',
      ),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
      focusNode: focusNode,
    );
  }

  Obx colorPickerButton(BuildContext context) {
    return Obx(() => ElevatedButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => showColorPicker(context)),
        child: const SizedBox.shrink(),
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            primary: Color(cColor.currentColorObs.value))));
  }

  AlertDialog showColorPicker(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: Color(cColor.pickerColorObs.value),
          onColorChanged: (Color color) => cColor.changeColor(color.value),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Got it'),
          onPressed: () {
            cColor.getColor();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Obx createTaskListButton(BuildContext context) {
    return Obx(() => FloatingActionButton.extended(
          onPressed: () {
            final item = Tasks(
                name: myController.text,
                tasks: [],
                status: false,
                color: cColor.currentColorObs.value);
            item.save(_db);
            cTasks.taskListsObx.add(item);
            goBack(context);
          },
          label:
              const Text('Create Task', style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Color(cColor.currentColorObs.value),
        ));
  }
}
