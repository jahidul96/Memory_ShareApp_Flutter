// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memoryapp/models/group_model.dart';
import 'package:memoryapp/screens/see_group_post_media.dart';
import 'package:memoryapp/utils/app_colors.dart';
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
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleGroupPostAndMediaScreen(
                groupId: groupId,
                groupData: groupData,
              ),
            ));
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
              child: CachedNetworkImage(
                width: 90,
                height: 80,
                fit: BoxFit.cover,
                imageUrl: groupData.groupProfilePic,
                placeholder: (context, url) => const Center(
                  child: Icon(
                    Icons.image,
                    size: 80,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),

            const SizedBox(width: 20),

            // group right content

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComp(text: groupData.groupName),
                  // TextComp(
                  //   text: groupData.creatorName,
                  //   fontweight: FontWeight.normal,
                  //   size: 14,
                  // ),
                  TextComp(
                    text: "All media an post",
                    fontweight: FontWeight.normal,
                    size: 14,
                    color: AppColors.greyColor,
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
