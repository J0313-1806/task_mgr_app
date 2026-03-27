import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mgr_app/src/controller/taskcontroller.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, required this.taskController});

  final Taskcontroller taskController;
  static String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Obx(
        () => ListTile(
          leading: IconButton(
            onPressed: () {
              taskController.onSearchTapped();
            },
            icon: Icon(Icons.arrow_back_ios_sharp),
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Search..',
            ),
            onChanged: (value) {
              switch (taskController.filterSelected.value) {
                case 'Title':
                  taskController.searchTasks("title=$value");
                  break;
                case 'Description':
                  taskController.searchTasks("description=$value");
                  break;
                case 'Date':
                  taskController.searchTasks(
                    "title=$value&due_date=${taskController.searchDateQuery}",
                  );
                  break;
                default:
                  taskController.searchTasks("title=$value");
              }
            },
          ),
          subtitle: Row(
            children: [
              DropdownButton<String>(
                hint: const Text("Select"),
                value: taskController.filterSelected.value,
                items: ["Title", "Description", "Date"]
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  taskController.dropFilter(value);
                },
              ),
              const SizedBox(width: 20),
              if (taskController.showDateFilter.value)
                TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      taskController.onDateQuery(
                        taskController.dateToString(picked),
                      );
                    }
                  },
                  child: Text(taskController.searchDateQuery.value),
                ),
            ],
          ),
        ),
        // actions: [Text(
        //   onPressed: () {
        //     taskController.searchTasks(param, query)
        //   },
        //   icon: Icon(Icons.arrow_forward_outlined),),],
      ),
    );
  }
}
