// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/fb_firestore.dart';
import 'package:memoryapp/models/group_info.dart';
import 'package:memoryapp/models/group_model.dart';
import 'package:memoryapp/screens/group/add_new_members.dart';
import 'package:memoryapp/screens/home.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class SingleGroupDeatail extends StatefulWidget {
  GroupInfo groupInfo;

  static const routeName = "SingleGroupDeatail";
  SingleGroupDeatail({
    super.key,
    required this.groupInfo,
  });

  @override
  State<SingleGroupDeatail> createState() => _SingleGroupDeatailState();
}

class _SingleGroupDeatailState extends State<SingleGroupDeatail> {
  TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            )),
        titleSpacing: 0,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            widget.groupInfo.groupProfilePic,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("groups")
            .doc(widget.groupInfo.groupId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            var data = snapshot.data!.data() as Map<String, dynamic>;

            GroupModel singlegroupData = GroupModel.fromMap(data);
            return Column(
              children: [
                // top container
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // group name and member number
                        groupNameAndMemberCounter(
                            groupName: singlegroupData.groupName,
                            memberCount:
                                singlegroupData.groupMember.length.toString()),

                        const SizedBox(height: 30),

                        Container(
                          color: AppColors.whiteColor,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              // add members button
                              addMemberBtn(
                                  iconData: Icons.add,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddNewMemberScreen(
                                                groupData: singlegroupData,
                                                groupId:
                                                    widget.groupInfo.groupId),
                                      ),
                                    );
                                  },
                                  text: "Add Member"),

                              const Divider(
                                height: 5,
                              ),
                              // members email profile
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: singlegroupData.groupMember.length,
                                itemBuilder: (context, index) {
                                  return emailProfile(
                                    email: singlegroupData.groupMember[index]
                                        .toString(),
                                  );
                                },
                              ),

                              // edit groupName

                              addMemberBtn(
                                  iconData: Icons.edit,
                                  onTap: () => editGroupName(),
                                  text: "Edit group name"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // delete group btn

                widget.groupInfo.adminId ==
                        FirebaseAuth.instance.currentUser!.uid
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          text: "Delete group",
                          onPressed: () {},
                        ),
                      )
                    : Container()
              ],
            );
          }

          return Center(
            child: TextComp(text: "Something went wrong!"),
          );
        },
      ),
    );
  }

  editGroupName() {
    return showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: groupNameController,
                    decoration: const InputDecoration(
                      hintText: "Group Name",
                      hintStyle: TextStyle(fontSize: 20),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Edit",
                  onPressed: () {
                    editGroupFb(
                        data: {"groupName": groupNameController.text},
                        context: context,
                        docId: widget.groupInfo.groupId);
                    groupNameController.clear();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget emailProfile({
    required String email,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lightGrey, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.greyColor,
              ),
              child: Center(
                child: TextComp(
                  text: email.substring(0, 1).toUpperCase(),
                  color: AppColors.whiteColor,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextComp(
                text:
                    email.length > 15 ? "${email.substring(0, 14)}..." : email,
                fontweight: FontWeight.normal,
                size: 15,
              ),
            ),
            widget.groupInfo.adminId == FirebaseAuth.instance.currentUser!.uid
                ? TextComp(
                    text: "owner",
                    fontweight: FontWeight.normal,
                    color: AppColors.greyColor,
                  )
                : Container(),
          ],
        ),
      );
}
