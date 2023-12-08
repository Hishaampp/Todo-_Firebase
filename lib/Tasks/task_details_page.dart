// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:hisham_todo/Screens/add_task_page.dart';

import '../Screens/task_list.dart';

void main() {
  runApp(MaterialApp(
    home: AddTaskPage(),
  ));
}

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final taskname = TextEditingController();
  final subtaskname = TextEditingController();

  AddTaskController task = AddTaskController();
  // Get the current user
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: taskname,
              decoration: InputDecoration(labelText: 'Task description'),
            ),
            TextField(
              controller: subtaskname,
              decoration: InputDecoration(labelText: 'Add sub task'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Check if the user is logged in
                  if (user != null) {
                    String uid = user!.uid;
                     task.addTask(taskname.text, subtaskname.text);
                    // Reference to the user's tasks collection
                    // CollectionReference userTasksRef = FirebaseFirestore
                    //     .instance
                    //     .collection('users_tasks'),
                    //     .;doc(user!.uid);

                    // // Add task to the user's tasks collection
                    // await userTasksRef.add({
                    //   'task': taskname.text,
                    //   'subtask': subtaskname.text,

                    // });

                    print("Data added successfully");
                  } else {
                    print("User not logged in");
                  }
                } catch (e) {
                  print("Error adding data: $e");
                }
              },
              child: Text('Add Task'),
            ),
            // SizedBox(height: 16.0),
            // Expanded(
            //   child: TaskList(),
            // ),
          ],
        ),
      ),
    );
  }
}
