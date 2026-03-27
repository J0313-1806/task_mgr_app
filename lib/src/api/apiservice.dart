import 'dart:convert';

import 'package:task_mgr_app/src/model/taskmodel.dart';
import 'package:http/http.dart' as http;

class Apiservice {
  // static const String baseUrl = "http://10.0.2.2:8000";

  static const String emulatorBaseUrl = "http://10.0.2.2:8000";
  static const String wifiBaseUrl = "http://192.168.1.8:8000";

  static String get baseUrl {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return wifiBaseUrl;
    } else {
      return emulatorBaseUrl;
    }
  }

  static Future<List<TaskModel>?> getTasks() async {
    try {
      final url = Uri.parse('$baseUrl/tasks');

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final result = taskModelFromJson(response.body);

        return result;
      } else {
        print("Registration failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }

  static Future<List<TaskModel>?> getTasksByStatus(String status) async {
    try {
      final url = Uri.parse('$baseUrl/tasks/tasks/filter?status=$status');

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final result = taskModelFromJson(response.body);

        return result;
      } else {
        print(
          "Fetch by status failed with status code: ${response.statusCode}",
        );
        return null;
      }
    } catch (e) {
      print("Error during Fetch by status: $e");
      return null;
    }
  }

  static Future<String?> addTask(TaskModelSend model) async {
    try {
      final url = Uri.parse('$baseUrl/tasks/add');

      print(taskModelSendToJson(model));

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: taskModelSendToJson(model),
      );

      if (response.statusCode == 201) {
        final result = TaskModel.fromJson(jsonDecode(response.body));

        if (result.id != null) {
          return 'success';
        }
        return 'Error in the model';
      } else {
        print("Adding failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error during adding: $e");
      return null;
    }
  }

  static Future<String?> updateTask(TaskModelSend model, int id) async {
    try {
      final url = Uri.parse('$baseUrl/tasks/$id');

      print(taskModelSendToJson(model));

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: taskModelSendToJson(model),
      );

      if (response.statusCode == 200) {
        final result = TaskModel.fromJson(jsonDecode(response.body));

        if (result.id != null) {
          return 'success';
        }
        return 'Error in the model';
      } else {
        print("Update failed with status code: ${response.statusCode}");
        return 'Update failed with status code: ${response.statusCode}';
      }
    } catch (e) {
      print("Error during update: $e");
      return "Error during update: $e";
    }
  }

  static Future<String?> deleteTask(int id) async {
    try {
      final url = Uri.parse('$baseUrl/tasks/delete/$id');

      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result['message'].contains('success')) {
          return 'success';
        }
        return 'Error in the model';
      } else {
        print("Deletion failed with status code: ${response.statusCode}");
        return 'Deletion failed with status code: ${response.statusCode}';
      }
    } catch (e) {
      print("Error during Deletion: $e");
      return "Error during Deletion: $e";
    }
  }

  static Future<String?> bulkDeleteTask(List<int> ids) async {
    try {
      final url = Uri.parse('$baseUrl/tasks/bulk');

      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: bulkDeleteToJson(ids),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result['message'].contains('success')) {
          return result['message'];
        }
        return 'Error in the model';
      } else {
        print("Bulk Deletion failed with status code: ${response.statusCode}");
        return 'Bulk Deletion failed with status code: ${response.statusCode}';
      }
    } catch (e) {
      print("Error during Bulk Deletion: $e");
      return "Error during Bulk Deletion: $e";
    }
  }
}
