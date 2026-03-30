// To parse this JSON data, do
//
//     final taskModelAdd = taskModelFromJson(jsonString);

import 'dart:convert';

List<TaskModel> taskModelFromJson(String str) =>
    List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

// String taskModelToJson(List<TaskModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
String bulkDeleteToJson(List<int> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
// TaskModel taskModelAddFromJson(String str) =>
//     TaskModel.fromJson(json.decode(str));
// String taskModelAddToJson(TaskModel data) => json.encode(data.toJson());
String taskModelSendToJson(TaskModelSend data) => json.encode(data.toJson());

ReorderListModel reorderListModelFromJson(String str) =>
    ReorderListModel.fromJson(json.decode(str));

String reorderListModelToJson(ReorderListModel data) =>
    json.encode(data.toJson());

class TaskModel {
  final String title;
  final String description;
  final String dueDate;
  final String status;
  final int? blockedById;
  final int? position;
  final int? id;

  TaskModel({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.blockedById,
    required this.position,
    this.id,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    title: json["title"],
    description: json["description"],
    dueDate: json["due_date"],
    status: json["status"],
    blockedById: json["blocked_by_id"],
    position: json["position"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "due_date": dueDate,
    "status": status,
    "blocked_by_id": blockedById,
    "position": position,
    "id": id,
  };
}

// List<TaskModelAdd> taskModelAddFromJson(String str) => List<TaskModelAdd>.from(json.decode(str).map((x) => TaskModelAdd.fromJson(x)));

class TaskModelSend {
  final String title;
  final String description;
  final String dueDate;
  final String status;
  final int? blockedById;
  final int? position;

  TaskModelSend({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.blockedById,
    required this.position,
  });

  factory TaskModelSend.fromJson(Map<String, dynamic> json) => TaskModelSend(
    title: json["title"],
    description: json["description"],
    dueDate: json["due_date"],
    status: json["status"],
    blockedById: json["blocked_by_id"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "due_date": dueDate,
    "status": status,
    "blocked_by_id": blockedById,
    "position": position,
  };
}

class ReorderListModel {
  final List<Task> tasks;

  ReorderListModel({required this.tasks});

  factory ReorderListModel.fromJson(Map<String, dynamic> json) =>
      ReorderListModel(
        tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
  };
}

class Task {
  final int id;
  final int position;

  Task({required this.id, required this.position});

  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(id: json["id"], position: json["position"]);

  Map<String, dynamic> toJson() => {"id": id, "position": position};
}
