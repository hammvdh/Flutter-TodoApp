
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/database_helper.dart';
import 'package:flutter_todo_app/screens/taskpage.dart';
import 'package:flutter_todo_app/widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SafeArea(
          child:Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: 24.0,
            ),
            color: Color(0xFFF6F6F6),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top:32,
                        bottom:32.0,
                      ),
                      child:Image(
                          image:AssetImage(
                              'assets/images/logo.png'
                          ),
                        ),
                      ),
                    Expanded(
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTasks(),
                        builder: (context, snapshot){
                          return ScrollConfiguration(
                            behavior: ScrollEffectBehaviour(),
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Taskpage(
                                              task:snapshot.data[index]
                                          )),
                                      ).then((value){
                                        setState(() {});
                                      });
                                    },
                                    child: TaskCardWidget(
                                      title: snapshot.data[index].title,
                                      desc: snapshot.data[index].description,
                                    ),
                                  );
                                }
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                ),
                Positioned(
                  bottom:24,
                  right: 0,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Taskpage(task: null)
                          ),
                      ).then((value){
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:[Color(0xFF7349FE),Color(0xFF643FDB)],
                          begin: Alignment(0,-1),
                          end:Alignment(0,1)
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Image(
                        image:AssetImage(
                          'assets/images/add_icon.png'
                        )
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
