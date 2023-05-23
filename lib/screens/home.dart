import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/custome_button.dart';
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
          backgroundColor: Colors.grey.shade900,
          elevation: 0,
          title: TextComp(
            text: "Memory App",
            size: 24,
            color: AppColors.whiteColor,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.person,
                  size: 30,
                ))
          ],
        ),
        body: Column(
          children: [
            // Tabs contents
            const SizedBox(
              height: 55,
              width: double.infinity,
              child: TabBar(
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
                    return SinglePostComp();
                  },
                ),

                // groups tab content
                ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return SingleGroup();
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
        drawer: Drawer(),
      ),
    );
  }
}
