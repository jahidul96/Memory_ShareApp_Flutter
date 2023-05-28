// ignore_for_file: must_be_immutable, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/fb_firestore.dart';
import 'package:memoryapp/models/comment_model.dart';
import 'package:memoryapp/models/user_model.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentScreen extends StatefulWidget {
  String postId;
  CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();

  commentPost(UserModel user) {
    if (commentController.text.isEmpty) {
      return alertUser(context: context, alertText: "Add a Note");
    }

    var data = CommentModel(
        commentterId: user.id,
        commentText: commentController.text,
        commentTime: DateTime.now());

    addCommentFb(
        data: data.toMap(),
        context: context,
        docId: widget.postId,
        errorText: "Firestore error");

    commentController.clear();
  }

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
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("allposts")
                      .doc(widget.postId)
                      .collection("comments")
                      .orderBy("commentTime", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.data!.docs.length == 0) {
                      return Center(
                        child: TextComp(text: "No Comment Till Now"),
                      );
                    }

                    if (snapshot.hasData) {
                      List<CommentModel> comments = [];
                      List<String> commentsId = [];
                      var data = snapshot.data!.docs;

                      for (var element in data) {
                        comments.add(CommentModel.fromMap(element.data()));
                        commentsId.add(element.id);
                      }

                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: commentComp(
                                commentData: comments[index],
                                commentId: commentsId[index]),
                          );
                        },
                      );
                    }
                    return Center(
                      child: TextComp(text: "No Comment Till Now"),
                    );
                  },
                ),
              ),

              // bottom comment content
              bottomCommentComp(user: user),
            ],
          );
        },
      ),
    );
  }

  Widget commentComp({
    required CommentModel commentData,
    required String commentId,
  }) =>
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(commentData.commentterId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            UserModel userData = UserModel.fromMap(data);
            return Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          userData.profilePic,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: TextComp(text: userData.username)),
                              TextComp(
                                text: "1h",
                                fontweight: FontWeight.normal,
                                size: 13,
                              )
                            ],
                          ),
                          TextComp(
                            text: commentData.commentText,
                            fontweight: FontWeight.normal,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }

          return Center(
            child: Container(),
          );
        },
      );

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
              onPressed: () => commentPost(user),
              width: 70,
              height: 40,
              textSize: 15,
            )
          ],
        ),
      );
}
