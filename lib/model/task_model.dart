class TaskResponse {
  int totalPages;
  int pageNumber;
  List<Task>? tasks;
  TaskResponse({this.tasks, required this.totalPages, required this.pageNumber});

  factory TaskResponse.fromJson(Map<String, dynamic> json) => TaskResponse(
        tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
        pageNumber: json["pageNumber"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "tasks": List<dynamic>.from(tasks!.map((x) => x.toJson())),
        "pageNumber": pageNumber,
        "totalPages": totalPages,
      };
}

class Task {
  String id;
  String title;
  String? description;
  String createdAt;
  String status;
  String? createdAtString;

  Task({required this.id, required this.title, this.description, required this.createdAt, required this.status, this.createdAtString});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        description: json['description'] as String?,
        createdAt: json["createdAt"],
        status: json['status'] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "createdAt": createdAt,
        "status": status,
      };
}
