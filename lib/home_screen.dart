import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do__app/screens/add_data_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> titles = [];
  List<String> descriptions = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      titles = prefs.getStringList('titles') ?? [];
      descriptions = prefs.getStringList('descriptions') ?? [];
    });
  }

  /// DELETE TASK WITH CONFIRMATION DIALOG
  Future<void> confirmDeleteTask(int index) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      deleteTask(index);
    }
  }

  Future<void> deleteTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    titles.removeAt(index);
    descriptions.removeAt(index);

    await prefs.setStringList('titles', titles);
    await prefs.setStringList('descriptions', descriptions);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Tasks", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: titles.isEmpty
          ? const Center(child: Text("No tasks yet"))
          : ListView.builder(
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(titles[index]),
                    subtitle: Text(descriptions[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// EDIT BUTTON
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddDataScreen(
                                  title: titles[index],
                                  description: descriptions[index],
                                  index: index,
                                ),
                              ),
                            );
                            loadTasks();
                          },
                        ),

                        /// DELETE BUTTON WITH CONFIRMATION
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmDeleteTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white,),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddDataScreen()),
          );
          loadTasks();
        },
      ),
    );
  }
}