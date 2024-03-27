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
  int timerDuration = 10;

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
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                // color: Colors.black.withOpacity(0.25),
                height: MediaQuery.of(context).size.height * 0.3,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.purple.withOpacity(0.25)),
                      //color: Colors.purple.withOpacity(0.25),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.24,
                      // child: Center(
                      //   child: Text(
                      //     "Home",
                      //     style: TextStyle(color: Colors.white, fontSize: 18.0),
                      //   ),
                      // ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.21,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        //padding: EdgeInsets.symmetric(horizontal: 20.0),
                        //height: 50,
                        //width: 300,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.5), color: const Color(0xFFEDF2F7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  todoProvider.setLimitOffset(limit: 10, offset: 0);
                                  todoProvider.setCurrentStatus("TODO");
                                  todoProvider.clearTask();
                                  await todoProvider.fetchTasks(loadMore: false);
                                },
                                child: const Text("To-do")),
                            ElevatedButton(
                                onPressed: () async {
                                  todoProvider.setLimitOffset(limit: 10, offset: 0);
                                  todoProvider.setCurrentStatus("DOING");
                                  todoProvider.clearTask();
                                  await todoProvider.fetchTasks(loadMore: false);
                                },
                                child: const Text("Doing")),
                            ElevatedButton(
                                onPressed: () async {
                                  todoProvider.setLimitOffset(limit: 10, offset: 0);
                                  todoProvider.setCurrentStatus("DONE");
                                  todoProvider.clearTask();
                                  await todoProvider.fetchTasks(loadMore: false);
                                },
                                child: const Text("Done"))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<TodoListProvider>(builder: (context, provider, _) {
                return Expanded(
                  child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    controller: provider.loadmoreController,
                    onLoading: provider.pullRefresh,
                    child: SlidableAutoCloseBehavior(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: provider.tasks.length,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          itemBuilder: (context, index) {
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
                                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        provider.isSameDay(index),
                                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        provider.tasks[index].createdAt,
                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        provider.tasks[index].status,
                                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.check_box,
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  provider.tasks[index].title,
                                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  provider.tasks[index].description ?? '',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            );
                          }),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
