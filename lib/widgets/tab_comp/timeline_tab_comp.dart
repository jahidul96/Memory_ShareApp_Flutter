import 'package:flutter/material.dart';
import 'package:memoryapp/widgets/single_post.dart';

class TimeLineTab extends StatefulWidget {
  const TimeLineTab({super.key});

  @override
  State<TimeLineTab> createState() => _TimeLineTabState();
}

class _TimeLineTabState extends State<TimeLineTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const SinglePostComp();
        },
      ),
    );
  }
}
