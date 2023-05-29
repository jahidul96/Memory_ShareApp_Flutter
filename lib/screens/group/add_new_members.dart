// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/fb_firestore.dart';
import 'package:memoryapp/models/group_model.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class AddNewMemberScreen extends StatefulWidget {
  GroupModel groupData;
  String groupId;
  AddNewMemberScreen(
      {super.key, required this.groupData, required this.groupId});

  @override
  State<AddNewMemberScreen> createState() => _AddNewMemberScreenState();
}

class _AddNewMemberScreenState extends State<AddNewMemberScreen> {
  TextEditingController groupMemberEmailController = TextEditingController();
  List<String> friendEmails = [];

  // additem to list
  addItemToList() {
    var groupMembers = widget.groupData.groupMember;

    if (groupMemberEmailController.text.isEmpty ||
        !groupMemberEmailController.text.contains("@gmail.com")) {
      return alertUser(
          context: context, alertText: "Empty or wrong email format!");
    }

    if (groupMembers.contains(groupMemberEmailController.text)) {
      return alertUser(
          context: context, alertText: "user already added to group");
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

  // addToGroup

  addToGroup() {
    if (friendEmails.isEmpty) {
      return alertUser(context: context, alertText: "add new emails!");
    }
    List<String> groupMembers = widget.groupData.groupMember;

    for (var element in friendEmails) {
      groupMembers.add(element);
    }

    editGroupFb(
        data: {"groupMember": groupMembers},
        context: context,
        docId: widget.groupId);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: TextComp(
          text: "Add Member",
          color: AppColors.whiteColor,
          size: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // friends email component
            friendEmails.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:
                                MediaQuery.of(context).size.width / 2,
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomButton(
                text: "Add To Db",
                onPressed: () => addToGroup(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
