// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:memoryapp/models/group_model.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class SingleGroup extends StatelessWidget {
  GroupModel groupData;
  String groupId;
  SingleGroup({
    super.key,
    required this.groupData,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        alertUser(context: context, alertText: groupId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // group image

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                groupData.groupProfilePic,
                width: 150,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 10),

            // group right content

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComp(text: groupData.groupName),
                  const SizedBox(height: 5),
                  TextComp(text: groupData.creatorName),
                  const SizedBox(height: 5),
                  TextComp(text: "#tags"),
                  // Container(
                  //   width: double.infinity,
                  //   height: 60,
                  //   // color: Colors.red,
                  //   child: GridView.builder(
                  //     itemCount: 3,
                  //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  //         maxCrossAxisExtent: 80, mainAxisExtent: 30),
                  //     itemBuilder: (context, index) {
                  //       return TextComp(text: "#tags");
                  //     },
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
