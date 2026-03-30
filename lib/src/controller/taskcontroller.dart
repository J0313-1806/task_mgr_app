import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mgr_app/src/api/apiservice.dart';
import 'package:task_mgr_app/src/model/taskmodel.dart';

class Taskcontroller extends GetxController {
  RxBool gettingTaskLoader = false.obs;
  RxBool taskAddLoader = false.obs;
  RxBool taskUpdateLoader = false.obs;
  RxBool taskDeleteLoader = false.obs;
  RxBool searchButtonTap = false.obs;
  RxBool showDateFilter = false.obs;
  RxList<TaskModel> tasks = <TaskModel>[].obs;
  RxString selectedStatus = "".obs;
  RxString selectedDate = "".obs;
  RxString selecteBlockBy = "".obs;
  RxString filterSelected = "Title".obs;
  RxString searchParam = "".obs;
  RxString searchQuery = "".obs;
  RxString searchDateQuery = "Pick Date".obs;
  RxString titleField = ''.obs;
  RxString descriptionField = ''.obs;
  RxString dateField = ''.obs;
  RxString blockedByField = ''.obs;
  RxList<int> tileSelected = <int>[].obs;
  List<String> statusForApi = ['Done', 'In Progress', 'To-Do'];

  void changedStatus(String value) {
    selectedStatus(value);
  }

  void selectTasks(int id) {
    if (tileSelected.contains(id)) {
      tileSelected.remove(id);
    } else {
      tileSelected.add(id);
    }
  }

  void onSearchTapped() {
    if (searchButtonTap.isTrue) {
      getTasks();
    }
    filterSelected('Title');
    searchDateQuery('Pick Date');
    showDateFilter(false);
    searchButtonTap.toggle();
  }

  void dropFilter(String? value) {
    if (value != null) {
      if (value.contains("Date")) {
        showDateFilter(value.contains('Date'));
      } else {
        showDateFilter(false);
      }
      filterSelected(value);
      getTasks();
    }
  }

  void onDateQuery(String value) {
    searchDateQuery(value);
    searchTasks('due_date=$value');
  }

  void getTasks() async {
    gettingTaskLoader(true);
    // tasks.clear();

    final result = await Apiservice.getTasks();
    if (result != null) {
      tasks(result);
      gettingTaskLoader(false);
    }
    gettingTaskLoader(false);
  }

  void getTasksByStatus(int index) async {
    gettingTaskLoader(true);
    // tasks.clear();
    String status = statusForApi[index - 1];
    final result = await Apiservice.getTasksByStatus(status);
    if (result != null) {
      tasks(result);
      gettingTaskLoader(false);
    }
    gettingTaskLoader(false);
  }

  void searchTasks(String query) async {
    gettingTaskLoader(true);
    // tasks.clear();

    final result = await Apiservice.getTasksBySearch(query);
    if (result != null) {
      tasks(result);
      gettingTaskLoader(false);
    }
    gettingTaskLoader(false);
  }

  void addTask(
    String title,
    String description,
    String status,
    String date,
    int? blockedById,
  ) async {
    taskAddLoader(true);
    final taskModelData = TaskModelSend(
      title: title,
      description: description,
      dueDate: date,
      status: status,
      blockedById: blockedById,
      position: null,
    );

    final result = await Apiservice.addTask(taskModelData);

    if (result != null) {
      if (result == 'success') {
        taskAddLoader(false);
        Get.back();
        getTasks();
        Get.snackbar(
          "Successfully Added.",
          "if Task isnt showing pull down to refresh",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        titleField('');
        selectedStatus('');
        descriptionField('');
        dateField('');
        blockedByField('');
      } else {
        taskAddLoader(false);
        Get.snackbar(
          "Adding failed.",
          "$result\nPlease try again.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } else {
      taskAddLoader(false);
      Get.snackbar(
        "Adding failed.",
        "$result\nPlease try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
    taskAddLoader(false);

    print(result);
  }

  String dateToString(DateTime value) {
    String convertedDate = value.toLocal().toString().substring(0, 10);
    return convertedDate;
  }

  DateTime stringToDate(String? value) {
    if (value != null && value.isNotEmpty) {
      return DateTime.tryParse(value)!;
    } else {
      return DateTime.now();
    }
  }

  void updateTask(
    int? id,
    String title,
    String description,
    String status,
    String date,
    int? position,
    int? blockedById,
  ) async {
    taskUpdateLoader(true);

    final taskModelData = TaskModelSend(
      title: title,
      description: description,
      dueDate: date,
      status: status,
      blockedById: blockedById,
      position: position,
    );

    final result = await Apiservice.updateTask(taskModelData, id!);

    if (result != null) {
      if (result == 'success') {
        taskUpdateLoader(false);
        Get.back();
        getTasks();
        Get.snackbar(
          "Successfully updated.",
          "if update isnt showing pull down to refresh",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        taskUpdateLoader(false);
        Get.snackbar(
          "Update failed.",
          "$result\nPlease try again.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } else {
      taskUpdateLoader(false);
      Get.snackbar(
        "Update failed.",
        "$result\nPlease try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
    taskUpdateLoader(false);
  }

  void deleteTask(int id) async {
    taskDeleteLoader(true);

    final result = await Apiservice.deleteTask(id);

    if (result != null) {
      if (result.contains('success')) {
        taskDeleteLoader(false);
        Get.back();
        getTasks();
        Get.snackbar(
          "Successfully deleted.",
          "if no changes is showing pull down to refresh",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        taskDeleteLoader(false);
        Get.snackbar(
          "Deletion failed.",
          "$result\nPlease try again.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } else {
      taskDeleteLoader(false);
      Get.snackbar(
        "Deletion failed.",
        "$result\nPlease try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
    taskDeleteLoader(false);
  }

  void bulkDeleteTask(List<int> id) async {
    taskDeleteLoader(true);

    final result = await Apiservice.bulkDeleteTask(id);

    if (result != null) {
      if (result.contains('success')) {
        tileSelected.clear();
        taskDeleteLoader(false);
        Get.back();
        getTasks();
        Get.snackbar(
          "Successfully deleted.",
          result,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        taskDeleteLoader(false);
        Get.snackbar(
          "Deletion failed.",
          "$result\nPlease try again.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } else {
      taskDeleteLoader(false);
      Get.snackbar(
        "Deletion failed.",
        "$result\nPlease try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
    taskDeleteLoader(false);
  }

  void movingTask(int id, int oldIndex, int newIndex) async {
    //int id, int newIndexList<Map<String, int?>> reorderedList
    // taskDeleteLoader(true);

    final result = await Apiservice.moveTask(id, newIndex);

    if (result != null) {
      if (result.contains('success')) {
        final task = tasks.removeAt(oldIndex);
        tasks.insert(newIndex, task);
        // tileSelected.clear();
        // taskDeleteLoader(false);
        // Get.back();
        // getTasks();
        // Get.snackbar(
        //   "Successfully deleted.",
        //   result,
        //   backgroundColor: Colors.redAccent,
        //   colorText: Colors.white,
        // );
      } else {
        // taskDeleteLoader(false);
        // Get.snackbar(
        //   "Deletion failed.",
        //   "$result\nPlease try again.",
        //   backgroundColor: Colors.redAccent,
        //   colorText: Colors.white,
        // );
      }
    } else {
      // taskDeleteLoader(false);
      // Get.snackbar(
      //   "Deletion failed.",
      //   "$result\nPlease try again.",
      //   backgroundColor: Colors.redAccent,
      //   colorText: Colors.white,
      // );
    }
    // taskDeleteLoader(false);
  }

  @override
  void onInit() {
    super.onInit();

    getTasks();
  }
}
