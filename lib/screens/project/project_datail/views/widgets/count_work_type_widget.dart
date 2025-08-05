import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CountWorkTypeWidget extends StatelessWidget {
  String title = "Todo";
  String count = "0 of 0";
  Color color;
  CountWorkTypeWidget({super.key, this.title = "Todo", this.count = "0 of 0", this.color = Colors.grey});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 5, vertical: 5),
      height: 30,
      width: 30,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Tooltip(
            message: "$title : $count (story points)", 
            child: Center(
              child: Text("0", style: TextStyle(color: Colors.grey))
            ),
          );
        },
      ),
    );
  }
}
