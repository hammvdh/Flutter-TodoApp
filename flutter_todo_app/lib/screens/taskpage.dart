import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/database_helper.dart';
import 'package:flutter_todo_app/models/task.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/widgets.dart';

class Taskpage extends StatefulWidget {

  final Task task;
  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool contentVisible = false;

  @override
  void initState() {
    if(widget.task !=null){
      contentVisible = true;
      _taskTitle = widget.task.title;
      _taskId = widget.task.id;
      _taskDescription = widget.task.description;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      bottom:6,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Image(
                              image:AssetImage(
                                'assets/images/back_arrow_icon.png'
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async{
                              //Check if the field is not empty
                              if(value !="") {
                                //Check if the task is null
                                if(widget.task == null){
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Task _newTask = Task(title: value);
                                  _taskId = await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    contentVisible=true;
                                    _taskTitle = value;
                                  });
                                  print("New task has been created! : $_taskId ");
                                }else{
                                  _dbHelper.updateTaskTitle(_taskId, value);
                                  print("Task Updated!");
                                }
                                _descriptionFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController()..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: "Enter Task Title",
                              border:InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color:Color(0xFF211551),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async{
                          if(value !=""){
                            if(_taskId != 0){
                               await _dbHelper.updateTaskDescription(_taskId, value);
                               _taskDescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()..text = _taskDescription ,
                        decoration: InputDecoration(
                          hintText:"Enter Task Description...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24,
                          )
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodo(_taskId),
                      builder:(context, snapshot){
                        return Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: () async{
                                    // switch the to do completion state
                                  if(snapshot.data[index].isDone == 0){
                                    await _dbHelper.updateTaskTodo(snapshot.data[index].id,1);
                                  } else {
                                    await _dbHelper.updateTaskTodo(snapshot.data[index].id,0);
                                  }
                                  setState(() {});
                                },
                                child: ToDoWidget(
                                  text:snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0 ? false : true,
                                ),
                              );
                            }
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: contentVisible,
                    child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: EdgeInsets.only(
                                  right: 14,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Color(0xFF86829D),
                                      width: 1.5,
                                    )
                                ),
                                child: Image(
                                    image:AssetImage(
                                        'assets/images/check_icon.png'
                                    )
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: _todoFocus,
                                  controller: TextEditingController()..text = "",
                                  onSubmitted: (value) async{
                                    //Check if the field is not empty
                                    if(value !="") {
                                      //Check if the task is null
                                      if(_taskId != 0){

                                        Todo _newTodo = Todo(
                                            title: value,
                                            isDone: 0,
                                            taskId: _taskId,
                                        );
                                        await _dbHelper.insertTodo(_newTodo);
                                        setState(() {});
                                        _todoFocus.requestFocus();
                                        print("New todo has been created! ");
                                      }else{
                                        print("Task does not exist");
                                      }
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Enter To-do item",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  )
                ],
              ),
              Visibility(
                visible: contentVisible,
                child: Positioned(
                  bottom:24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () async{
                        if(_taskId!=0){
                          await _dbHelper.deleteTask(_taskId);
                          Navigator.pop(context);
                        }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color:Color(0xFFFE3577),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Image(
                          image:AssetImage(
                              'assets/images/delete_icon.png'
                          )
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
