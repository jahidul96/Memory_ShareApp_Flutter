// ignore_for_file: must_be_immutable, use_build_context_synchronously, depend_on_referenced_packages, avoid_print, unnecessary_null_comparison, prefer_is_empty

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memoryapp/firebase/fb_firestore.dart';
import 'package:memoryapp/firebase/fb_storage.dart';
import 'package:memoryapp/models/post_model.dart';
import 'package:memoryapp/models/group_info.dart';
import 'package:memoryapp/models/simple_models.dart';
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
  List<File>? _images = [];

  bool loading = false;
  TextEditingController postTagController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  GroupInfo selectedGroup = GroupInfo(
      groupId: "",
      groupName: "",
      groupProfilePic: "",
      adminId: "",
      notificationCounter: 0);

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
      if (_images!.isEmpty == null || descTextController.text.isEmpty) {
        return alertUser(context: context, alertText: "Fill all the field's");
      }
    } else {
      if (_images!.isEmpty ||
          selectedGroup.groupName == " " ||
          descTextController.text.isEmpty) {
        return alertUser(context: context, alertText: "Fill all the field's");
      }
    }

    setState(() {
      loading = true;
    });

    List<String> postImages = [];

    try {
      for (var element in _images!) {
        // image upload process to fb bucket!!
        String fileName = p.basename(element.path);
        String imagePath = 'groupProfilePic/${DateTime.now()}$fileName';
        var url = await uploadFile(
            image: element, imagePath: imagePath, context: context);

        postImages.add(url);
      }

      var postData = PostModel(
        postImages: postImages,
        description: descTextController.text,
        groupId: "",
        postedAt: DateTime.now(),
        groupName: "",
        likes: [],
        posterId: user.id,
      );

      var notificationVal =
          GroupNotificationModel(name: user.username, type: "post");

      if (widget.canSelectGroup) {
        postData.groupId = selectedGroup.groupId;
        postData.groupName = selectedGroup.groupName;

        addPost(data: postData.toMap(), context: context);
        addNotification(selectedGroup.groupId, notificationVal.toMap());
        setState(() {
          loading = false;
        });
        callBackAlert(
          context: context,
          alertText: "Post done!",
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        );
      } else {
        postData.groupId = widget.groupId!;
        postData.groupName = widget.groupName!;
        addPost(data: postData.toMap(), context: context);
        addNotification(widget.groupId!, notificationVal.toMap());
        setState(() {
          loading = false;
        });

        callBackAlert(
          context: context,
          alertText: "Post done!",
          onPressed: () {
            // Navigator.pushNamed(context, HomeScreen.routeName);
            Navigator.pop(context);
            descTextController.clear();
            setState(() {
              _images = [];
            });
          },
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      return alertUser(
          context: context, alertText: "Error while uploading profile pic");
    }
  }

// select multi images
  Future pickMultiImages() async {
    try {
      final List<XFile> images = await picker.pickMultiImage(imageQuality: 25);

      if (images.length > 4) {
        return alertUser(
            context: context, alertText: "you can add 4 images only");
      }

      setState(() {
        _images = images.map((XFile xfile) => File(xfile.path)).toList();
      });
    } catch (e) {
      print(e);
    }
  }

// select multi images
  Future addNewImages() async {
    try {
      final List<XFile> images = await picker.pickMultiImage(imageQuality: 50);

      if (_images!.length + images.length > 4) {
        return alertUser(
            context: context, alertText: "you can add 4 images only");
      }

      var tempImages = images.map((XFile xfile) => File(xfile.path)).toList();
      for (var element in tempImages) {
        setState(() {
          _images!.add(element);
        });
      }
    } catch (e) {
      print(e);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // multi image pick from gallery

            _images!.length == 0
                ? Center(
                    child: InkWell(
                      onTap: () => pickMultiImages(),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.appbarColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 35,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 80,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              MediaQuery.of(context).size.width / 4,
                          mainAxisExtent: 80,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10),
                      itemCount: _images!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _images!.removeAt(index);
                            });
                          },
                          child: Stack(
                            children: [
                              Image.file(
                                _images![index],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 0,
                                child: singlePhotoRemoveIconComp(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
            _images!.length == 0
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _images = [];
                            });
                          },
                          child: iconContainer(icon: Icons.close),
                        ),
                        const SizedBox(width: 10),
                        _images!.length < 4
                            ? InkWell(
                                onTap: () => addNewImages(),
                                child: iconContainer(icon: Icons.add),
                              )
                            : Container(),
                      ],
                    ),
                  ),

            const SizedBox(height: 20),

            widget.canSelectGroup
                ?
                // select group from dropdown
                selectGroup()
                : Container(),

            widget.canSelectGroup
                ? const SizedBox(height: 30)
                : const SizedBox(height: 0),

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

  Widget singlePhotoRemoveIconComp() => Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
          child: Icon(
            Icons.remove,
            size: 15,
            color: AppColors.buttonColor,
          ),
        ),
      );

  Widget iconContainer({required IconData icon}) => Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 30,
          ),
        ),
      );
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
                        return InkWell(
                          onTap: () => getGroup(widget.groupList![index]),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            color: AppColors.whiteColor,
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: TextComp(
                                        text: widget.groupList![index].groupName
                                            .substring(0, 1)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextComp(
                                      text: widget.groupList![index].groupName
                                                  .length >
                                              20
                                          ? '${widget.groupList![index].groupName.substring(0, 20)}...'
                                          : widget.groupList![index].groupName),
                                ),
                              ],
                            ),
                          ),
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
