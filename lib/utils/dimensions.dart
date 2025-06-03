import 'package:flutter/material.dart';

class Dimensions {
  static late double screenHeight;
  static late double screenWidth;

  static late double pageView;
  static late double pageViewContainer;
  static late double pageViewTextContainer;

  static late double height10;
  static late double height15;
  static late double height20;
  static late double height30;
  static late double height45;

  static late double width10;
  static late double width15;
  static late double width20;
  static late double width30;

  static late double radius20;
  static late double radius30;

  static late double font16;
  static late double font20;
  static late double font26;

  static late double iconSize24;
  static late double iconSize16;

  static late double listViewImgSize;
  static late double listViewTextContsize;
  static late double popularFoodImage;

  static late double bottomHeighBar;

  static void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    pageView = screenHeight / 2.64;
    pageViewContainer = screenHeight / 3.84;
    pageViewTextContainer = screenHeight / 7.03;

    height10 = screenHeight / 84.4;
    height15 = screenHeight / 56.27;
    height20 = screenHeight / 42.2;
    height30 = screenHeight / 28.13;
    height45 = screenHeight / 18.84;

    width10 = screenWidth / 84.4;
    width15 = screenWidth / 56.27;
    width20 = screenWidth / 42.2;
    width30 = screenWidth / 28.13;

    radius20 = screenHeight / 42.2;
    radius30 = screenHeight / 28.13;

    font16 = screenHeight / 52.7;
    font20 = screenHeight / 42.2;
    font26 = screenHeight / 32.46;

    iconSize24 = screenHeight / 35.17;
    iconSize16 = screenHeight / 52.75;

    listViewImgSize = screenWidth / 3.25;
    listViewTextContsize = screenWidth / 3.9;
    popularFoodImage = screenHeight / 2.41;

    bottomHeighBar = screenHeight / 7.03;
  }
}
