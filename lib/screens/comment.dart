// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:memoryapp/models/user_model.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  String postId;
  CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        title: TextComp(
          text: "Comments",
          color: AppColors.whiteColor,
          size: 20,
        ),
        automaticallyImplyLeading: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          var user = userProvider.user;
          return Column(
            children: [
              Expanded(child: Container()),

              // bottom comment content
              bottomCommentComp(user: user),
            ],
          );
        },
      ),
    );
  }

  Widget bottomCommentComp({required UserModel user}) => Container(
        width: double.infinity,
        height: 60,
        color: AppColors.lightGrey,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                user.profilePic,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: commentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "comment",
                  hintStyle: TextStyle(fontSize: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: "Add",
              onPressed: () {},
              width: 70,
              height: 40,
              textSize: 15,
            )
          ],
        ),
      );
}
