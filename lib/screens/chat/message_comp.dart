// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memoryapp/models/message_model.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageComp extends StatelessWidget {
  MessageModel messageModel;

  MessageComp({
    super.key,
    required this.messageModel,
  });
  FirebaseAuth authUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return messageModel.text == ""
        ?

        // image content
        Column(
            crossAxisAlignment:
                messageModel.senderId == authUser.currentUser!.uid
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              messageModel.senderId != authUser.currentUser!.uid
                  ?
                  // friend mes with profile img!
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        profilePic(),
                        const SizedBox(width: 8),
                        fileComp(context),
                      ],
                    )
                  : fileComp(context),
            ],
          )
        :

        // text content
        Column(
            crossAxisAlignment:
                messageModel.senderId == authUser.currentUser!.uid
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              messageModel.senderId != authUser.currentUser!.uid
                  ?
                  // friend msg with profile img!
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        profilePic(),
                        const SizedBox(width: 8),
                        messageTextContent(context),
                      ],
                    )
                  : messageTextContent(context),
            ],
          );
  }

// friends profile pic
  Widget profilePic() => ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          width: 25,
          height: 25,
          fit: BoxFit.cover,
          imageUrl: messageModel.senderProfilePic,
          placeholder: (context, url) => Center(
            child: Icon(
              Icons.image,
              size: 25,
              color: AppColors.appbarColor,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            color: AppColors.whiteColor,
          ),
        ),
      );

// text content comp
  Widget messageTextContent(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: messageModel.senderId == authUser.currentUser!.uid
              ? AppColors.appbarColor
              : AppColors.frndMsgBackGround,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(
          minHeight: 35,
          minWidth: 62,
          maxHeight: double.infinity,
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: messageModel.text.length > 80 ? 12 : 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: TextComp(
                  text: messageModel.text,
                  color: messageModel.senderId == authUser.currentUser!.uid
                      ? AppColors.whiteColor
                      : AppColors.black,
                  size: 14,
                  fontweight: FontWeight.normal,
                ),
              ),
              TextComp(
                text:
                    timeago.format(messageModel.createdAt, locale: 'en_short'),
                size: 9,
                fontweight: FontWeight.normal,
                color: messageModel.senderId == authUser.currentUser!.uid
                    ? AppColors.whiteColor
                    : AppColors.black,
              ),
            ],
          ),
        ),
      );

// file show content
  Widget fileComp(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: messageModel.senderId == authUser.currentUser!.uid
              ? AppColors.appbarColor
              : AppColors.frndMsgBackGround,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(
          minHeight: 100,
          minWidth: MediaQuery.of(context).size.width * 0.5,
          maxHeight: 110,
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: 80,
                    fit: BoxFit.cover,
                    imageUrl: messageModel.imgUrl,
                    placeholder: (context, url) => Center(
                      child: Icon(
                        Icons.image,
                        size: 60,
                        color:
                            messageModel.senderId == authUser.currentUser!.uid
                                ? AppColors.whiteColor
                                : AppColors.black,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
              Text(
                timeago.format(messageModel.createdAt, locale: 'en_short'),
                style: TextStyle(
                  color: messageModel.senderId == authUser.currentUser!.uid
                      ? AppColors.whiteColor
                      : AppColors.greyColor,
                  fontSize: 10,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      );
}
