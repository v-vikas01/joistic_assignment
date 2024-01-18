import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../component/size_config.dart';
import 'colors.dart';

String getFirstTwoWords(String text) {
  List<String> words = text.split(' ');
  if (words.length >= 2) {
    String firstWord = capitalizeFirstLetter(words[0]);
    String secondWord = capitalizeFirstLetter(words[1]);
    return '$firstWord $secondWord';
  } else {
    return text;
  }
}

String capitalizeFirstLetter(String word) {
  if (word.isNotEmpty) {
    return word[0].toUpperCase() + word.substring(1);
  } else {
    return word;
  }
}

Widget shimmerCard({required double height, required double width}) {
  return Shimmer(
    color: COLORS.whiteBorder,
    colorOpacity: 0.3,
    enabled: true,
    direction: const ShimmerDirection.fromLTRB(),
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 3),
      ),
    ),
  );
}

Widget shimmerCardRounded() {
  return Shimmer(
    enabled: true,
    direction: const ShimmerDirection.fromLTRB(),
    child: Container(
      padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    ),
  );
}

Widget errorWidget({required VoidCallback onPressed}) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: COLORS.white,
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.only(
                top: SizeConfig.blockHeight * 7,
                right: SizeConfig.blockWidth * 7,

                left: SizeConfig.blockWidth * 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(
                  "Oops!",
                  style: TextStyle(
                    color: COLORS.blackdark,
                    fontFamily: "Poppins",
                    fontSize: SizeConfig.blockWidth * 9.5,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: SizeConfig.blockHeight * 6),
                Text(
                  "Something went wrong.\nDon't worry let's try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: COLORS.blackdark,
                      fontFamily: "Poppins",
                      fontSize: SizeConfig.blockWidth * 4.5,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  width: SizeConfig.blockWidth * 60,
                  height: SizeConfig.blockHeight * 7.2,
                  margin: EdgeInsets.only(top: SizeConfig.blockHeight * 4),
                  child: ElevatedButton(
                    onPressed: () {
                      onPressed();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(COLORS.blackMedium),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(COLORS.blackMedium),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.blockWidth * 6)))),
                    child: Text(
                      "TRY AGAIN",
                      style: TextStyle(
                          color: COLORS.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          fontSize: SizeConfig.blockWidth * 4.5),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
