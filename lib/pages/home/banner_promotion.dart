import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';

class BannerPromotion extends StatefulWidget {
  @override
  _BannerPromotionState createState() => _BannerPromotionState();
}

class _BannerPromotionState extends State<BannerPromotion> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final List<String> _imageList = [
    'images/fried_chicken.png',
    'images/fried_chicken.png',
    'images/fried_chicken.png',
  ];

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimensions.screenHeight / 4.5,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _imageList.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(0, 8)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          _imageList[index],
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                                Colors.black.withOpacity(0.3)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                        // Positioned(
                        //   left: 20,
                        //   bottom: 20,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text("Giảm 30%",
                        //           style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 24,
                        //               fontWeight: FontWeight.bold)),
                        //       Text("Cho đơn hàng đầu tiên",
                        //           style: TextStyle(
                        //               color: Colors.white70, fontSize: 16)),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: Dimensions.height10),
        // Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_imageList.length, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 12 : 8,
              height: _currentPage == index ? 12 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Colors.deepOrange
                    : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}
