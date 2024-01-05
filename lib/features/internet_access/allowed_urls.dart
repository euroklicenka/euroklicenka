// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

List<String> downloadURLs = [];
String aboutEuroKeyURL = '';
String aboutEuroKeyWebURL = '';
String universityOfOstravaURL = '';
String universityOfOstravaKIPURL = '';

/// Sets up all allowed URLs in the file.
void setAllowedURLs({
  required List<String> downloads,
  required String aboutEuroKey,
  required String aboutEuroKeyWeb,
  required String universityOfOstrava,
  required String universityOfOstravaKIP,
}) {
  downloadURLs = downloads;
  aboutEuroKeyURL = aboutEuroKey;
  aboutEuroKeyWebURL = aboutEuroKeyWeb;
  universityOfOstravaURL = universityOfOstrava;
  universityOfOstravaKIPURL = universityOfOstravaKIP;
}
