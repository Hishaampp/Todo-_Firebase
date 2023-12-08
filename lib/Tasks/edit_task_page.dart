// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? user = FirebaseAuth.instance.currentUser;

class EditTaskPage extends StatefulWidget {
  final String documentId;
  final String currentTask;
  final String currentSubtask;


  EditTaskPage({
    required this.documentId,
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
            ElevatedButton(
              onPressed: () async {
                try {
                  CollectionReference collRef =
                      FirebaseFirestore.instance.collection('users_tasks');
                  await collRef.doc(widget.documentId).update({
                    'task': taskNameController.text,
                    'subtask': subtaskNameController.text,
                  });
                  Navigator.pop(context);
                } catch (e) {
                  print("Error updating data: $e");
                }
              },
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
