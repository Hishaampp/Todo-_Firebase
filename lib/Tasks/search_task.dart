import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'task_card.dart';



class TaskSearchDelegate extends SearchDelegate {
  final List<DocumentSnapshot> tasks;

  TaskSearchDelegate({required this.tasks});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredTasks = tasks.where((doc) {
      return doc["task"].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        String uid = filteredTasks[index].id;

        return TaskCard(
          uid: uid,
          icon: Icons.task,
          color: Colors.blue,
          cardTitle: filteredTasks[index]["task"] ?? "",
          tasksRemaining: 3,
          taskCompletion: 0.7,
          onEditPressed: () {
            showEditTaskDialog(context, uid, filteredTasks[index]["task"] ?? "");
          },
        );  
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
  
  void showEditTaskDialog(BuildContext context, String uid, param2) {}
}