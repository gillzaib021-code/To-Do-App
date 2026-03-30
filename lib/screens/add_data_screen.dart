import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDataScreen extends StatefulWidget {
  final String? title;
  final String? description;
  final int? index;

  const AddDataScreen({super.key, this.title, this.description, this.index});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final titlctrl = TextEditingController();
  final discctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.title != null) titlctrl.text = widget.title!;
    if (widget.description != null) discctrl.text = widget.description!;
  }

  Future<void> saveTask() async {
    final title = titlctrl.text;
    final desc = discctrl.text;

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titles = prefs.getStringList('titles') ?? [];
    List<String> descriptions = prefs.getStringList('descriptions') ?? [];

    if (widget.index != null) {
      // Edit existing task
      titles[widget.index!] = title;
      descriptions[widget.index!] = desc;
    } else {
      // Add new task
      titles.add(title);
      descriptions.add(desc);
    }

    await prefs.setStringList('titles', titles);
    await prefs.setStringList('descriptions', descriptions);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Task Saved")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index != null ? "Edit Task" : "Add Task", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            /// Title
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: titlctrl,
                decoration: InputDecoration(
                  hintText: "Enter your title",
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),

            /// Description
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: discctrl,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Enter your description",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Icon(Icons.description),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Save Button
            GestureDetector(
              onTap: saveTask,
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    widget.index != null ? 'Update' : 'Save',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}