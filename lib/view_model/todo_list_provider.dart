import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/services/task_service.dart';

class TodoListProvider extends ChangeNotifier {
  List<Task> _tasks = <Task>[];
  List<Task> get tasks => _tasks;
  final int _limit = 20;
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
    'MAR',
    'APR',
    'MAY',
    'JuN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  Future<void> fetchTasks({bool loadMore = false}) async {
    // when user swipe to loadmore data but page number == totalpage set loadmoreController to no data
    if (loadMore && _offset == _totalPages) {
      // No more pages to load
      loadmoreController.loadNoData();
      notifyListeners();
      return;
    }

    try {
      TaskResponse newTasks = await TaskService().fetchTasks(status: currentStatus, limit: limit, offset: offset);
      if (loadMore) {
        _tasks.addAll(newTasks.tasks!);
      } else {
        _tasks = newTasks.tasks!;
      }
      _offset = newTasks.pageNumber;
      _totalPages = newTasks.totalPages;
      loadmoreController.loadComplete();
    } catch (error) {
      if (error is List) {
        _errMessage = [error[0], error[1]];
      }
      loadmoreController.loadFailed();
    } finally {
      notifyListeners();
    }
  }

  String getHeaderDate(int currentIndex) {
    String formattedDate = "";

    if (currentIndex == 0) {
      // if first index display group of date
      DateTime parsedDate = DateTime.parse(_tasks[currentIndex].createdAt);
      int month = parsedDate.month;
      int day = parsedDate.day;
      int year = parsedDate.year;
      return '$day ${monthNames[month - 1]} $year';
    } else {
      // check current date and date of the previous index is not equal, display group of date
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
    // when click new tab set offset to 0
    _offset = 0;
    notifyListeners();
  }

  setCurrentStatus(String newStatus) {
    // set current status when click tab
    _currentStatus = newStatus;
    notifyListeners();
  }

  clearTask() {
    // when change tab clear old task list
    _tasks.clear();
    notifyListeners();
  }

  deleteTaskById(String taskId) {
    // remove task by id
    tasks.removeWhere((element) => element.id == taskId);
    notifyListeners();
  }
}
