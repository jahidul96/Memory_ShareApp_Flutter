// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/fb_firestore.dart';
import 'package:memoryapp/models/group_info.dart';
import 'package:memoryapp/models/group_model.dart';
import 'package:memoryapp/screens/group/add_new_members.dart';
import 'package:memoryapp/screens/home.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/loadder_widget.dart';

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
  bool loading = false;
  bool contentLoading = true;

// delete group
  deleteGroup() async {
    setState(() {
      loading = true;
    });
    Navigator.pop(context);
    try {
      await deletePostComment(widget.groupInfo.groupId);
      await deleteThisGroupPost(widget.groupInfo.groupId);
      await deleteGroupFb(widget.groupInfo.groupId);
      Navigator.pushNamed(context, HomeScreen.routeName);
    } catch (e) {
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
      return alertUser(context: context, alertText: "something went wrong");
    }
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        contentLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        automaticallyImplyLeading: true,
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
      body: contentLoading
          ? loadderWidget()
          : loading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loadderWidget(),
                    const SizedBox(height: 10),
                    TextComp(text: "Deleting"),
                  ],
                )
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("groups")
                      .doc(widget.groupInfo.groupId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loadderWidget();
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
                                      memberCount: singlegroupData
                                          .groupMember.length
                                          .toString()),

                                  const SizedBox(height: 30),

                                  Container(
                                    color: AppColors.whiteColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
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
                                                          groupData:
                                                              singlegroupData,
                                                          groupId: widget
                                                              .groupInfo
                                                              .groupId),
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
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemCount: singlegroupData
                                              .groupMember.length,
                                          itemBuilder: (context, index) {
                                            return emailProfile(
                                              email: singlegroupData
                                                  .groupMember[index]
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
                                    onPressed: () => confirmModel(
                                        context: context,
                                        confirmFunc: () => deleteGroup(),
                                        infoText: "Sure you want to delete ?"),
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
}
