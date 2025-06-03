import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontendtn1/utils/color.dart';
import 'package:frontendtn1/utils/dimensions.dart';
import 'package:frontendtn1/widgets/app_column.dart';
import 'package:frontendtn1/widgets/app_icon.dart';
import 'package:frontendtn1/widgets/big_text.dart';
import 'package:frontendtn1/widgets/exandable_text.dart';

class PopularFoodDetail extends StatelessWidget {
  const PopularFoodDetail({super.key});

  @override
  Widget build(BuildContext context) {
    // ⚠️ Gọi hàm khởi tạo Dimensions
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2F08),
        elevation: 0,
        title: Text(
          'FOODTHT',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(Icons.notifications, color: Colors.black),
          )
        ],
      ),
      body: Stack(
        children: [
          // Hình ảnh
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.popularFoodImage,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/images1.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Icon (quay lại + giỏ hàng)
          Positioned(
            top: Dimensions.height45,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIcon(icon: Icons.arrow_back_ios),
                AppIcon(icon: Icons.favorite_border),
              ],
            ),
          ),

          // Nội dung
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: Dimensions.popularFoodImage - 20,
            child: Container(
              padding: EdgeInsets.only(
                left: Dimensions.width20,
                right: Dimensions.width20,
                top: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius20),
                  topLeft: Radius.circular(Dimensions.radius20),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppColumn(text: "Chinese Side"),
                  SizedBox(height: Dimensions.height20),
                  BigText(text: "Giới thiệu"),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ExpandableText(
                        text:
                        "KFC là một trong những chuỗi cửa hàng thức ăn nhanh đầu tiên mở rộng thị phần quốc tế, với nhiều cửa hàng ở Canada, Vương quốc Anh, Mexico và Jamaica...",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Thanh công cụ dưới cùng
      bottomNavigationBar: Container(
        height: Dimensions.bottomHeighBar,
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height30,
          horizontal: Dimensions.width20,
        ),
        decoration: BoxDecoration(
          color: AppColors.buttonBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius20 * 2),
            topRight: Radius.circular(Dimensions.radius20 * 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Nút tăng giảm
            Container(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height10,
                horizontal: Dimensions.width20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
              ),
              child: Row(

                children: [
                  Icon(Icons.remove, color: AppColors.signColor),
                  SizedBox(width: Dimensions.width10 / 2),
                  BigText(text: "0"),
                  SizedBox(width: Dimensions.width10 / 2),
                  Icon(Icons.add, color: AppColors.signColor),
                ],
              ),
            ),

            // Nút thêm vào giỏ hàng
            Container(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height10,
                horizontal: Dimensions.width20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: AppColors.mainColor,
              ),
              child: BigText(text: "\$10 | ADD TO CART", color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
