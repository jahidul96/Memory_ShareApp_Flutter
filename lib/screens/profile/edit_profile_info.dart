// ignore_for_file: prefer_const_constructors_in_immutables, use_build_context_synchronously, depend_on_referenced_packages, must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/auth_fb.dart';
import 'package:memoryapp/firebase/fb_firestore.dart';
import 'package:memoryapp/firebase/fb_storage.dart';
import 'package:memoryapp/models/user_model.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class EditProfileInfo extends StatefulWidget {
  EditProfileInfo({
    super.key,
  });

  @override
  State<EditProfileInfo> createState() => _EditProfileInfoState();
}

class _EditProfileInfoState extends State<EditProfileInfo> {
  File? _image;
  TextEditingController usernameController = TextEditingController();
  bool loading = false;

// get image from user gallery
  getImage() async {
    try {
      var tempImg = await pickImage();
      setState(() {
        _image = tempImg;
      });
    } catch (e) {
      alertUser(context: context, alertText: "Image pick issue!");
    }
  }

// updateUserInfo function
  updateUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    if (_image == null) {
      return alertUser(
          context: context, alertText: "You have to add a new profile pic!");
    }

    setState(() {
      loading = true;
    });

// image upload process to fb bucket!!
    String fileName = p.basename(_image!.path);
    String imagePath = 'profileImages/${DateTime.now()}$fileName';

    try {
      var url = await uploadFile(
          image: _image!, imagePath: imagePath, context: context);

      var data = UserModel(
          profilePic: url,
          id: user.id,
          email: user.email,
          username: user.username);

      if (usernameController.text.isEmpty) {
        updateUserInfoFb(data: data.toMap(), context: context);
        userProvider.setUser(data);
      } else {
        data.username = usernameController.text;

        updateUserInfoFb(data: data.toMap(), context: context);
        userProvider.setUser(data);
      }
      setState(() {
        loading = false;
        _image = null;
        usernameController.clear();
      });
      return alertUser(
        context: context,
        alertText: "Update Succesfull",
      );
    } catch (e) {
      return alertUser(
          context: context, alertText: "Error while uploading profile pic");
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
            text: "Edit Info",
            color: AppColors.whiteColor,
            size: 20,
          ),
        ),
        body: Consumer<UserProvider>(
          builder: (context, userProviderValue, child) {
            var user = userProviderValue.user;
            return Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // get image
                  editImageComp(profilePic: user.profilePic),

                  const SizedBox(height: 20),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                        hintText: "your new user name",
                        hintStyle: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 30),

                  // lodder component
                  sendinglodingComp(
                    loading: loading,
                    loadderText: "Updating info wait",
                    btnText: "update",
                    onPressed: () => updateUserInfo(),
                  )
                ],
              ),
            );
          },
        ));
  }

  Widget editImageComp({
    required String profilePic,
  }) =>
      InkWell(
        onTap: getImage,
        child: Center(
          child: Column(
            children: [
              _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        _image!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        profilePic,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
              const SizedBox(height: 8),
              _image != null
                  ? TextComp(text: "You have added new one!")
                  : TextComp(text: "Click on photo to choose new one"),
            ],
          ),
        ),
      );
}
