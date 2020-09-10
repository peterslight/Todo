import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/database/DatabaseHelper.dart';
import 'package:flutter_app/models/TaskModel.dart';
import 'package:flutter_app/models/Todo.dart';
import 'package:flutter_app/screens/Widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  //default title
  String taskTitle = "";
  String description = "";
  int taskId = -1;

  FocusNode titleFocus;
  FocusNode descriptionFocus;
  FocusNode todoFocus;

  bool contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      print(widget.task.description);

      taskTitle = widget.task.title;
      description = widget.task.description;
      taskId = widget.task.id;

      //set visibility to true if task isnt null
      contentVisible = true;
    }

    titleFocus = FocusNode();
    todoFocus = FocusNode();
    descriptionFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    titleFocus.dispose();
    descriptionFocus.dispose();
    todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper db = DatabaseHelper();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    bottom: 12,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(100),
                        highlightColor: Colors.grey,
                        splashColor: Colors.grey,
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Image(
                            image:
                                AssetImage('assets/images/back_arrow_icon.png'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: titleFocus,
                          //set default task title if it exists
                          controller: TextEditingController()..text = taskTitle,
                          onSubmitted: (value) async {
                            if (value != "") {
                              //check if task is null
                              if (widget.task == null) {
                                Task task = Task(
                                  title: value,
                                );
                                taskId = await db.insertTask(task);
                                setState(() {
                                  //if all goes well, set the content vidible to true
                                  //also update the taskTitle string to the latest
                                  contentVisible = true;
                                  taskTitle = value;
                                });
                                print(taskId);
                              } else {
                                //"update old task"
                                taskTitle = value;
                                await db.updateTask(
                                    taskId, taskTitle, description);
                                print('updated');
                              }
                              descriptionFocus.requestFocus();
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter task title',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff211551),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        focusNode: descriptionFocus,
                        controller: TextEditingController()..text = description,
                        decoration: InputDecoration(
                          hintText: 'enter task description',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) async {
                          if (value != "") {
                            description = value;
                            await db
                                .updateTask(taskId, taskTitle, description)
                                .then((value) {
                              setState(() {});
                            });
                            print('updated');
                          }
                          todoFocus.requestFocus();
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: contentVisible,
                  child: FutureBuilder(
                    initialData: [],
                    future: db.getTodos(taskId),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  //switch todo state
                                  int status =
                                      snapshot.data[index].isDone == 0 ? 1 : 0;
                                  await db.todoIsDone(
                                      snapshot.data[index].id, status);
                                  setState(() {});
                                  print(snapshot.data[index].isDone);
                                },
                                child: TodoWidget(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            }),
                      );
                    },
                  ),
                ),
                //task todo item column
                Visibility(
                  visible: contentVisible,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: 12,
                          ),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xff86829d),
                              width: 1.5,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Image(
                            image: AssetImage('assets/images/check_icon.png'),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController()..text = "",
                            focusNode: todoFocus,
                            //onclick method
                            onSubmitted: (value) async {
                              if (value != "") {
                                //check if taskId is > -1, hence it has  been updated
                                if (taskId > -1) {
                                  DatabaseHelper db = DatabaseHelper();
                                  Todo todo = Todo(
                                      taskId: taskId, title: value, isDone: 0);
                                  await db.insertTodo(todo);
                                  setState(() {
                                    todoFocus.requestFocus();
                                  });
                                  print('creating new todo');
                                } else {
                                  print("task doesn't exist");
                                }
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Todo item...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Visibility(
              visible: contentVisible,
              child: Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () async {
                    if (taskId > -1) {
                      //task exist, so delete
                      await db.deleteTask(taskId).then((value) {
                        if (value > 0) {
                          print('delete successful');
                          Navigator.pop(context);
                          setState(() {});
                        }
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xfffe3577),
                        borderRadius: BorderRadius.circular(20)),
                    child: Image(
                      image: AssetImage('assets/images/delete_icon.png'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
