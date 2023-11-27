import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MessageDialogue {
  static authMessage({required BuildContext context, required String message, String? link}) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        //! The bug is from here dude
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      link != null
                          ? Lottie.asset(
                              link,
                              height: 100,
                              width: 100,
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
