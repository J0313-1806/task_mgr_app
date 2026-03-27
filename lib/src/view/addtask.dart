import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mgr_app/src/controller/taskcontroller.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  static final Taskcontroller taskController = Get.put(Taskcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task'),),
      body: ListView(
        children: <Widget> [
          TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: taskController.selectedStatus.value.isEmpty
                          ? null
                          : taskController.selectedStatus.value,
                      decoration: InputDecoration(
                        labelText: "Status",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      items: const [
                        // DropdownMenuItem(value: "", child: Text("Status")),
                        DropdownMenuItem(value: "To-Do", child: Text("To-Do")),
                        DropdownMenuItem(
                          value: "In Progress",
                          child: Text("In Progress"),
                        ),
                        DropdownMenuItem(value: "Done", child: Text("Done")),
                      ],
                      onChanged: (value) {
                        // taskController.changedStatus(value ?? '');
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: TextEditingController(
                        // text: taskController.selectedDate.value,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Select Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: Get.context!,
                          initialDate: taskController.stringToDate(
                            taskController.selectedDate.value,
                          ),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          // taskController.selectedDate.value = taskController
                          //     .dateToString(picked);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'blocked by',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}