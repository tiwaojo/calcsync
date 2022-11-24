import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Resources used: https://youtu.be/AmsXazhGMQ0
class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final controller = PageController();

  @override
  void dispose() {
    // Disposes of resources after widget has left build tree
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PageView(
          onPageChanged: (i) {
            setState(() {
              i == 2
                  ? "Navigate to sign in page"
                  : "Dont"; // TODO: Add ability to switch to sign in page once onboarding is complete
            });
          },
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: [
            onBoardPage(label: "Page 1"),
            onBoardPage(label: "Page 2"),
            onBoardPage(label: "Page 3"),
          ],
        ),
      ),
      bottomSheet: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  controller.jumpToPage(2);
                },
                child: Text("Skip"),
              ),
              Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: ScrollingDotsEffect(
                    spacing: 16,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.deepOrangeAccent,
                  ),
                  onDotClicked: (i) {
                    controller.animateToPage(i,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.decelerate);
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.nextPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.decelerate);
                },
                child: Text("Next"),
              ),
            ],
          )),
    );
  }
}

class onBoardPage extends StatelessWidget {
  const onBoardPage({
    Key? key,
    required this.label,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(label),
      ),
    );
  }
}
