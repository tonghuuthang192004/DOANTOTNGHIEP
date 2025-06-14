import 'package:flutter/material.dart';

class Dimensions {
  static late double screenHeight;
  static late double screenWidth;

  static late double pageView;
  static late double pageViewContainer;
  static late double pageViewTextContainer;

  static late double height5; // ~5 px trên màn hình 850 px cao
  static late double height8;

  static late double height10;

  static late double height12;

  static late double height15;

  static late double height20;

  static late double height25;

  static late double height30;

  static late double height40;

  static late double height45;

  static late double height50;

  static late double height100;

  static late double width5;

  static late double width8;

  static late double width10;

  static late double width12;

  static late double width15;

  static late double width20;

  static late double width25;

  static late double width30;

  static late double width40;

  static late double width45;

  static late double width50;

  static late double width100 ;

  static late double radius10;

  static late double radius15;

  static late double radius20;

  static late double radius25;

  static late double radius30;

  static late double font12;

  static late double font14;

  static late double font16;

  static late double font18;

  static late double font20;

  static late double font22;

  static late double font24;

  static late double font26;

  static late double iconSize16;

  static late double iconSize20;

  static late double iconSize24;

  static late double iconSize30;

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

    height5 = screenHeight / 170; // ~5 px trên màn hình 850 px cao
    height8 = screenHeight / 106.25;
    height10 = screenHeight / 85;
    height12 = screenHeight / 70.83;
    height15 = screenHeight / 56.67;
    height20 = screenHeight / 42.5;
    height25 = screenHeight / 34;
    height30 = screenHeight / 28.33;
    height40 = screenHeight / 21.25;
    height45 = screenHeight / 18.89;
    height50 = screenHeight / 17;
    height100 = screenHeight / 8.5;

    width5 = screenWidth / 85;
    width8 = screenWidth / 53.125;
    width10 = screenWidth / 42.5;
    width12 = screenWidth / 35.42;
    width15 = screenWidth / 28.33;
    width20 = screenWidth / 21.25;
    width25 = screenWidth / 17;
    width30 = screenWidth / 14.17;
    width40 = screenWidth / 10.63;
    width45 = screenWidth / 9.44;
    width50 = screenWidth / 8.5;
    width100 = screenHeight / 8.5;

    radius10 = screenHeight / 85;
    radius15 = screenHeight / 56.67;
    radius20 = screenHeight / 42.5;
    radius25 = screenHeight / 34;
    radius30 = screenHeight / 28.33;

    font12 = screenHeight / 70.0;
    font14 = screenHeight / 60.00;
    font16 = screenHeight / 52.7;
    font18 = screenHeight / 47.22;
    font20 = screenHeight / 42.2;
    font22 = screenHeight / 38.6;
    font26 = screenHeight / 32.46;

    iconSize16 = screenHeight / 53.13;
    iconSize20 = screenHeight / 42.5;
    iconSize24 = screenHeight / 35.42;
    iconSize30 = screenHeight / 28.33;

    listViewImgSize = screenWidth / 3.25;
    listViewTextContsize = screenWidth / 3.9;
    popularFoodImage = screenHeight / 2.41;

    bottomHeighBar = screenHeight / 7.03;
  }
}
