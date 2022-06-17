import 'package:crud_flutter/models/todo_model.dart';

//Fake server JsonPlaceholder
abstract class Repository {
  //get
  Future<List<Todo>> getTodoList();
  //patch
  Future<String> patchCompleted(Todo todo);
  //put
  Future<String> putCompleted(Todo todo);
  //delete
  Future<String> deletedTodo(Todo todo);
  //post
  Future<String> postTodo(Todo todo);
}
