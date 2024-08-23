import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/routes/routes.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/core/widget/elevated_btn.dart';
import 'package:task_manager/core/widget/text_form_field.dart';
import 'package:task_manager/infrastructure/riverpod/password_provider.dart';
import 'package:task_manager/infrastructure/riverpod/user_model_notifier.dart';
import 'package:task_manager/presentation/login/login.dart';

class RegisterScrn extends ConsumerWidget {
  const RegisterScrn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userModelProvider);
    final userModelNotifier = ref.read(userModelProvider.notifier);
    final size = MediaQuery.of(context).size;
    final passwordVisibility = ref.watch(passwordVisibilityProvider);
    final passwordNotifier = ref.read(passwordVisibilityProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: ListView(
          children: [
            Image.asset('assets/image/register.png', height: size.height * 0.4),
            const Text(
              'Create New Account',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            sizedBox5H,
            const Text('make it work, make it right, make it fast.',
                textAlign: TextAlign.center),
            sizedBox25H,
            TextFormWidget(
              label: 'E-mail',
              icon: FontAwesomeIcons.envelope,
              errorText: userModel.emailError,
              onChanged: (value) => userModelNotifier.updateEmail(value ?? ''),
            ),
            sizedBox15H,
            TextFormWidget(
              isPassword: passwordVisibility,
              label: 'Password',
              icon: FontAwesomeIcons.lock,
              errorText: userModel.passwordError,
              onChanged: (value) =>
                  userModelNotifier.updatePassword(value ?? ''),
              suffixOnpress: () {
                passwordNotifier.togglePasswordVisibility();
              },
              suffixicon: passwordVisibility
                  ? FontAwesomeIcons.solidEyeSlash
                  : FontAwesomeIcons.solidEye,
            ),
            sizedBox15H,
            ElevatedBtnWidget(
              onPressed: () {
                if (userModel.isValid) {
                  log('Email: ${userModel.email}');
                  log('Password: ${userModel.password}');
                } else {
                  if (userModel.email.isEmpty && userModel.password.isEmpty) {
                    Fluttertoast.showToast(
                      msg: 'Please Enter the E-mail and Password',
                    );
                  }
                }
              },
              title: 'Register',
              btnColor: colorApp,
              colorTitle: colorWhite,
            ),
            sizedBox25H,
            sizedBox25H,
            Align(
              child: InkWell(
                onTap: () {
                  NavigationHandler.navigateOff(context, const LoginScrn());
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Already have an Account?",
                    children: [
                      TextSpan(
                        text: ' Login',
                        style: TextStyle(color: colorApp),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
