// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/fb_firestore.dart';
import 'package:memoryapp/models/post_model.dart';
import 'package:memoryapp/models/user_model.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/screens/comment.dart';
import 'package:memoryapp/screens/file_download.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SinglePostComp extends StatefulWidget {
  PostModel postData;
  String postId;
  String groupId;

  SinglePostComp(
      {super.key,
      required this.postData,
      required this.postId,
      required this.groupId});

  @override
  State<SinglePostComp> createState() => _SinglePostCompState();
}

class _SinglePostCompState extends State<SinglePostComp> {
  likePost() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var user = userProvider.user;

    var likesArry = widget.postData.likes;
    var isLikedAlready = likesArry.contains(user.id);

    if (isLikedAlready) {
      likesArry.remove(user.id);
      likeFbPost(
          data: {"likes": likesArry}, context: context, docId: widget.postId);
    } else {
      likesArry.add(user.id);
      likeFbPost(
          data: {"likes": likesArry}, context: context, docId: widget.postId);
    }

    // print(isLikedAlready);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top profile section
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(widget.postData.posterId)
                .snapshots(),
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }

              if (snapshot.hasData) {
                // UserModel userData;
                var data = snapshot.data!.data() as Map<String, dynamic>;
                UserModel userData = UserModel.fromMap(data);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          userData.profilePic,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextComp(
                            text: userData.username,
                            size: 14,
                          ),
                          TextComp(
                            text: "1h",
                            color: AppColors.greyColor,
                            fontweight: FontWeight.normal,
                            size: 11,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return TextComp(text: "No Data");
            },
          ),

          // post text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextComp(
              text: widget.postData.description,
              fontweight: FontWeight.normal,
              size: 16,
              // color: AppColors.greyColor,
            ),
          ),

          const SizedBox(height: 5),

          // post image
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FileDownloadScreen(url: widget.postData.postImage),
                  ));
            },
            child: Image.network(
              widget.postData.postImage,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 15),

          // like/comment/share icon container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextComp(
                    text: "${widget.postData.likes.length} Like",
                    size: 14,
                    fontweight: FontWeight.normal,
                  ),
                ),
                InkWell(
                  onTap: () => likePost(),
                  child: Icon(
                    Icons.favorite,
                    size: 22,
                    color: widget.postData.likes
                            .contains(FirebaseAuth.instance.currentUser!.uid)
                        ? Colors.red
                        : AppColors.black,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(
                            postId: widget.postId,
                            groupId: widget.groupId,
                          ),
                        ));
                  },
                  child: const Icon(
                    Icons.message,
                    size: 22,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
