// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/fb_firestore.dart';
import 'package:memoryapp/firebase/fb_storage.dart';
import 'package:memoryapp/models/group_model.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/screens/home.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/simple_text_input.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class CreateGroupScreen extends StatefulWidget {
  static const routeName = "CreateGroupScreen";
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  File? _image;
  bool loading = false;
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupMemberEmailController = TextEditingController();
  TextEditingController groupTagController = TextEditingController();
  bool next = false;

  // list
  List<String> friendEmails = [];

  getImage() async {
    try {
      var tempImg = await pickImage();

      setState(() {
        _image = tempImg;
      });
    } catch (e) {
      return alertUser(context: context, alertText: "error when getting image");
    }
  }

  createGroup() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    if (_image == null ||
        groupNameController.text.isEmpty ||
        friendEmails.isEmpty) {
      return alertUser(context: context, alertText: "Fill all the field's!");
    }

    setState(() {
      loading = true;
    });

// adding user id to groupmember
    friendEmails.add(user.email);

// image upload process to fb bucket!!
    String fileName = p.basename(_image!.path);
    String imagePath = 'groupProfilePic/${DateTime.now()}$fileName';

    try {
      var url = await uploadFile(
          image: _image!, imagePath: imagePath, context: context);

      var groupData = GroupModel(
          groupProfilePic: url,
          groupName: groupNameController.text,
          groupMember: friendEmails,
          createdAt: DateTime.now(),
          adminId: user.id,
          creatorName: user.username,
          notificationCounter: friendEmails.length - 1);

      await addNewGroup(
          data: groupData.toMap(), context: context, emailList: friendEmails);

      setState(() {
        loading = false;
      });
      return callBackAlert(
        context: context,
        alertText: "Group created go back home!",
        onPressed: () {
          Navigator.pushNamed(context, HomeScreen.routeName);
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

// additem to list
  addItemToList() {
    if (groupMemberEmailController.text.isEmpty ||
        !groupMemberEmailController.text.contains("@gmail.com")) {
      return alertUser(
          context: context, alertText: "Empty or wrong email format!");
    }
    setState(() {
      friendEmails.add(groupMemberEmailController.text);
      groupMemberEmailController.clear();
    });
  }

// remove item from list
  removeItem(int index) {
    setState(() {
      friendEmails.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: TextComp(
          text: "Create Group",
          color: AppColors.whiteColor,
          size: 20,
        ),
        actions: [
          next
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      next = !next;
                    });
                  },
                  icon: const Icon(Icons.close))
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            next
                ? Column(
                    children: [
                      // friends email component
                      friendEmails.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                height: 160,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.lightGrey,
                                ),
                                child: GridView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: friendEmails.length,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent:
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                          mainAxisExtent: 40,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 10),
                                  itemBuilder: (context, index) {
                                    return showCaseItemComp(
                                        itemText: friendEmails[index],
                                        onTap: () => removeItem(index));
                                  },
                                ),
                              ),
                            )
                          : Container(),

                      // group member
                      multipleAddInputComp(
                        controller: groupMemberEmailController,
                        hintText: "group members email",
                        onPressed: () => addItemToList(),
                      ),

                      const SizedBox(height: 30),

                      // lodder component
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: sendinglodingComp(
                          loading: loading,
                          loadderText: "Creating group wait...",
                          btnText: "Create Group",
                          onPressed: () => createGroup(),
                        ),
                      ),
                    ],
                  )
                :

                // image and group name

                Column(
                    children: [
                      // group image
                      imagePickerPlaceholderComp(
                          onTap: getImage, image: _image),

                      const SizedBox(height: 10),
                      // groupname
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: SimpleTextInput(
                          controller: groupNameController,
                          hintText: "group name",
                        ),
                      ),
                      const SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          text: "Next",
                          onPressed: () {
                            if (groupNameController.text.isEmpty ||
                                _image == null) {
                              return alertUser(
                                  context: context,
                                  alertText: "Add Group Image and Name");
                            }

                            setState(() {
                              next = !next;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
