import 'package:flutter/material.dart';
import 'package:memoryapp/screens/group/create_group.dart';
import 'package:memoryapp/screens/group/single_group_details.dart';
import 'package:memoryapp/screens/profile.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/single_post.dart';
import 'package:memoryapp/widgets/single_group.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                onPressed: () {},
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.appbarColor,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, ProfileScreen.routeName);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.whiteColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextComp(
                              text: "Jahidul Islam",
                              color: Colors.white,
                              fontweight: FontWeight.bold,
                            ),
                            TextComp(
                              text: "JahidulIslam@gmail.com",
                              color: Colors.white,
                              fontweight: FontWeight.normal,
                              size: 15,
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
