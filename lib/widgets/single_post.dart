// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:memoryapp/models/post_model.dart';
import 'package:memoryapp/models/user_model.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SinglePostComp extends StatelessWidget {
  PostModel postData;
  String postId;

  SinglePostComp({super.key, required this.postData, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top profile section
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(postData.posterId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

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
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextComp(text: userData.username),
                          const SizedBox(height: 2),
                          TextComp(
                            text: "1h",
                            color: AppColors.greyColor,
                            fontweight: FontWeight.normal,
                            size: 13,
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
              text: postData.description,
              fontweight: FontWeight.normal,
              size: 16,
              // color: AppColors.greyColor,
            ),
          ),

          const SizedBox(height: 5),

          // post image
          Image.network(
            postData.postImage,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 10),
          // post tag
          Container(
            height: postData.tags.length > 3 ? 60 : 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 110, mainAxisExtent: 35),
              itemCount: postData.tags.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: const BoxDecoration(
                      color: AppColors.lightGrey,
                    ),
                    child: Center(
                      child: TextComp(
                        text: postData.tags[index],
                        size: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // like/comment/share icon container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconComp(
                  icon: Icons.favorite,
                  onPressed: () {},
                ),
                iconComp(
                  icon: Icons.message,
                  onPressed: () {},
                ),
                iconComp(
                  icon: Icons.ios_share,
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget iconComp({
    required IconData icon,
    required Function()? onPressed,
  }) =>
      Container(
        width: 100,
        height: 35,
        decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                size: 20,
              )),
        ),
      );
}
