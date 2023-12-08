import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hisham_todo/main.dart';

class TaskCard extends StatelessWidget {
  final String uid;
  final IconData icon;
  final Color color;
  final String cardTitle;
  final int tasksRemaining;
  final double taskCompletion;
  final String task;
  final String subtask;

  final VoidCallback onEditPressed;

  TaskCard({
    required this.uid,
    required this.icon,
    required this.color,
    required this.cardTitle,
    required this.tasksRemaining,
    required this.taskCompletion,
    required this.onEditPressed,
    required this.task
    required this.subtask

    // required Null Function() onDeletePressed,
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
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEditPressed();
                        } else if (value == 'delete') {
                          _deleteTask(uid, task);
                          // FirebaseFirestore.instance
                          //     .collection('users_tasks')
                          //     .doc(currentuser!.uid)
                          //     .delete();
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
                  style:
                      TextStyle(color: const Color.fromARGB(255, 17, 16, 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTask(String documentId, TaskCard task) async {
    try {
      await FirebaseFirestore.instance.collection("client").doc(uid).update({
        'tasks': FieldValue.arrayRemove([
          {
            'task': task.taskCompletion,
            // 'subTask': task.,
          }
        ])
      });
      //  setState(() {});
    } catch (e) {
      // Handle errors if any
      print("Error deleting task: $e");
    }
  }
}
