import 'package:flutter/material.dart';
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

class HomeScreen extends StatefulWidget {
  static const routeName = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel userData =
      UserModel(profilePic: "", id: "", email: "", username: "");

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
            text: "Memory App",
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
                indicatorWeight: 3.0,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: AppColors.black,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                tabs: [
                  Text("Timeline"),
                  Text("Groups"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                // timeline tab content
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const SinglePostComp();
                  },
                ),

                // groups tab content
                ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return const SingleGroup();
                  },
                ),
              ]),
            ),

            // add memory button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Add Memory",
                height: 60,
                onPressed: () {
                  Navigator.pushNamed(context, PostScreen.routeName);
                },
              ),
            )
          ],
        ),

        // drawer section content
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
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
              Column(
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

                  groupListTile(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
