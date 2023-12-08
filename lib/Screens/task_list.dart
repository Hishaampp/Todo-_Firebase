// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Tasks/edit_task_page.dart';
import '../Tasks/task_card.dart';

// ... (imports remain the same)

// ... (imports remain the same)


class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Task List'),
        centerTitle: true,
        backgroundColor: Colors.blue, // Set your preferred background color
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add any action you want when the add button is pressed
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users_tasks').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No tasks available.');
          }

          var reversedDocs = snapshot.data!.docs.reversed.toList();

          return ListView.builder(
            itemCount: reversedDocs.length,
            itemBuilder: (context, index) {
              var data = reversedDocs[index].data() as Map<String, dynamic>;

              // Check if 'tasks' is present and is a list
              if (data.containsKey('tasks') && data['tasks'] is List) {
                List<dynamic> tasksList = data['tasks'];

                // Convert the list of tasks to a list of TaskCards
                List<Widget> taskCards = tasksList.map<Widget>((taskData) {
                  if (taskData is Map<String, dynamic> &&
                      taskData.containsKey('task') &&
                      taskData.containsKey('subTask')) {
                    return Container(
                      width: MediaQuery.of(context).size.width, // Full width of the screen
                      child: TaskCard(
                        uid: reversedDocs[index].id,
                        cardTitle: taskData['task'],
                        tasksRemaining: 0,
                        taskCompletion: 0.0,
                        icon: Icons.task,
                        color: Colors.blue,
                        onEditPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskPage(
                                documentId: reversedDocs[index].id,
                                currentTask: taskData['task'],
                                currentSubtask: taskData['subTask'],
                              ),
                            ),
                          );
                        },
                        // onDeletePressed: () {  },
                      ),
                    );
                  } else {
                    return Container(); // Handle the case where taskData is not a valid map
                  }
                }).toList();

                return Column(
                  children: taskCards,
                );
              } else {
                return Container(); // Handle the case where 'tasks' is not present or not a List
              }
            },
          );
        },
      ),
    );
  }
}