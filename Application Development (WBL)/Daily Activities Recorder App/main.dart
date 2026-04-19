// Lab 1: Daily Activities Recorder App
// Student Name: Chua Jia Lin
// Matric No: A23CS0069
// Section: 2

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Activity{
  final String name;
  final String timeCategory;

  Activity({
    required this.name,
    required this.timeCategory,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Activities Recorder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ActivityPage(),
    );
  }
}

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final TextEditingController nameController= TextEditingController();
  final TextEditingController timeCategoryController= TextEditingController();

  final List<Activity> activities= [];

  void addActivity() {
    final String name= nameController.text.trim();
    final String timeCategory= timeCategoryController.text.trim();

    if(name.isEmpty|| timeCategory.isEmpty){
      showMessage('Please fill in all fields');
      return;
    }

    setState((){
      activities.add(
        Activity(
          name: name,
          timeCategory: timeCategory,
        ),
      );
    });

    clearField();
    showMessage('Activity added successfully');
  }

  void clearField(){
    nameController.clear();
    timeCategoryController.clear();
  }

  void deleteActivity(int index){
    setState((){
      activities.removeAt(index);
    });

    showMessage('Activity deleted successfully');
  }

  void showMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message)
      ),
    );
  }

  @override
  void dispose(){
    nameController.dispose();
    timeCategoryController.dispose();
    super.dispose();
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
  }){
    return Padding(
      padding: const EdgeInsets.only(bottom:12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  Widget buildActivityCard(Activity activity, int index){
    return Card(
      margin: const EdgeInsets.only(bottom:12),
      elevation:3,
      child: ListTile(
        title: Text(activity.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 69, 69, 69))),
        subtitle: Text(activity.timeCategory),
        isThreeLine: true,
        trailing: TextButton(
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
          onPressed: () => deleteActivity(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 136, 241),
        leading: const Icon(Icons.list_alt),
        title: const Text('Daily Activities Recorder'),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:[
            buildTextField(
              controller: nameController,
              label: 'Activity Name',
            ),
            buildTextField(
              controller: timeCategoryController,
              label: 'Time / Category',
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: addActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 9, 136, 241), // Set the background color
                  foregroundColor: Colors.white, // Set the text color
                ),
                child: const Text('+ Add Activity', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height:20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ACTIVITIES',
                style: TextStyle(
                  fontSize:14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 134, 134, 134),
                ),
              ),
            ),
            const SizedBox(height:10),
            Expanded(
              child: activities.isEmpty
                ? const Center(
                    child: Text('No activities yet'),
                  )
                : ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index){
                      return buildActivityCard(activities[index], index);
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
