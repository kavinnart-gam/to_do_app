import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/view_model/todo_list_provider.dart';
import 'package:to_do_app/views/passcode_lock_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> with WidgetsBindingObserver {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Timer? _timer;
  int timerDuration = 1000;
  ValueNotifier<int> dialogTrigger = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTimer();
    super.dispose();
  }

  void setExpire() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("isExpire", false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive) {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: timerDuration), (timer) {
      // when user is inactive for 10 seconds navigate to passcode screen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PasscodeLockScreen(),
          ));
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _handleUserInteraction() {
    _stopTimer();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoListProvider>(context, listen: false);
    return Listener(
      onPointerDown: (e) {
        _handleUserInteraction();
      },
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(body: Consumer<TodoListProvider>(builder: (context, provider, _) {
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.purple.withOpacity(0.25)),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.27,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi! User",
                              style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 20.0),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "This is just a sample UI.",
                              style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 16.0),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.24,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.5), color: const Color(0xFFEDF2F7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: provider.currentStatus == "TODO" ? Colors.purple.withOpacity(0.1) : Colors.transparent),
                              child: InkWell(
                                onTap: () async {
                                  todoProvider.clearOffset();
                                  todoProvider.setCurrentStatus("TODO");
                                  todoProvider.clearTask();
                                  await todoProvider.fetchTasks(loadMore: false);
                                },
                                child: Text(
                                  "To-do",
                                  style: TextStyle(
                                    color: provider.currentStatus == "TODO" ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: provider.currentStatus == "DOING" ? Colors.purple.withOpacity(0.1) : Colors.transparent),
                              child: InkWell(
                                onTap: () async {
                                  todoProvider.clearOffset();
                                  todoProvider.setCurrentStatus("DOING");
                                  todoProvider.clearTask();
                                  await todoProvider.fetchTasks(loadMore: false);
                                },
                                child: Text(
                                  "Doing",
                                  style: TextStyle(
                                    color: provider.currentStatus == "DOING" ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: provider.currentStatus == "DONE" ? Colors.purple.withOpacity(0.1) : Colors.transparent),
                              child: InkWell(
                                onTap: () async {
                                  todoProvider.clearOffset();
                                  todoProvider.setCurrentStatus("DONE");
                                  todoProvider.clearTask();
                                  await todoProvider.fetchTasks(loadMore: false);
                                },
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                    color: provider.currentStatus == "DONE" ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // If the API returns an error message, show an alert dialog
              provider.errMessage.isNotEmpty
                  ? Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: dialogTrigger,
                        builder: (ctx, value, child) {
                          Future.delayed(
                            const Duration(seconds: 0),
                            () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(provider.errMessage.first),
                                    content: Text(provider.errMessage.last),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                          return const SizedBox();
                        },
                      ),
                    )
                  : Expanded(
                      child: SmartRefresher(
                        enablePullDown: false,
                        enablePullUp: true,
                        controller: provider.loadmoreController,
                        onLoading: () async {
                          await provider.fetchTasks(loadMore: true);
                        },
                        child: SlidableAutoCloseBehavior(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: provider.tasks.length,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              itemBuilder: (context, index) {
                                final headerDate = provider.getHeaderDate(index);
                                return Slidable(
                                  key: ValueKey(provider.tasks[index].id),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    extentRatio: 0.27,
                                    children: [
                                      SlidableAction(
                                        onPressed: (_) {
                                          provider.deleteTaskById(provider.tasks[index].id);
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        label: 'Delete \ntask',
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (headerDate.isNotEmpty) ...[
                                            SizedBox(
                                              height: index == 0 ? 0 : 15,
                                            ),
                                            Text(
                                              provider.getHeaderDate(index),
                                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.check_box,
                                                color: Colors.blue.withOpacity(0.5),
                                                size: 40,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      provider.tasks[index].title,
                                                      maxLines: 1, // Restrict the number of lines to 1
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                    ),
                                                    Text(
                                                      provider.tasks[index].description ?? '',
                                                      maxLines: 3, // Restrict the number of lines to 3
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Icon(
                                                Icons.more_vert,
                                                color: Colors.grey,
                                                size: 20.0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                );
                              }),
                        ),
                      ),
                    )
            ],
          );
        })),
      ),
    );
  }
}
