import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hisham_todo/Tasks/edit_task_page.dart';

User? user = FirebaseAuth.instance.currentUser;

class TaskCard extends StatelessWidget {
  final String uid;
  final IconData icon;
  final Color color;
  final String cardTitle;
  final int tasksRemaining;
  final double taskCompletion;
  final VoidCallback onEditPressed;

  TaskCard({
    required this.uid,
    required this.icon,
    required this.color,
    required this.cardTitle,
    required this.tasksRemaining,
    required this.taskCompletion,
    required this.onEditPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          width: 250.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      icon,
                      color: color,
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          onEditPressed();
                        } else if (value == 'delete') {
                          try {
                            // Fetch the current document
                            final taskListSnapshot = await FirebaseFirestore.instance
                                .collection('client')
                                .doc(user!.uid)
                                .get();

                            // Extract the taskList array from the document
                            List<dynamic> taskList = taskListSnapshot['tasks'];

                            // Delete the first task from the array (you can adjust the index as needed)
                            if (taskList.isNotEmpty) {
                              taskList.removeAt(0); // Change this index as needed
                            }

                            // Update the document with the modified taskList
                            await FirebaseFirestore.instance
                                .collection('client')
                                .doc(user!.uid)
                                .update({'tasks': taskList});
                          } catch (e) {
                            print("Error deleting task: $e");
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return ['Edit', 'Delete'].map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice.toLowerCase(),
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        "${tasksRemaining} Tasks",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        "${cardTitle}",
                        style: TextStyle(fontSize: 28.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(
                        value: taskCompletion,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Date and Time: ${DateTime.now().toString()}",
                  style: TextStyle(color: const Color.fromARGB(255, 17, 16, 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
