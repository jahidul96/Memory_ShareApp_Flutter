// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:memoryapp/models/group_info.dart';
import 'package:memoryapp/models/simple_models.dart';
import 'package:memoryapp/screens/home.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/loadder_widget.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupNotificationScreen extends StatefulWidget {
  GroupInfo groupInfo;
  GroupNotificationScreen({super.key, required this.groupInfo});

  @override
  State<GroupNotificationScreen> createState() =>
      _GroupNotificationScreenState();
}

class _GroupNotificationScreenState extends State<GroupNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: TextComp(
          text: "Notifications",
          color: AppColors.whiteColor,
          size: 18,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("groups")
            .doc(widget.groupInfo.groupId)
            .collection("groupNotifications")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadderWidget();
            }
            List<GroupNotificationModel> grpNotification = [];
            var docs = snapshot.data!.docs;

            for (var element in docs) {
              grpNotification
                  .add(GroupNotificationModel.fromMap(element.data()));
            }
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.lightGrey,
                        ),
                        child: Center(
                          child: TextComp(
                            text: grpNotification[index].name.substring(0, 1),
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: grpNotification[index].name,
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                                fontSize: 15),
                            children: <TextSpan>[
                              grpNotification[index].type == "groupMember"
                                  ? const TextSpan(
                                      text: ' added to the group.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                    )
                                  : const TextSpan(
                                      text: ' added a new note.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(
            child: TextComp(
              text: "No Notification",
              fontweight: FontWeight.normal,
              size: 18,
            ),
          );
        },
      ),
    );
  }
}
