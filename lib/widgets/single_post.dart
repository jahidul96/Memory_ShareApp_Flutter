// ignore_for_file: must_be_immutable, prefer_final_fields

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  PageController _pageController = PageController();

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
                        child: CachedNetworkImage(
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          imageUrl: userData.profilePic,
                          placeholder: (context, url) => const Icon(
                            Icons.person,
                            size: 25,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error, size: 25),
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
                            text: timeago.format(widget.postData.postedAt,
                                locale: 'en_short'),
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

          // post image with indicator
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 250,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.postData.postImages.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FileDownloadScreen(
                                  url: widget.postData.postImages[index]),
                            ));
                      },
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        fit: BoxFit.cover,
                        imageUrl: widget.postData.postImages[index],
                        placeholder: (context, url) => const Center(
                          child: Icon(
                            Icons.image,
                            size: 150,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, size: 150),
                      ),
                    );
                  },
                ),
              ),
              widget.postData.postImages.length == 1
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: widget.postData.postImages.length,
                        axisDirection: Axis.horizontal,
                        effect: SlideEffect(
                            spacing: 8.0,
                            radius: 10,
                            dotWidth: 10.0,
                            dotHeight: 10.0,
                            paintStyle: PaintingStyle.stroke,
                            strokeWidth: 1.5,
                            dotColor: Colors.grey,
                            activeDotColor: AppColors.appbarColor),
                      ),
                    )
            ],
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
