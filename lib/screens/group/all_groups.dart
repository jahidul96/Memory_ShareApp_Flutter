// ignore_for_file: prefer_is_empty

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memoryapp/models/group_model.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/loadder_widget.dart';
import 'package:memoryapp/widgets/single_group.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AllGroupsScreen extends StatefulWidget {
  const AllGroupsScreen({super.key});

  @override
  State<AllGroupsScreen> createState() => _AllGroupsScreenState();
}

class _AllGroupsScreenState extends State<AllGroupsScreen> {
  bool dataLoading = true;

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        dataLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: AppColors.appbarColor,
        title: TextComp(
          text: "Groups",
          color: AppColors.whiteColor,
          size: 22,
        ),
      ),
      body: dataLoading
          ? loadderWidget()
          : Consumer<UserProvider>(
              builder: (context, userData, child) => StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("groups")
                    .where("groupMember", arrayContains: userData.user.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadderWidget();
                  }

                  if (snapshot.data!.docs.length == 0) {
                    return Center(
                      child: TextComp(text: "No group till now"),
                    );
                  }

                  if (snapshot.hasData) {
                    var data = snapshot.data!.docs;
                    List<GroupModel> myGroupList = [];
                    List myGroupIds = [];

                    // injecting data and group id to list
                    for (var element in data) {
                      myGroupList.add(
                        GroupModel.fromMap(element.data()),
                      );
                      myGroupIds.add(element.id);
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // grave group name and id

                        // return singleGroupComp
                        return SingleGroup(
                          groupData: myGroupList[index],
                          groupId: myGroupIds[index],
                        );
                      },
                    );
                  }
                  return Center(
                    child: TextComp(
                      text: "No Group Till Now",
                      color: AppColors.black,
                      size: 20,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
