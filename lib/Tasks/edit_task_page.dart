import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? user = FirebaseAuth.instance.currentUser;

class EditTaskPage extends StatefulWidget {
  final String currentTask;
  final String currentSubtask;

  EditTaskPage({
    required this.currentTask,
    required this.currentSubtask,
  });

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController subtaskNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.currentTask;
    subtaskNameController.text = widget.currentSubtask;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: taskNameController,
              decoration: InputDecoration(labelText: 'Task description'),
            ),
            TextField(
              controller: subtaskNameController,
              decoration: InputDecoration(labelText: 'Add sub task'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String uid = user!.uid;
                      CollectionReference collRef =
                          FirebaseFirestore.instance.collection('client');

                      // Get the user's document by UID
                      DocumentSnapshot userDoc =
                          await collRef.doc(uid).get();

                      // Get the current tasks array
                      List<dynamic> tasks = userDoc['tasks'];

                      // Print debug messages
                      print('UID: $uid');
                      print('Current tasks: $tasks');

                      // Iterate through tasks to find the matching task and update
                      for (int i = 0; i < tasks.length; i++) {
                        print('Checking task: ${tasks[i]}');
                        if (tasks[i]['task'] == widget.currentTask &&
                            tasks[i]['subTask'] == widget.currentSubtask) {
                          // Update the matching task
                          tasks[i]['task'] = taskNameController.text;
                          tasks[i]['subTask'] = subtaskNameController.text;

                          // Update the entire tasks array in the document
                          await collRef.doc(uid).update({'tasks': tasks});

                          // Print debug message
                          print('Updated tasks: $tasks');

                          Navigator.pop(context);
                          return; // Exit the loop once the task is updated
                        }
                      }

                      // If no match found
                      print('Task not found for update.');
                    } catch (e) {
                      print("Error updating data: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error updating task: $e"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: Text('Update Task'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String uid = user!.uid;
                      CollectionReference collRef =
                          FirebaseFirestore.instance.collection('client');

                      // Get the user's document by UID
                      DocumentSnapshot userDoc =
                          await collRef.doc(uid).get();

                      // Get the current tasks array
                      List<dynamic> tasks = userDoc['tasks'];

                      // Print debug messages
                      print('UID: $uid');
                      print('Current tasks: $tasks');

                      // Iterate through tasks to find the matching task and delete
                      for (int i = 0; i < tasks.length; i++) {
                        print('Checking task: ${tasks[i]}');
                        if (tasks[i]['task'] == widget.currentTask &&
                            tasks[i]['subTask'] == widget.currentSubtask) {
                          // Remove the matching task
                          tasks.removeAt(i);

                          // Update the entire tasks array in the document
                          await collRef.doc(uid).update({'tasks': tasks});

                          // Print debug message
                          print('Updated tasks: $tasks');

                          Navigator.pop(context);
                          return; // Exit the loop once the task is deleted
                        }
                      }

                      // If no match found
                      print('Task not found for deletion.');
                    } catch (e) {
                      print("Error deleting data: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error deleting task: $e"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text('Delete Task'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
