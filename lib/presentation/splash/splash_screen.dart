import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/presentation/splash/func/func_splash.dart';

class SplashScrn extends ConsumerWidget {
  const SplashScrn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    splashtime(context, ref);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
                'assets/animations/Animation - 1724336243150.json'),
            Text(
              "TASK MANAGER",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorWhite,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
