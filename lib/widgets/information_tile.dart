// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/features/internet_access/http_communicator.dart';
import 'package:flutter/material.dart';

/// A tile showing information on the left and a logo on the right.
/// Shows the text on the left side comprised of [leadingText], [hyperText] (only visual) and [trailingText].
/// Draws an image located under [imageFilePath] to the right of the tile.
/// Launches a URL when tapped that is assigned to [launchURL].
Widget infoTile({
  required BuildContext context,
  required String leadingText,
  required String imageFilePath,
  String launchURL = '',
  String hyperText = '',
  String trailingText = '',
}) {
  return InkWell(
    onTap: () {
      if (launchURL.isEmpty) return;
      openURL(url: launchURL);
    },
    child: Row(
      children: [
        Flexible(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              children: [
                TextSpan(text: leadingText),
                TextSpan(
                  text: hyperText,
                  style: const TextStyle(
                    color: Colors.blue, // You can choose the hyperlink color
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: trailingText),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Image.asset(
          imageFilePath,
          width: MediaQuery.of(context).size.width * 0.25,
        ),
      ],
    ),
  );
}
