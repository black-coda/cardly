import 'package:cardly/config/theme/color.dart';
import 'package:cardly/features/onboard/presentation/widgets/onboard.1.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
      body: Stack(children: [
        PageView(
          controller: _controller,
          children: [
            const OnBoard2(),
            const OnBoardScreen1(),
            const OnBoard3(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: const Alignment(0, 0.72),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //* Skip Button
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Color(0xFFF87265),
                      dotColor: Color(0xffECECEC),
                    ),
                  ),

                  //? Next and Done Button
                  isLastPage
                      ? TextButton(
                          onPressed: () => context.go("/login"),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
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
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class OnBoard2 extends StatelessWidget {
  const OnBoard2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Onboard 2"),
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

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Container(
          color: BrandColor.primaryColorShade2,
        ),
        Container(
          color: BrandColor.primaryColorShade1,
        ),
        Container(
          color: BrandColor.primaryColorShade3,
        )
      ],
    );
  }
}
