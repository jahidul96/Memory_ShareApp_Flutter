import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class SinglePostComp extends StatelessWidget {
  const SinglePostComp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // top profile section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 35,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextComp(text: "Jahidul Islam"),
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
          ),

          // post text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextComp(
              text:
                  "This is just a demo post text! we are trying to build a memory sharing app",
              fontweight: FontWeight.normal,
              size: 16,
              // color: AppColors.greyColor,
            ),
          ),

          // post image
          Container(
            height: 200,
            width: double.infinity,
            color: AppColors.appbarColor,
            child: Center(
              child: TextComp(
                text: "Post Media",
                color: AppColors.whiteColor,
                size: 25,
              ),
            ),
          ),

          // post tag
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: const BoxDecoration(
                    color: AppColors.lightGrey,
                  ),
                  child: TextComp(text: "#Friends"),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: const BoxDecoration(
                    color: AppColors.lightGrey,
                  ),
                  child: TextComp(text: "#Friends"),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: const BoxDecoration(
                    color: AppColors.lightGrey,
                  ),
                  child: TextComp(text: "#Friends"),
                ),
              ],
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
                Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.thumb_up,
                          size: 20,
                        )),
                  ),
                ),
                Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.message,
                          size: 20,
                        )),
                  ),
                ),
                Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          size: 20,
                        )),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
