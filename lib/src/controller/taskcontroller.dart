import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_mgr_app/src/model/taskmodel.dart';

class Taskcontroller extends GetxController {
  RxList<TaskModel> tasks = <TaskModel>[].obs;
  RxString selectedStatus = "".obs;
  RxString selectedDate = "".obs;

  void changedStatus(String value) {
    selectedStatus(value);
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
}
