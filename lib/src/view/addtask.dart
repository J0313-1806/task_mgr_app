import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mgr_app/src/controller/taskcontroller.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  static final Taskcontroller taskController = Get.put(Taskcontroller());

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    // Controllers
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final blockedByController = TextEditingController();
    final dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Title is required' : null,
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
                DropdownMenuItem(value: "To-Do", child: Text("To-Do")),
                DropdownMenuItem(
                  value: "In Progress",
                  child: Text("In Progress"),
                ),
                DropdownMenuItem(value: "Done", child: Text("Done")),
              ],
              onChanged: (value) {
                taskController.selectedStatus.value = value ?? '';
              },
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a status'
                  : null,
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
                  ? 'Description is required'
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
                  value == null || value.isEmpty ? 'Date is required' : null,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  dateController.text = taskController.dateToString(picked);
                      // "${picked.day}-${picked.month}-${picked.year}";
                  // taskController.selectedDate.value = taskController
                  //     .dateToString(picked);
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

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // All fields valid, proceed with saving
                  taskController.addTask(
                    titleController.text,
                    descriptionController.text,
                    taskController.selectedStatus.value,
                    dateController.text,
                    int.tryParse(blockedByController.text),
                  );
                  // Get.back(); // close page after saving
                }
              },
              child: const Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}
