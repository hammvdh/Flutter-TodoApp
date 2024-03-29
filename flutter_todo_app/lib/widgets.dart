import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {

  final String title;
  final String desc;
  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      margin:EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "Unnamed Task",
            style: TextStyle(
              color:Color(0xFF211551),
              fontSize: 21.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top:10.0,
            ),
            child: Text(
              desc ?? "No Description Added",
              style:TextStyle(
                color:Color(0xFF86829D),
                fontSize: 16.0,
                height: 1.5,
            )
            ),
          ),
        ],
      )
    );
  }
}

class ToDoWidget extends StatelessWidget {
  final String text;
  final bool isDone;
  ToDoWidget({this.text, @required this.isDone});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8,
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
              color: isDone ? Color(0XFF7349FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isDone ? null : Border.all(
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
          Flexible(
            child: Text(
              text ?? "Un-named Todo",
              style: TextStyle(
                fontSize: 16,
                color: isDone ? Color(0xFF7349FE) : Color(0XFF86829D),
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollEffectBehaviour extends ScrollBehavior{
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection){
      return child;
  }
}