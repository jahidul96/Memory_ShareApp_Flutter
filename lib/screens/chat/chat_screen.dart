// ignore_for_file: must_be_immutable, prefer_is_empty, depend_on_referenced_packages, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/chat_features.dart';
import 'package:memoryapp/firebase/fb_storage.dart';
import 'package:memoryapp/models/message_model.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/utils/app_assets.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/screens/chat/chat_widets.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memoryapp/screens/chat/message_comp.dart';
import 'package:memoryapp/widgets/loadder_widget.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class ChatScreen extends StatefulWidget {
  bool isGroupChat;
  String groupProfilePic;
  String docId;
  ChatScreen({
    Key? key,
    required this.isGroupChat,
    required this.groupProfilePic,
    required this.docId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textController = TextEditingController();
  File? _image;
  bool dataLoading = true;

  // image grave from gallery
  Future pickFromGallery() async {
    var tempImg = await pickImage();
    setState(() {
      _image = tempImg;
    });
  }

  sendChat() async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var msgData = MessageModel(
        text: "",
        senderId: user.user.id,
        createdAt: DateTime.now(),
        imgUrl: "",
        senderProfilePic: user.user.profilePic,
        senderUsername: user.user.username);

    if (_image != null) {
      // image upload process to fb bucket!!
      String fileName = p.basename(_image!.path);
      String imagePath = 'messageImages/${DateTime.now()}$fileName';

      try {
        var url = await uploadFile(
            image: _image, imagePath: imagePath, context: context);

        msgData.imgUrl = url;

        groupChat(msgData: msgData, groupId: widget.docId);
        setState(() {
          _image = null;
        });
      } catch (e) {
        print(e);
      }
    } else {
      msgData.text = textController.text;
      groupChat(msgData: msgData, groupId: widget.docId);
      textController.clear();
    }
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        dataLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: AppColors.appbarColor,
        titleSpacing: 0,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            widget.groupProfilePic,
            width: 35,
            height: 35,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssets.chatBackImg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dataLoading
                ? Expanded(child: loadderWidget())
                : Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("groups")
                          .doc(widget.docId)
                          .collection("messages")
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        // loading state
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }

                        if (snapshot.data!.docs.length == 0) {
                          return Center(
                            child: TextComp(
                              text: "Start Conversation",
                              color: Colors.black,
                              fontweight: FontWeight.normal,
                            ),
                          );
                        }

                        // data content
                        if (snapshot.hasData) {
                          return ListView.builder(
                            reverse: true,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              // data store variables

                              final data = snapshot.data!.docs;
                              List<MessageModel> messages = [];

                              for (var element in data) {
                                var msg = MessageModel.fromMap(element.data());
                                messages.add(msg);
                              }

                              var singleMsg = messages[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 3),
                                child: MessageComp(
                                  messageModel: singleMsg,
                                ),
                              );
                            },
                          );
                        }

                        // no data content
                        return Center(
                          child: TextComp(
                            text: "Start Conversation",
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
            _image != null
                ? fileSendComp(
                    image: _image!,
                    send: () => sendChat(),
                    clear: () {
                      setState(() {
                        _image = null;
                      });
                    },
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                    child: chatBottomComp(
                        onTap: () => sendChat(),
                        pickImage: pickFromGallery,
                        textController: textController),
                  ),
          ],
        ),
      ),
    );
  }
}
