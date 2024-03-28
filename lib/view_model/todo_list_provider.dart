import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/services/task_service.dart';

class TodoListProvider extends ChangeNotifier {
  List<Task> _tasks = <Task>[];
  // int _currentPage = 1;
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  int _limit = 20;
  int get limit => _limit;
  int _offset = 0;
  int get offset => _offset;
  String _currentStatus = "TODO";
  String get currentStatus => _currentStatus;
  bool isExpired = false;
  List<String> _errMessage = [];
  List<String> get errMessage => _errMessage;
  int _totalPages = 0;

  RefreshController loadmoreController = RefreshController(initialRefresh: false);

  static List<String> monthNames = [
    'JAN',
    'FEB',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  Future<void> fetchTasks({bool loadMore = false}) async {
    if (loadMore && _offset == _totalPages) {
      // No more pages to load
      loadmoreController.loadNoData();
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      TaskResponse newTasks = await TaskService().fetchTasks(status: currentStatus, limit: limit, offset: offset);
      if (loadMore) {
        _tasks.addAll(newTasks.tasks!);
      } else {
        _tasks = newTasks.tasks!;
      }
      print("____tasks size ${_tasks.length}");
      _offset = newTasks.pageNumber;
      _totalPages = newTasks.totalPages;
      loadmoreController.loadComplete();
      //_currentPage++;
    } catch (error) {
      if (error is List) {
        _errMessage = [error[0], error[1]];
      }

      loadmoreController.loadFailed();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getHeaderDate(int currentIndex) {
    String formattedDate = "";

    if (currentIndex == 0) {
      DateTime parsedDate = DateTime.parse(_tasks[currentIndex].createdAt);
      int month = parsedDate.month;
      int day = parsedDate.day;
      int year = parsedDate.year;
      return '$day ${monthNames[month - 1]} $year';
    } else {
      DateTime parsedDate = DateTime.parse(_tasks[currentIndex].createdAt);
      String currMonth = '${parsedDate.day} ${monthNames[parsedDate.month - 1]} ${parsedDate.year}';
      DateTime parsedDate2 = DateTime.parse(_tasks[currentIndex - 1].createdAt);
      int month2 = parsedDate2.month;
      String currMonth2 = '${parsedDate2.day} ${monthNames[month2 - 1]} ${parsedDate2.year}';
      if (currMonth != currMonth2) {
        return currMonth;
      }
    }
    return formattedDate;
  }

  clearOffset() {
    _offset = 0;
    notifyListeners();
  }

  setCurrentStatus(String newStatus) {
    _currentStatus = newStatus;
    notifyListeners();
  }

  clearTask() {
    _tasks.clear();
    notifyListeners();
  }

  deleteTaskById(String taskId) {
    // remove task by id
    tasks.removeWhere((element) => element.id == taskId);
    notifyListeners();
  }

  // String getDate(String date) {
  //   String formattedDate = "";
  //   // if (dateHeader.isEmpty) {
  //   DateTime parsedDate = DateTime.parse(date);
  //   int month = parsedDate.month;
  //   int day = parsedDate.day;
  //   int year = parsedDate.year;
  //   formattedDate = '$day ${monthNames[month - 1]} $year';
  //   //formattedDate = DateFormat('dd MM yyyy').format(DateTime.parse("2023-03-24T19:30:00Z"));
  //   //}
  //   //_tasks[index].createdAt = formattedDate;
  //   // createdAtString
  //   return formattedDate;
  // }
}
