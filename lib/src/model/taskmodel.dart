// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

List<TaskModel> taskModelFromJson(String str) => List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

String taskModelToJson(List<TaskModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskModel {
    final String title;
    final String description;
    final DateTime dueDate;
    final String status;
    final int? blockedById;
    final int position;
    final int id;

    TaskModel({
        required this.title,
        required this.description,
        required this.dueDate,
        required this.status,
        required this.blockedById,
        required this.position,
        required this.id,
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
        "due_date": "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}",
        "status": status,
        "blocked_by_id": blockedById,
        "position": position,
        "id": id,
    };
}
