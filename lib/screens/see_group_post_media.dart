// ignore_for_file: must_be_immutable, prefer_is_empty

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memoryapp/models/group_model.dart';
import 'package:memoryapp/models/post_model.dart';
import 'package:memoryapp/screens/file_download.dart';
import 'package:memoryapp/screens/post.dart';
import 'package:memoryapp/utils/app_assets.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/single_post.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/loadder_widget.dart';

class SingleGroupPostAndMediaScreen extends StatefulWidget {
  String groupId;
  GroupModel groupData;
  SingleGroupPostAndMediaScreen(
      {super.key, required this.groupId, required this.groupData});

  @override
  State<SingleGroupPostAndMediaScreen> createState() =>
      _SingleGroupPostAndMediaScreenState();
}

class _SingleGroupPostAndMediaScreenState
    extends State<SingleGroupPostAndMediaScreen> {
  List<String> tabsIcon = [
    AppAssets.timelineImg,
    AppAssets.gridImg,
  ];

  bool contentLoading = true;

  int selectedIndex = 0;

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostScreen(
                          canSelectGroup: false,
                          groupId: widget.groupId,
                          groupName: widget.groupData.groupName),
                    ));
              },
              icon: const Icon(
                Icons.add_circle,
                size: 30,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top grp name and date
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5, color: AppColors.lightGrey),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextComp(
                  text: DateFormat.yMMMMEEEEd()
                      .format(widget.groupData.createdAt),
                  fontweight: FontWeight.normal,
                  size: 15,
                ),
                const SizedBox(height: 3),
                TextComp(
                  text: widget.groupData.groupName,
                  size: 25,
                  fontweight: FontWeight.normal,
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // tabs content
          Container(
            padding: const EdgeInsets.only(bottom: 15),
            height: 45,
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: tabsIcon.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      contentLoading = true;
                    });
                    Timer(const Duration(seconds: 2), () {
                      setState(() {
                        contentLoading = false;
                      });
                    });
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: Image.asset(
                        tabsIcon[index],
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                        color: selectedIndex == index
                            ? Colors.blue.shade400
                            : AppColors.greyColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          contentLoading
              ? Expanded(child: loadderWidget())
              : Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("allposts")
                        .where("groupId", isEqualTo: widget.groupId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadderWidget();
                      }

                      // if no data is in collection
                      if (snapshot.data!.docs.length == 0) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextComp(
                              text: "Welcome, No post Till now create some!",
                              align: TextAlign.center,
                              size: 20,
                              fontweight: FontWeight.normal,
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        var data = snapshot.data!.docs;
                        List<PostModel> allposts = [];
                        List<String> postIds = [];
                        for (var doc in data) {
                          allposts.add(PostModel.fromMap(doc.data()));
                          postIds.add(doc.id);
                        }

                        return selectedIndex == 0

                            // post components
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: allposts.length,
                                itemBuilder: (context, index) {
                                  return SinglePostComp(
                                    postData: allposts[index],
                                    postId: postIds[index],
                                    groupId: widget.groupId,
                                  );
                                },
                              )
                            :

                            // media components
                            GridView.builder(
                                padding: const EdgeInsets.all(10),
                                physics: const ClampingScrollPhysics(),
                                itemCount: allposts.length,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        mainAxisExtent: 120,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 10),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FileDownloadScreen(
                                                    url: allposts[index]
                                                        .postImage),
                                          ));
                                    },
                                    child: Image.network(
                                      allposts[index].postImage,
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              );
                      }
                      return Center(
                          child: TextComp(text: "Something went wrong!"));
                    },
                  ),
                )

          // realtime post fetch
        ],
      ),
    );
  }
}
