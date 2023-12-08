import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hisham_todo/main.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Task List'),
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

          // Reverse the order of items to display the newest task at the top
          var reversedDocs = snapshot.data!.docs.reversed.toList();

          return ListView.builder(
            itemCount: reversedDocs.length,
            itemBuilder: (context, index) {
              var data = reversedDocs[index].data() as Map<String, dynamic>;
              return TaskCard(
                documentId: reversedDocs[index].id,
                cardTitle: data['task'],
                tasksRemaining: 0, // You can set this dynamically based on your logic
                taskCompletion: 0.0, // You can set this dynamically based on your logic
                icon: Icons.task,
                color: Colors.blue,
              );
            },
          );
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String documentId;
  final IconData icon;
  final Color color;
  final String cardTitle;
  final int tasksRemaining;
  final double taskCompletion;

  TaskCard({
    required this.documentId,
    required this.icon,
    required this.color,
    required this.cardTitle,
    required this.tasksRemaining,
    required this.taskCompletion,
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
                          // Implement edit functionality
                          // You can open a new page for editing or show a dialog
                          print('Edit clicked');
                          // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskPage(documentId: documentId)));
                        } else if (value == 'delete') {
                          // Implement delete functionality
                          FirebaseFirestore.instance.collection('users_tasks').doc(currentuser!.uid).delete();
                          print('Delete clicked');
                        }
                        // Add more options as needed
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
              // Display Date and Time
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
