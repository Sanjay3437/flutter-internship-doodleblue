import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/models/task_model.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  // final TextEditingController titleController =
  // TextEditingController();

  List<TextEditingController> _taskcontroller = [
    TextEditingController(),
  ];

  late Box<TaskModel> taskBox;

  void loadTasks() {
    for (final c in _taskcontroller) {
      c.dispose();
    }

    _taskcontroller.clear();
    _isCompleted.clear();

    for (final task in taskBox.values) {

      _taskcontroller.add(
        TextEditingController(text: task.task),
      );

      _isCompleted.add(task.isCompleted);
    }

    // if (_taskcontroller.isEmpty) {
    //   _taskcontroller.add(TextEditingController());
    //   _isCompleted.add(false);
    // }

  }

List<bool> _isCompleted = [
false,
];

  Widget _buildTaskField(int index){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: TextField(
        controller: _taskcontroller[index],
        onChanged: (value) {

          taskBox.putAt(
            index,
            TaskModel(
              task: value,
              description: taskBox.getAt(index)?.description ?? "",
              isCompleted: _isCompleted[index],
            ),
          );

        },
        // onSubmitted: (_) {
        //   _addNewTaskField();
        // },
        style: TextStyle(
          decoration: _isCompleted[index] ? TextDecoration.lineThrough : TextDecoration.none,
          color: _isCompleted[index] ? Colors.grey : Colors.black,
        ),
        decoration: InputDecoration(

          prefixIcon: IconButton(
            icon: Icon(
              _isCompleted[index] ? Icons.check_circle : Icons.radio_button_off,
            ),
            onPressed: () {
              setState(() {
                //   need to strike through the task in the field
                _isCompleted[index] = !_isCompleted[index];
                taskBox.putAt(
                  index,
                  TaskModel(
                    task: _taskcontroller[index].text,
                    description: taskBox.getAt(index)?.description ?? "",
                    isCompleted: _isCompleted[index],
                  ),
                );
              });
            }
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 45),

          suffixIcon: IconButton(
            icon: Icon(Icons.delete_outline, color: Color(0xFF9D2D14), size: 20),
            onPressed: () {
              setState(() {
                final controller = _taskcontroller.removeAt(index);

                controller.dispose();

                _isCompleted.removeAt(index);

                taskBox.deleteAt(index);
              });
            },
          ),
          suffixIconConstraints: BoxConstraints(minWidth: 45),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
            borderSide: BorderSide.none,
            gapPadding: 20.0,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),

          // prefixIcon: Icon(Icons.radio_button_off_outlined, color: Colors.black, size: 20),
          // prefixIconConstraints: BoxConstraints(minWidth: 45),
          // suffixIcon: Icon(Icons.delete_outline, color: Color(0xFF9D2D14), size: 20),
          // suffixIconConstraints: BoxConstraints(minWidth: 45),
          filled: true,
          // fillColor: Colors.grey[200],
          hintText: "Add Task",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    taskBox = Hive.box<TaskModel>("tasks");

    loadTasks();
  }

  // void _addNewTaskField() {
  //
  //   taskBox.add(
  //     TaskModel(
  //       task: "",
  //       description: "",
  //       isCompleted: false,
  //     ),
  //   );
  //
  //   setState(() {
  //
  //     _taskcontroller.add(TextEditingController());
  //
  //     _isCompleted.add(false);
  //
  //   });
  // }

  @override
  void dispose() {
    for (var controller in _taskcontroller) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showAddTaskSheet(BuildContext context)  {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // pushes sheet up when keyboard opens
            left: 16, right: 16, top: 30,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                 SizedBox(height: 12),
                TextFormField (
                  controller: titleController,
                  decoration:  InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black54, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:  BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:  BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bodyController,
                  maxLines: 4,
                  decoration:  InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black54, width: 2),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C6FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),

                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // final isValid = formKey.currentState!.validate();
                      //
                      // if (!isValid) {
                      //   // stop here — red error text shows automatically, sheet stays open
                      //   return;
                      // }

                      taskBox.add(
                          TaskModel(
                            task: titleController.text.trim(),
                            description: bodyController.text.trim(),
                            isCompleted: false,
                          )
                      );

                      setState(() {
                        loadTasks();
                      });

                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      titleController.dispose();
      bodyController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
            ),
          ),
        ),
        title: const Text('TOᗪO ᗩᑭᑭ ᝰ.ᐟ'),
      ),

      body: Stack(
        children: [
        // Background Image
        Positioned.fill(
          child: SvgPicture.asset(
            "assets/images/bg4.svg",
            fit: BoxFit.cover,
          ),
        ),

        // Foreground Content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.only(top: 20, right:20, left: 20, bottom:5 ),
              child: Text(
                "My Task",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 1),
             Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                "${taskBox.values.where((e) => !e.isCompleted).length} active Task",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 1),
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 0, left: 20,right: 20),
              child: Text(
                "Today",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: _taskcontroller.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/no_task.svg",
                      height: 190,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "No Tasks Yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Tap the ' + ' button to add your first task.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _taskcontroller.length,
                itemBuilder: (context, index) {
                  return _buildTaskField(index);
                },
              ),
            ),

            // Padding(
            //             //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //             //   child: TextField(
            //             //     decoration: InputDecoration(
            //             //       border: OutlineInputBorder(
            //             //         borderRadius: BorderRadius.all(Radius.circular(14.0)),
            //             //         borderSide: BorderSide.none,
            //             //         gapPadding: 20.0,
            //             //       ),
            //             //       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            //             //       prefixIcon: Icon(Icons.radio_button_off_outlined, color: Colors.black, size: 20),
            //             //       prefixIconConstraints: BoxConstraints(minWidth: 45),
            //             //       filled: true,
            //             //       // fillColor: Colors.grey[200],
            //             //       hintText: "Add Task",
            //             //       hintStyle: TextStyle(color: Colors.grey),
            //             //     ),
            //             //   ),
            //             // ),

            // for (int i = 0; i < _taskcontroller.length; i++)
            //   _buildTaskField(i),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        child: const Icon(Icons.add),
        tooltip: "Add task",
        backgroundColor: Color(0xFF00C6FF),
        foregroundColor: Colors.white,
      ),
    );
  }
}
