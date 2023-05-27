// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:memoryapp/models/simple_models.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class PostScreen extends StatefulWidget {
  List<GroupNameAndId> groupList;
  static const routeName = "PostScreen";
  PostScreen({super.key, required this.groupList});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController tagsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: TextComp(
          text: "Create Post",
          color: AppColors.whiteColor,
          size: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // post image/video etc btn
            Center(
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: AppColors.appbarColor,
                      ),
                      child: const Icon(
                        Icons.folder,
                        color: AppColors.whiteColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextComp(
                      text: "Upload Img/Video/pdf/audio",
                      size: 14,
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // select group from dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyColor, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextComp(text: "Groups"),
                      const Icon(Icons.expand_more)
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // add tags
            multipleAddInputComp(
              controller: tagsController,
              hintText: "#tags",
              onPressed: () {},
            ),

            const SizedBox(height: 30),

// description input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.greyColor, width: 1)),
                child: const TextField(
                  // controller: textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(
                      fontSize: 18,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            //  post btn
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Post",
                onPressed: () {
                  for (var element in widget.groupList) {
                    print(element.groupId);
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
