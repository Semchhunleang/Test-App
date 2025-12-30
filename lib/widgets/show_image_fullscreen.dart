import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

void showFullScreenImage(BuildContext context, String imageUrl) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context)
                .size
                .height, // Set the maximum height to the screen height.
            child: InteractiveViewer(
              panEnabled: true, // Enable panning.
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.2, // Minimum zoom scale. Adjust as needed.
              maxScale:
                  4.0, // Maximum zoom scale. Prevents zooming in too much.
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    ),
  );
}
