import 'package:flutter/material.dart';

///A popup window, that shows information about a specific eurokey location.
Widget EUKPopupWindow({
  required String address,
  required String region,
  required String city,
  required String ZIP,
  required String info,
  required String imageURL,
}) {
  return Container(
    width: 300,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 300,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageURL),
              fit: BoxFit.fitWidth,
              filterQuality: FilterQuality.high,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            color: Colors.red,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: SizedBox(
            child: Text(
              address,
              maxLines: 2,
              softWrap: false,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          // widget.data!.date!
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Text(
            '$city, $ZIP',
            maxLines: 2,
          ),
        ),
      ],
    ),
  );
}
