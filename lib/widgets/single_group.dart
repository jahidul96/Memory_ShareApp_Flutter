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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // group image

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                groupData.groupProfilePic,
                width: 90,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 20),

            // group right content

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComp(text: groupData.groupName),
                  TextComp(
                    text: groupData.creatorName,
                    fontweight: FontWeight.normal,
                    size: 14,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
