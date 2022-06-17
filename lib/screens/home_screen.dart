// ignore_for_file: prefer_const_constructors

import 'package:crud_flutter/controllers/todo_controller.dart';
import 'package:crud_flutter/models/todo_model.dart';
import 'package:crud_flutter/repository/todo_repository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //dependency injection
    var todoController = TodoController(TodoRepository());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        centerTitle: true,
        title: Text('REST API'),
      ),
      body: FutureBuilder<List<Todo>>(
          future: todoController.fetchTodoList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('error'),
              );
            }
            return ListView.separated(
                itemBuilder: (context, index) {
                  var todo = snapshot.data?[index];
                  return Container(
                    height: 100.0,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Text('${todo?.id}')),
                        Expanded(flex: 3, child: Text('${todo?.title}')),
                        Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    todoController
                                        .updatePatchCompleted(todo!)
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(milliseconds: 500),
                                          content: Text('$value'),
                                        ),
                                      );
                                    });
                                  },
                                  child: buildCallContainer(
                                    'patch',
                                    Color(0xFFE1BEE7),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    todoController.updatePutCompleted(todo!);
                                  },
                                  child: buildCallContainer(
                                    'put',
                                    Color(0xFFFFE0B2),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    todoController
                                        .deleteTodo(todo!)
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(milliseconds: 500),
                                          content: Text('$value'),
                                        ),
                                      );
                                    });
                                  },
                                  child: buildCallContainer(
                                    'del',
                                    Color(0xFFFFCDD2),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 0.5,
                    height: 0.5,
                  );
                },
                itemCount: snapshot.data?.length ?? 0);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Todo todo = Todo(userId: 3, title: 'sample post', completed: false);
          todoController.postTodo(todo);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Container buildCallContainer(String title, Color color) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(child: Text('$title')),
    );
  }
}
