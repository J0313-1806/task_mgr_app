import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mgr_app/src/controller/taskcontroller.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

  static final List<String> statusList = ["To-Do", "In Progress", "Done"];
  static final taskController = Get.put(Taskcontroller());

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.all( 5),
      child: InkWell(
        onTap: () {
          showTask();
        },
        child: ListTile(
          // enabled: false,
          tileColor: Colors.green.shade100,
          isThreeLine: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text('Task 1'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text('Due: 2024-06-30'),
              const SizedBox(height: 10),
              Text('Done', style: TextStyle(color: Colors.green)),
              const SizedBox(height: 10),
              Text('Description of Task 1'),
              const SizedBox(height: 100),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('Blocked by ..'),
              ),
            ],
          ),
          // trailing: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.green,
          //           shape: BoxShape.circle,
          //         ),
          //         child: Icon(Icons.done, color: Colors.white,),
          //       ),
        ),
      ),
    );
  }

  void showTask() async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 2.0,
              right: 2.0,
              top: 2.0,
              bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
            ),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(12),
                // margin: EdgeInsets.only(bottom: 2.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
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
                        taskController.changedStatus(value ?? '');
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
                        text: taskController.selectedDate.value,
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
                          taskController.selectedDate.value = taskController
                              .dateToString(picked);
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
