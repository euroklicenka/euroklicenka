import 'package:euk2_project/features/internet_access/http_loader.dart';
import 'package:flutter/material.dart';

///A tile showing information on the left and a logo on the right.
Widget InfoTile({required Size screenSize, required String title, required String imageFilePath, String launchURL = ''}) {
  return InkWell(
    onTap: () {
      if (launchURL.isEmpty) return;
      openURL(url: launchURL);
    },
    child: Row(
      children: [
        Flexible(
          child: Text(
            title,
            maxLines: 5,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(width: 8),
        Image.asset(
          imageFilePath,
          width: screenSize.width * 0.25,
        ),
      ],
    ),
  );
}
