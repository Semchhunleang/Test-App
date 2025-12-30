import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';

class ProfilePicture extends StatelessWidget {
  final Uint8List? profilePicture;

  const ProfilePicture({Key? key, required this.profilePicture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return profilePicture != null && profilePicture!.isNotEmpty
        ? GestureDetector(
            onTap: () =>
                navPush(context, ViewFullImagePage(image: profilePicture)),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mainRadius),
                    border: Border.all(color: primaryColor, width: 0.4)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(mainRadius),
                    child: Image.memory(profilePicture!,
                        width: 100, height: 120, fit: BoxFit.cover))))
        : Icon(Icons.account_circle, size: 80, color: Colors.grey[400]);

    // return profilePicture != null && profilePicture!.isNotEmpty
    //     ? GestureDetector(
    //         onTap: () =>
    //             navPush(context, ViewFullImagePage(image: profilePicture)),
    //         child: CircleAvatar(
    //           radius: 61,
    //           backgroundColor: whiteColor,
    //           child: ClipOval(
    //             child: Image.memory(
    //               profilePicture!,
    //               width: 120,
    //               height: 120,
    //               fit: BoxFit.contain,
    //             ),
    //           ),
    //         ),
    //       )
    //     : Icon(Icons.account_circle, size: 80, color: Colors.grey[400]);

    // return profilePicture != null && profilePicture!.isNotEmpty
    //     ? GestureDetector(
    //         onTap: () =>
    //             navPush(context, ViewFullImagePage(image: profilePicture)),
    //         child: CircleAvatar(
    //             radius: 61,
    //             backgroundColor: primaryColor,
    //             child: CircleAvatar(
    //                 radius: 60, backgroundImage: MemoryImage(profilePicture!))))
    //     : Icon(Icons.account_circle, size: 80, color: Colors.grey[400]);

    //   return GestureDetector(
    //     onTap: () => navPush(
    //       context,
    //       ViewFullImagePage(image: profilePicture),
    //     ),
    //     child: Container(
    //       width: 150,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         border: Border.all(
    //           color: theme().primaryColor,
    //           width: 1,
    //         ),
    //         borderRadius: BorderRadius.circular(8), // Rounded corners
    //       ),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(
    //             8), // Ensure the image matches the container shape
    //         child: profilePicture != null && profilePicture!.isNotEmpty
    //             ? Image.memory(
    //                 profilePicture!,
    //                 fit: BoxFit.cover, // Adjust fit as needed
    //               )
    //             : Icon(
    //                 Icons.account_circle,
    //                 size: 80,
    //                 color: Colors.grey[400],
    //               ), // Placeholder icon or image
    //       ),
    //     ),
    //   );
  }
}
