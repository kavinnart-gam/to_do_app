import 'package:dio/dio.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/utils/api_exception.dart';

class TaskService {
  final dio = Dio();
  TaskService({Dio? dio});
  Future<TaskResponse> fetchTasks({required String status, required int limit, required int offset}) async {
    try {
      final response = await dio.get("https://todo-list-api-mfchjooefq-as.a.run.app/todo-list?", queryParameters: {
        "offset": offset,
        "limit": limit,
        "sortBy": "createdAt",
        "isAsc": true,
        "status": status,
      });
      TaskResponse taskResponse = TaskResponse.fromJson(response.data);
      return taskResponse;
    } on DioException catch (e) {
      throw ApiException().getExceptionMessage(e); // Re-throw the message from ApiException
    }
  }
}
