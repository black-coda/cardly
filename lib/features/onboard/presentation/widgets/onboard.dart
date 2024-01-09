import 'package:cardly/config/theme/color.dart';
import 'package:cardly/features/onboard/presentation/widgets/onboard.1.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'onboard.2.dart';
import 'onboard.3.dart';

class OnboardScreenController extends StatefulWidget {
  const OnboardScreenController({super.key});

  @override
  State<OnboardScreenController> createState() =>
      _OnboardScreenControllerState();
}

class _OnboardScreenControllerState extends State<OnboardScreenController> {
  final PageController _controller = PageController();

  //? Check if last page
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColor.white,
        elevation: 0,
        leadingWidth: 80,
        leading: isLastPage
            ? TextButton(
                onPressed: () => context.go("/login"),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: BrandColor.grey,
                    fontSize: 16,
                  ),
                ),
              )
            : TextButton(
                onPressed: () {
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeIn);
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: BrandColor.grey,
                    fontSize: 16,
                  ),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.jumpToPage(2);
            },
            child: Text(
              isLastPage ? "" : "Skip",
              style: const TextStyle(
                color: BrandColor.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              if (index == 2) {
                setState(() {
                  isLastPage = true;
                });
              } else {
                setState(() {
                  isLastPage = false;
                });
              }
            },
            children: const [
              OnBoardScreen1(),
              OnBoardScreen3(),
              OnBoardScreen2(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // padding: const EdgeInsets.symmetric(vertical: 0),
              alignment: const Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: BrandColor.primaryColor,
                      dotColor: BrandColor.primaryColorShade3,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OnBoard3 extends StatelessWidget {
  const OnBoard3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
