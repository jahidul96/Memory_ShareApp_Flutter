import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/text_comp.dart';

Widget groupNameAndMemberCounter() => Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: AppColors.whiteColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextComp(
              text: "GroupName",
              size: 20,
            ),
            const SizedBox(height: 8),
            TextComp(
              text: "2 member in the group",
              fontweight: FontWeight.normal,
              size: 18,
            ),
          ],
        ),
      ),
    );
Widget addMemberBtn() => Row(
      children: [
        const Icon(
          Icons.add,
          size: 30,
        ),
        TextComp(
          text: "Add Members",
          size: 20,
        )
      ],
    );

Widget emailProfile() => Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.greyColor,
            ),
            child: Center(
              child: TextComp(
                text: "J",
                color: AppColors.whiteColor,
                size: 17,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextComp(text: "Jahidul"),
              const SizedBox(height: 2),
              TextComp(
                text: "Jahidul@gmail.com",
                fontweight: FontWeight.normal,
                size: 15,
              ),
            ],
          )
        ],
      ),
    );

Widget groupListTile() => InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComp(text: "Share"),
                  TextComp(
                    text: "From you",
                    fontweight: FontWeight.normal,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
            )
          ],
        ),
      ),
    );

Widget multipleAddInputComp({
  required String hintText,
  required Function()? onPressed,
}) => // group member
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
              ),
            ),
          ),
          const SizedBox(width: 15),
          CustomButton(
            text: "Add",
            textSize: 17,
            onPressed: onPressed,
            width: 80,
            height: 40,
          ),
        ],
      ),
    );

// Widget descComp() => Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         constraints: const BoxConstraints(
//           minHeight: 47,
//           minWidth: double.infinity,
//           maxHeight: 120,
//           maxWidth: double.infinity,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: textController,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   decoration: const InputDecoration(
//                     hintText: "Message",
//                     hintStyle: TextStyle(
//                       fontSize: 18,
//                     ),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
