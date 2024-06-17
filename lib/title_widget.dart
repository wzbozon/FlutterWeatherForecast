import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TitleWidget extends StatelessWidget {
  final String city;

  const TitleWidget({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            city,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w300,
              color: Colors.white
            ),
          ),
          Text(
            DateFormat.yMMMd().format(DateTime.now()),
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w200,
              color: Colors.white
            ),
          ),
        ],
      ),
    );
  }
}
