import 'package:dio/dio.dart';
import 'package:to_do_app/model/task_model.dart';

class TaskService {
  final dio = Dio();
  Future<TaskResponse> fetchTasks({required String status, required int limit, required int offset}) async {
    final response = await dio.get("https://todo-list-api-mfchjooefq-as.a.run.app/todo-list?", queryParameters: {
      "offset": 0,
      "limit": 10,
      "sortBy": "createdAt",
      "isAsc": true,
      "status": status,
    });

    TaskResponse taskResponse = TaskResponse.fromJson(response.data);
    return taskResponse;
  }
}
