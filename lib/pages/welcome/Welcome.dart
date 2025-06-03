import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF2F08),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          PageView.builder(
            onPageChanged: (value) {
              setState(() {
                currentIndex=value;
              });
            },
            itemCount: onBorad.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  // Hình ảnh
                  Positioned(
                    top: 40,
                    left: -80,
                    child: FadeInDown(
                      delay: Duration(microseconds: 500),
                      child: Image.asset(
                        onBorad[index].image,
                        fit: BoxFit.contain,
                        width: 500,
                        height: 500,
                      ),
                    ),
                  ),

                  // Text 1 & 2
                  Positioned(
                    top: MediaQuery.of(context).size.height / 1.9,
                    child: FadeInUp(
                      delay: Duration(microseconds: 500),


                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  0.9, // Giới hạn chiều rộng

                              child: Text(
                                onBorad[index].text1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              onBorad[index].text2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 175,
            left: 25,
            child: FadeInDown(
              delay: Duration(microseconds: 500),

              child: Row(
                children: [
                  ...List.generate(
                      onBorad.length,
                      (index) => AnimatedContainer(
                            duration: Duration(microseconds: 250),
                            height: 5,
                            width: 50,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15)),
                          ))
                ],
              ),
            ),
          ),
          Positioned(
  bottom: 30,
              child: FadeInUp(
                delay: Duration(microseconds: 500),

                child: SizedBox(
                            height: 75,
                            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: MaterialButton(onPressed: () {},color: Color(0xFF0033),shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),

                ),
                  minWidth: MediaQuery.of(context).size.width-50,
                  child: Center(
                    child: Text('Get Started',style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,

                    ),),
                  ),
                ),
                            ),
                          ),
              ))
        ],
      ),
    );
  }
}

// Data model
class OnBorad {
  final String image, text1, text2;

  OnBorad({
    required this.image,
    required this.text1,
    required this.text2,
  });
}

// Dummy data
List<OnBorad> onBorad = [
  OnBorad(
    image: 'images/boy.png',
    text1: 'Grab your delicious food!',
    text2: 'Delivery food to your phone',
  ),
  OnBorad(
    image: 'images/boy.png',
    text1: 'Fast and Tasty',
    text2: 'Order and enjoy anytime',
  ),
  OnBorad(
    image: 'images/boy.png',
    text1: 'Hungry? We’re here!',
    text2: 'Best food delivered to you',
  ),
];
