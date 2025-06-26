import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import '../product/list_food.dart';
import 'banner_promotion.dart';
import 'home_header.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              HomeHeader(),
              SizedBox(height: Dimensions.height20),

              /// Banner
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Text(
                  "Ưu Dai Hom nay",
                  style: TextStyle(
                    fontSize: Dimensions.font18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              BannerPromotion(),
              SizedBox(height: Dimensions.height30),

              /// Danh mục
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Text(
                  "Danh mục",
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height15),
              // >>>> Bạn có thể thêm widget hiển thị danh mục tĩnh tại đây nếu muốn

              SizedBox(height: Dimensions.height30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
              ),
              SizedBox(height: Dimensions.height20),

              /// Sản phẩm phổ biến
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Text(
                  "Sản phẩm phổ biến",
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height15),
              // >>>> Bạn có thể thêm widget hiển thị sản phẩm tĩnh tại đây nếu muốn

              SizedBox(height: Dimensions.height30),
            ],
          ),
        ),
      ),
    );
  }
}
