import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Resources used: https://youtu.be/AmsXazhGMQ0
class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final controller = PageController();
  bool onLastPage = false;

  @override
  void dispose() {
    // Disposes of resources after widget has left build tree
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("onLastPage $onLastPage");
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        child: PageView(
          onPageChanged: (idx) {
            setState(() {
              onLastPage = idx == 2;
              // ? "Navigate to sign in page"
              // : "Dont"; // TODO: Add ability to switch to sign in page once onboarding is complete
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
      bottomSheet: onLastPage
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                  onPressed: () async {
                    Navigator.pushNamed(context,
                        '/signin'); // navigate to homepage if on last page
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    _prefs.setBool("navToHome", true);
                  },
                  child: Text(
                    "Continue",
                    style: Theme.of(context).textTheme.button,
                  )),
            )
          : Container(
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
                      onDotClicked: (idx) {
                        controller.animateToPage(idx,
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
      // : Colors.blueAccent,
      child: Center(
        child: Text(label),
      ),
    );
  }
}
