import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String title, desc;

  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? 'Unnamed Task',
            style: TextStyle(
              color: Color(0xff211551),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              desc ?? 'No Description added yet',
              style: TextStyle(
                color: Color(0xff868290),
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;

  TodoWidget({this.text, this.isDone});

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
            margin: EdgeInsets.only(
              right: 12,
            ),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: isDone
                  ? null
                  : Border.all(
                      color: Color(0xff86829d),
                      width: 1.5,
                    ),
              color: isDone ? Color(0xff7349fe) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Image(
              image: AssetImage('assets/images/check_icon.png'),
            ),
          ),
          Flexible(
            child: Text(
              text ?? 'unnamed todo item',
              style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.none,
                  color: isDone ? Color(0xff211551) : Color(0xff86829d),
                  fontWeight: isDone ? FontWeight.bold : FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
