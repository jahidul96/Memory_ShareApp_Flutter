// ignore_for_file: must_be_immutable, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/fb_firestore.dart';
import 'package:memoryapp/firebase/fb_storage.dart';
import 'package:memoryapp/models/post_model.dart';
import 'package:memoryapp/models/group_info.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/screens/home.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  List<GroupInfo>? groupList;
  bool canSelectGroup;
  String? groupId;
  String? groupName;
  static const routeName = "PostScreen";
  PostScreen(
      {super.key,
      this.groupList,
      required this.canSelectGroup,
      this.groupId,
      this.groupName});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  File? _image;
  bool loading = false;
  TextEditingController postTagController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  GroupInfo selectedGroup =
      GroupInfo(groupId: "", groupName: "", groupProfilePic: "", adminId: "");

  getImage() async {
    try {
      var tempImg = await pickImage();
      setState(() {
        _image = tempImg;
      });
    } catch (e) {
      return alertUser(
          context: context, alertText: "Error while image graving");
    }
  }

  getGroup(GroupInfo item) {
    setState(() {
      selectedGroup = item;
    });

    Navigator.pop(context);
  }

  // post data

  postData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (!widget.canSelectGroup) {
      if (_image == null || descTextController.text.isEmpty) {
        return alertUser(context: context, alertText: "Fill all the field's");
      } else {
        if (_image == null ||
            selectedGroup.groupName == " " ||
            descTextController.text.isEmpty) {
          return alertUser(context: context, alertText: "Fill all the field's");
        }
      }
    }

    setState(() {
      loading = true;
    });

    // image upload process to fb bucket!!
    String fileName = p.basename(_image!.path);
    String imagePath = 'groupProfilePic/${DateTime.now()}$fileName';

    try {
      var url = await uploadFile(
          image: _image!, imagePath: imagePath, context: context);

      var postData = PostModel(
        postImage: url,
        description: descTextController.text,
        groupId:
            widget.canSelectGroup ? selectedGroup.groupId : widget.groupId!,
        postedAt: DateTime.now(),
        groupName:
            widget.canSelectGroup ? selectedGroup.groupName : widget.groupName!,
        likes: [],
        posterId: user.id,
      );

      addPost(data: postData.toMap(), context: context);
      setState(() {
        loading = false;
      });

      widget.canSelectGroup
          ? callBackAlert(
              context: context,
              alertText: "Post done!",
              onPressed: () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
            )
          : callBackAlert(
              context: context,
              alertText: "Post done!",
              onPressed: () {
                // Navigator.pushNamed(context, HomeScreen.routeName);
                Navigator.pop(context);
                descTextController.clear();
                setState(() {
                  _image = null;
                });
              },
            );
    } catch (e) {
      setState(() {
        loading = false;
      });
      return alertUser(
          context: context, alertText: "Error while uploading profile pic");
    }
  }

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
            imagePickerPlaceholderComp(onTap: getImage, image: _image),
            // Center(
            //   child: InkWell(
            //     onTap: () {},
            //     child: Column(
            //       children: [
            //         Container(
            //           width: 70,
            //           height: 70,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(45),
            //             color: AppColors.appbarColor,
            //           ),
            //           child: const Icon(
            //             Icons.folder,
            //             color: AppColors.whiteColor,
            //             size: 30,
            //           ),
            //         ),
            //         const SizedBox(height: 6),
            //         TextComp(
            //           text: "Upload Img/Video/pdf/audio",
            //           size: 14,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            const SizedBox(height: 30),

            widget.canSelectGroup
                ?
                // select group from dropdown
                selectGroup()
                : Container(),

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
                child: TextField(
                  controller: descTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: sendinglodingComp(
                  loading: loading,
                  onPressed: () => postData(),
                  loadderText: "Posting wait...",
                  btnText: "Post"),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget selectGroup() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: TextComp(text: "Select a Group"),
                  content: SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemCount: widget.groupList!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () => getGroup(widget.groupList![index]),
                          title: TextComp(
                              text: widget.groupList![index].groupName),
                        );
                      },
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                      ),
                      child: TextComp(
                        text: "Close",
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 55,
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyColor, width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectedGroup.groupName == ""
                    ? TextComp(text: "Groups")
                    : TextComp(text: selectedGroup.groupName),
                const Icon(Icons.expand_more)
              ],
            ),
          ),
        ),
      );
}
