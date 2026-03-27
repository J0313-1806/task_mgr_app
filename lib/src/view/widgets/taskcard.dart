import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mgr_app/src/controller/taskcontroller.dart';
import 'package:task_mgr_app/src/model/taskmodel.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.taskController, required this.task});

  final Taskcontroller taskController;

  final TaskModel task;

  static final List<String> statusList = ["To-Do", "In Progress", "Done"];

  static Color taskColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    switch (task.status) {
      case 'To-Do':
        taskColor = Colors.orangeAccent;
        break;
      case 'In Progress':
        taskColor = Colors.pinkAccent;
        break;
      case 'Done':
        taskColor = Colors.green;
        break;
      default:
    }

    return Card(
      // margin: EdgeInsets.all( 5),
      child: Obx(
        () => InkWell(
          onTap: () {
            if (taskController.tileSelected.isNotEmpty) {
              taskController.selectTasks(task.id!);
            } else {
              showTask();
            }
          },
          onLongPress: () {
            taskController.selectTasks(task.id!);
          },
          child: ListTile(
            // enabled: false,
            tileColor: taskColor,
            isThreeLine: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: taskController.tileSelected.contains(task.id!)
                  ? BorderSide(color: Colors.blue, width: 2.5)
                  : BorderSide.none,
            ),

            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(task.dueDate),
                const SizedBox(height: 10),
                Text(task.status, style: TextStyle()),
                const SizedBox(height: 10),
                Text(task.description),
                const SizedBox(height: 100),
                task.blockedById == null
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Blocked by ..',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showTask() async {
    final _formKey = GlobalKey<FormState>();

    // Controllers for each field
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    final dateController = TextEditingController(text: task.dueDate);
    final blockedByController = TextEditingController(
      text: task.blockedById?.toString() ?? '',
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 12.0,
              bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Title required'
                        : null,
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    initialValue: task.status.isNotEmpty
                        ? task.status
                        : taskController.selectedStatus.value.isEmpty
                        ? null
                        : taskController.selectedStatus.value,
                    decoration: InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "To-Do", child: Text("To-Do")),
                      DropdownMenuItem(
                        value: "In Progress",
                        child: Text("In Progress"),
                      ),
                      DropdownMenuItem(value: "Done", child: Text("Done")),
                    ],
                    onChanged: (value) {
                      taskController.changedStatus(value ?? task.status);
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Select status' : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Description required'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Date required' : null,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: Get.context!,
                        initialDate: task.dueDate.isNotEmpty
                            ? taskController.stringToDate(task.dueDate)
                            : taskController.stringToDate(
                                taskController.selectedDate.value,
                              ),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        dateController.text =
                            "${picked.day}-${picked.month}-${picked.year}";
                        taskController.selectedDate.value = taskController
                            .dateToString(picked);
                      } else {
                        dateController.text = task.dueDate;
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: blockedByController,
                    decoration: InputDecoration(
                      hintText: 'Blocked by',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            taskController.deleteTask(task.id!);
                            Get.back(); // close dialog
                          },
                          icon: taskController.taskDeleteLoader.isTrue
                              ? const CircularProgressIndicator.adaptive()
                              : Icon(Icons.delete, color: Colors.red),
                          label: taskController.taskUpdateLoader.isTrue
                              ? CircularProgressIndicator.adaptive()
                              : const Text("Delete"),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Save logic here
                              taskController.updateTask(
                                task.id,
                                titleController.text,
                                descriptionController.text,
                                taskController.selectedStatus.value,
                                dateController.text.isEmpty
                                    ? task.dueDate
                                    : dateController.text,
                                task.position,
                                int.tryParse(blockedByController.text),
                              );
                              Get.back(); // close dialog
                            }
                          },
                          icon: Icon(Icons.save_alt),
                          label: taskController.taskUpdateLoader.isTrue
                              ? CircularProgressIndicator.adaptive()
                              : const Text("Save"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void showTask() async {
  //   Get.dialog(
  //     Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       child: SingleChildScrollView(
  //         child: Padding(
  //           padding: EdgeInsets.only(
  //             left: 2.0,
  //             right: 2.0,
  //             top: 2.0,
  //             bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
  //           ),
  //           child: Card(
  //             child: Container(
  //               padding: EdgeInsets.all(12),
  //               // margin: EdgeInsets.only(bottom: 2.0),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Column(
  //                 children: [
  //                   TextFormField(
  //                     decoration: InputDecoration(
  //                       hintText: 'Title',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(6.0),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   DropdownButtonFormField<String>(
  //                     initialValue: taskController.selectedStatus.value.isEmpty
  //                         ? null
  //                         : taskController.selectedStatus.value,
  //                     decoration: InputDecoration(
  //                       labelText: "Status",
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(6.0),
  //                       ),
  //                     ),
  //                     items: const [
  //                       // DropdownMenuItem(value: "", child: Text("Status")),
  //                       DropdownMenuItem(value: "To-Do", child: Text("To-Do")),
  //                       DropdownMenuItem(
  //                         value: "In Progress",
  //                         child: Text("In Progress"),
  //                       ),
  //                       DropdownMenuItem(value: "Done", child: Text("Done")),
  //                     ],
  //                     onChanged: (value) {
  //                       taskController.changedStatus(value ?? '');
  //                     },
  //                   ),
  //                   const SizedBox(height: 10),
  //                   TextFormField(
  //                     decoration: InputDecoration(
  //                       hintText: 'Description',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(6.0),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   TextFormField(
  //                     controller: TextEditingController(
  //                       text: taskController.selectedDate.value,
  //                     ),
  //                     decoration: InputDecoration(
  //                       hintText: 'Select Date',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(6.0),
  //                       ),
  //                     ),
  //                     onTap: () async {
  //                       final DateTime? picked = await showDatePicker(
  //                         context: Get.context!,
  //                         initialDate: taskController.stringToDate(
  //                           taskController.selectedDate.value,
  //                         ),
  //                         firstDate: DateTime(2000),
  //                         lastDate: DateTime(2100),
  //                       );
  //                       if (picked != null) {
  //                         taskController.selectedDate.value = taskController
  //                             .dateToString(picked);
  //                       }
  //                     },
  //                   ),
  //                   const SizedBox(height: 20),
  //                   TextFormField(
  //                     decoration: InputDecoration(
  //                       hintText: 'blocked by',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(6.0),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
