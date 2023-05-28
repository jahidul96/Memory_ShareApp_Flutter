// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:memoryapp/models/group_model.dart';
import 'package:memoryapp/models/post_model.dart';
import 'package:memoryapp/models/simple_models.dart';
import 'package:memoryapp/models/user_model.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/screens/group/create_group.dart';
import 'package:memoryapp/screens/group/single_group_details.dart';
import 'package:memoryapp/screens/post.dart';
import 'package:memoryapp/screens/profile/profile.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/single_post.dart';
import 'package:memoryapp/widgets/single_group.dart';
import 'package:memoryapp/firebase/fb_firestore.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel userData =
      UserModel(profilePic: "", id: "", email: "", username: "");

  List<GroupInfo> groupList = [];

  int groupIndex = 0;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var data = await getMyData();
      userProvider.setUser(UserModel.fromMap(data));

      var snapshots = await FirebaseFirestore.instance
          .collection("groups")
          .where("groupMember", arrayContains: data["email"])
          .get();

      for (var element in snapshots.docs) {
        groupList.add(
          GroupInfo(
              adminId: element.data()["adminId"],
              groupId: element.id,
              groupName: element.data()["groupName"],
              groupProfilePic: element.data()["groupProfilePic"]),
        );
      }
      setState(() {
        userData = UserModel.fromMap(data);
      });
    } catch (e) {
      // print("error is occured");
      alertUser(
          context: context,
          alertText: "some error when fetching user infomation");
    }
  }

  // getMyGroups(){
  //   FirebaseFirestore.instance.collection("groups").where(field)
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appbar content
        appBar: AppBar(
          backgroundColor: AppColors.appbarColor,
          elevation: 0,
          title: TextComp(
            text: groupList.isEmpty
                ? "Memory App"
                : groupList[groupIndex].groupName,
            size: 22,
            color: AppColors.whiteColor,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SingleGroupDeatail.routeName);
              },
              icon: const Icon(
                Icons.person,
                size: 30,
              ),
            )
          ],
        ),

        // body content
        body: Column(
          children: [
            // Tabs Bar
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.lightGrey, width: 1),
                ),
              ),
              height: 55,
              width: double.infinity,
              child: const TabBar(
                dividerColor: AppColors.black,
                labelColor: AppColors.black,
                indicatorWeight: 2.0,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: AppColors.black,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                tabs: [
                  Text("Timeline"),
                  Text("Groups"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // timeline tab content
                  groupList.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("allposts")
                              .where("groupId",
                                  isEqualTo: groupList[groupIndex].groupId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.data!.docs.length == 0) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextComp(
                                    text:
                                        "Welcome, No post Till now create some!",
                                    align: TextAlign.center,
                                    size: 22,
                                    fontweight: FontWeight.normal,
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasData) {
                              List<PostModel> selectedGroupPosts = [];
                              var selectedGroupIds = [];
                              var data = snapshot.data!.docs;

                              for (var element in data) {
                                selectedGroupPosts
                                    .add(PostModel.fromMap(element.data()));
                                selectedGroupIds.add(element.id);
                              }

                              return ListView.builder(
                                itemCount: selectedGroupPosts.length,
                                itemBuilder: (context, index) {
                                  return SinglePostComp(
                                    postData: selectedGroupPosts[index],
                                    postId: selectedGroupIds[index],
                                  );
                                },
                              );
                            }
                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextComp(
                                  text:
                                      "Welcome, No post Till now create some!",
                                  align: TextAlign.center,
                                  size: 20,
                                  fontweight: FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),

                  // groups tab content
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("groups")
                        .where("groupMember", arrayContains: userData.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
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
                ],
              ),
            ),

            // add memory button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Add Memory",
                height: 60,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostScreen(groupList: groupList),
                      ));
                },
              ),
            )
          ],
        ),

        // drawer section content
        drawer: Drawer(
          child: Column(
            // padding: EdgeInsets.zero,
            children: [
              // user profile section
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.appbarColor,
                ),
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final user = userProvider.user;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: InkWell(
                        onTap: () {
                          Navigator.popAndPushNamed(
                              context, ProfileScreen.routeName);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // user image
                            user.profilePic != ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      user.profilePic,
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                    ))
                                : const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColors.whiteColor,
                                  ),
                            const SizedBox(width: 10),

                            // user name and email
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextComp(
                                    text: user.username == ""
                                        ? "Username"
                                        : user.username.length > 12
                                            ? "${user.username.substring(0, 12).toUpperCase()}..."
                                            : user.username.toUpperCase(),
                                    color: Colors.white,
                                    fontweight: FontWeight.bold,
                                    size: 15,
                                  ),
                                  TextComp(
                                    text: user.email == ""
                                        ? "user@email.com"
                                        : user.email.length > 20
                                            ? "${user.email.substring(0, 19)}..."
                                            : user.email,
                                    color: Colors.white,
                                    fontweight: FontWeight.normal,
                                    size: 13,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.settings,
                              color: AppColors.whiteColor,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    // create group btn
                    ListTile(
                      onTap: () {
                        Navigator.popAndPushNamed(
                            context, CreateGroupScreen.routeName);
                      },
                      leading: const Icon(
                        Icons.add,
                        size: 28,
                        color: AppColors.black,
                      ),
                      horizontalTitleGap: 0,
                      title: TextComp(
                        text: "Create Group",
                        fontweight: FontWeight.bold,
                        size: 18,
                      ),
                    ),

                    // group list

                    groupList.isEmpty
                        ? Container()
                        : Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: groupList.length,
                              itemBuilder: (context, index) {
                                return groupListTile(
                                  groupInfo: groupList[index],
                                  onTap: () {
                                    setState(() {
                                      groupIndex = index;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
