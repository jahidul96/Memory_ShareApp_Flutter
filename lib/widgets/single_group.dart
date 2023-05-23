import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class SingleGroup extends StatelessWidget {
  const SingleGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // group image
          Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
                color: AppColors.appbarColor,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: TextComp(
                text: "Group Image",
                color: AppColors.whiteColor,
              ),
            ),
          ),

          const SizedBox(width: 10),

// group right content

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextComp(text: "Group Name"),
                const SizedBox(height: 5),
                TextComp(text: "Creator Name"),
                const SizedBox(height: 5),
                TextComp(text: "#tags"),
                // Container(
                //   width: double.infinity,
                //   height: 60,
                //   // color: Colors.red,
                //   child: GridView.builder(
                //     itemCount: 3,
                //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                //         maxCrossAxisExtent: 80, mainAxisExtent: 30),
                //     itemBuilder: (context, index) {
                //       return TextComp(text: "#tags");
                //     },
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
