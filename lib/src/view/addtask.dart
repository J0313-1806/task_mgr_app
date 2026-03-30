import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mgr_app/src/controller/taskcontroller.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  static final Taskcontroller taskController = Get.find();

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    blockedByController.dispose();
    dateController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final titleController = TextEditingController(
    text: AddTask.taskController.titleField.value,
  );
  final descriptionController = TextEditingController(
    text: AddTask.taskController.descriptionField.value,
  );
  final blockedByController = TextEditingController(
    text: AddTask.taskController.blockedByField.value,
  );
  final dateController = TextEditingController(
    text: AddTask.taskController.dateField.value,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        actions: [
          IconButton(
            onPressed: () {
              AddTask.taskController.titleField('');
              AddTask.taskController.descriptionField('');
              AddTask.taskController.blockedByField('');
              AddTask.taskController.dateField('');
              titleController.clear();
              descriptionController.clear();
              dateController.clear();
              blockedByController.clear();
              AddTask.taskController.selectedStatus('');
            },
            icon: Icon(Icons.delete_outline),
          ),
        ],
      ),
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
              onChanged: (value) {
                AddTask.taskController.titleField(value);
              },
            ),
            const SizedBox(height: 10),

            Obx(
              () => DropdownButtonFormField<String>(
                initialValue:
                    AddTask.taskController.selectedStatus.value.isEmpty
                    ? null
                    : AddTask.taskController.selectedStatus.value,
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
                  AddTask.taskController.selectedStatus.value = value ?? '';
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a status'
                    : null,
              ),
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
              onChanged: (value) {
                AddTask.taskController.descriptionField(value);
              },
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
                  dateController.text = AddTask.taskController.dateToString(
                    picked,
                  );

                  AddTask.taskController.dateField.value = AddTask
                      .taskController
                      .dateToString(picked);
                }
              },
            ),
            const SizedBox(height: 20),

            Obx(
              () => DropdownButtonFormField<String>(
                initialValue: null,
                decoration: InputDecoration(
                  labelText: "Blocked by",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                items: AddTask.taskController.tasks.isNotEmpty
                    ? AddTask.taskController.tasks
                          .map(
                            (f) => DropdownMenuItem(
                              value: f.id.toString(),
                              child: Text(f.title.toString()),
                            ),
                          )
                          .toList()
                    : [
                        DropdownMenuItem(
                          value: "No data",
                          child: Text("No data"),
                        ),
                      ],
                onChanged: (value) {
                  blockedByController.text = value ?? '';
                  AddTask.taskController.blockedByField(value);
                },
                // validator: (value) => value == null || value.isEmpty
                //     ? 'Please select a blocked by'
                //     : null,
              ),
            ),
            // TextFormField(
            //   controller: blockedByController,
            //   decoration: InputDecoration(
            //     hintText: 'Blocked by',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(6.0),
            //     ),
            //   ),
            //   onChanged: (value) {
            //     AddTask.taskController.blockedByField(value);
            //   },
            // ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  AddTask.taskController.addTask(
                    titleController.text,
                    descriptionController.text,
                    AddTask.taskController.selectedStatus.value,
                    dateController.text,
                    int.tryParse(blockedByController.text),
                  );
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
