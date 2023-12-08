import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hisham_todo/Model/Auth.dart';
import 'package:hisham_todo/Screens/group.dart';
import 'package:hisham_todo/Tasks/search_task.dart';
import 'package:hisham_todo/Tasks/task_card.dart';
import 'package:hisham_todo/Tasks/task_details_page.dart';
import 'package:hisham_todo/main.dart';
import 'package:hisham_todo/screens/settings_page.dart';
import 'package:hisham_todo/screens/task_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<DocumentSnapshot> tasks;
  TextEditingController searchController = TextEditingController();
  final taskNameController = TextEditingController();
  var uid;

  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildUserInfo(),
          Expanded(
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection("users_tasks")
                  .doc(uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  var tasksData = snapshot.data?.data() ?? {};
                  List tasksList = tasksData['tasks'] ?? [];

                  return ListView.builder(
                    itemCount: tasksList.length,
                    itemBuilder: (context, index) {
                      String uid = snapshot.data!.id;
                      Map<String, dynamic>? data =
                          tasksList[index] as Map<String, dynamic>?;

                      return TaskCard(
                        uid: uid,
                        icon: Icons.task,
                        color: Colors.blue,
                        cardTitle: data?["task"] ?? "",
                        tasksRemaining: 3,
                        taskCompletion: 0.7,
                        onEditPressed: () {
                          showEditTaskDialog(
                              context, uid, data?["task"] ?? "");
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 18, 145, 224),
      title: Text(''),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: Image.network(currentuser!.photoURL!).image,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: TaskSearchDelegate(tasks: tasks),
            );
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  Widget buildUserInfo() {
  return Padding(
    padding: const EdgeInsets.only(top: 60, left: 30),
    child: Row(
      children: [
        Expanded(
          child: Text(
            'Hello, ${currentuser!.displayName}',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 0),
          child: CircleAvatar(
            backgroundImage: Image.network(currentuser!.photoURL!).image,
            radius: 40,
          ),
        ),
      ],
    ),
  );
}


  Widget buildFloatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 160),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GroupPage()));
            },
            icon: Icon(Icons.group),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskList()),
              );
            },
            icon: Icon(Icons.task),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    authModel: AuthModel(),
                  ),
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  void showEditTaskDialog(
      BuildContext context, String uid, String currentTask) {
    TextEditingController taskController =
        TextEditingController(text: currentTask);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(labelText: 'New Task Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Your save logic goes here
                // FirebaseFirestore.instance
                //     .collection('client')
                //     .doc(uid)
                //     .update({
                //   'tasks': FieldValue.arrayUnion([taskController.text])
                // });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
