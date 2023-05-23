import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class SingleGroupDeatail extends StatefulWidget {
  static const routeName = "SingleGroupDeatail";
  const SingleGroupDeatail({super.key});

  @override
  State<SingleGroupDeatail> createState() => _SingleGroupDeatailState();
}

class _SingleGroupDeatailState extends State<SingleGroupDeatail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // top container
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // group name and member number
                  groupNameAndMemberCounter(),

                  const SizedBox(height: 30),

                  Container(
                    color: AppColors.whiteColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: Column(
                      children: [
                        // add members button
                        addMemberBtn(),

                        const SizedBox(height: 15),
                        const Divider(
                          height: 5,
                        ),
                        // members email profile
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return emailProfile();
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // delete group btn

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: "Delete group",
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
