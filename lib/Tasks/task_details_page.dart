import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:hisham_todo/Screens/add_task_page.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final taskname = TextEditingController();
  final subtaskname = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  AddTaskController task = AddTaskController();
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
            Row(
              children: [
                Text(
                  'Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text('Pick Date'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  'Select Time: ${selectedTime.format(context)}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );

                    if (pickedTime != null && pickedTime != selectedTime) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Text('Pick Time'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (user != null) {
                    String uid = user!.uid;
                    DateTime combinedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    task.addTask(
                      taskname.text,
                      subtaskname.text,
                      combinedDateTime.toString(),
                    );
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
          ],
        ),
      ),
    );
  }
}
