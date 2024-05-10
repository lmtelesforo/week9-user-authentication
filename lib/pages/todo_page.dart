import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/auth_provider.dart';
import '../providers/todo_provider.dart';
import 'modal_todo.dart';
import 'user_details_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  User? user;
  late String userEmail;

  @override
  void initState() { // initialize variables before building
    super.initState();
    getUserEmail();
  }

  void getUserEmail() {
    // get current user from authprovider
    user = context.read<UserAuthProvider>().user;
    // retrieve user email
    userEmail = user!.email!;
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todo;
    context.read<TodoListProvider>().fetchTodos(); // fetchcurrent todos

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text("Todo"),
      ),
      body: StreamBuilder(
        stream: todosStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) { 
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Todos Found"),
            );
          }

          // filter todos by current user email before building listview
          List<DocumentSnapshot> userTodos = (snapshot.data as QuerySnapshot)
            .docs
            .where((todo) => (todo.data() as Map<String, dynamic>)['email'] == userEmail) 
            .toList(); // match todos by email field

          if (userTodos.isEmpty) { // if user todos are empty, display message
            return const Center(
              child: Text("No Todos Found"),
            );
          }

          return ListView.builder( // replaced snapshot with filtered userTodos
            itemCount: userTodos.length,
            itemBuilder: ((context, index) {
              Todo todo = Todo.fromJson(
                  userTodos[index].data() as Map<String, dynamic>);
              todo.id = userTodos[index].id;
              return Dismissible(
                key: Key(todo.id.toString()),
                onDismissed: (direction) {
                  context.read<TodoListProvider>().deleteTodo(todo.title);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${todo.title} dismissed')));
                },
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? value) {
                      context
                          .read<TodoListProvider>()
                          .toggleStatus(todo.id!, value!);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => TodoModal(
                              type: 'Edit',
                              item: todo,
                            ),
                          );
                        },
                        icon: const Icon(Icons.create_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => TodoModal(
                              type: 'Delete',
                              item: todo,
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outlined),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(
              type: 'Add',
              item: null,
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }

  Drawer get drawer => Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        const DrawerHeader(child: Text("Todo")),
        ListTile(
          title: const Text('Details'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserDetailsPage()));
          },
        ),
        ListTile(
          title: const Text('Todo List'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, "/");
          },
        ),
        ListTile(
          title: const Text('Logout'),
          onTap: () {
            context.read<UserAuthProvider>().signOut();
            Navigator.pop(context);
          },
        ),
      ]));
}
