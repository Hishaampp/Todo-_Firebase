import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTaskController {
  Future<void> addTask(
      String taskName, String subTaskName,) async {
    try {
      if (taskName.isEmpty ||
          subTaskName.isEmpty 
          ) {
        print("Please fill in all fields");
        return;
      }

      // String dateTimeString = '$date $time';
      // DateTime dateTime = DateFormat('MM/dd/yyyy HH:mm').parse(dateTimeString);
      // Timestamp timestamp = Timestamp.fromDate(dateTime);

      var taskData = {
        'task': taskName,
        'subTask': subTaskName,
        // 'priority': Priority,
      };

      var uid = FirebaseAuth.instance.currentUser?.uid;
      print(uid);
      if (uid != null) {
        var collRef =
            FirebaseFirestore.instance.collection('users_tasks').doc(uid);

        // Check if the document for the user exists
        var userDoc = await collRef.get();
        if (!userDoc.exists) {
          // If the document doesn't exist, create it with an empty 'tasks' list
          await collRef.set({'tasks': []});
        }

        // Get the current list of tasks from the user's document
        var tasksList = (userDoc.data()?['tasks'] ?? []) as List<dynamic>;
        print(tasksList);
        // Add the new task to the list as a map
        tasksList.add(taskData);
        print(taskData);
        print('fffffffffffffffffffff');
        // Update the 'tasks' field with the modified list
        await collRef.update({'tasks': tasksList});

        print("Data added successfully!");
      } else {
        print("User not authenticated.");
      }
    } catch (e) {
      print("Error adding data: $e");
    }
  }
}

// Usage:
var addTaskController = AddTaskController();
// addTaskController.addTask('Task Name', 'Subtask Name', '12/07/2023', '14:30');