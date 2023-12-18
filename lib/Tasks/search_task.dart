import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class TaskSearchDelegate extends SearchDelegate<String> {
  final String uid;

  TaskSearchDelegate({required this.uid});

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
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("client").doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          var tasksData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          List tasksList = tasksData['tasks'] as List<dynamic>? ?? [];

          // Filter tasks based on the search query
          List filteredTasks = tasksList.where((task) {
            String taskName = task["task"].toString().toLowerCase();
            return taskName.contains(query.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              Map<String, dynamic>? data = filteredTasks[index] as Map<String, dynamic>;

              return ListTile(
                title: Text(data?["task"] ?? ""),
                // Add other ListTile properties as needed
              );
            },
          );
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(uid: FirebaseAuth.instance.currentUser!.uid),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: Text('Your Home Screen Content Here'),
      ),
    );
  }
}
