import 'package:barber_bloc/screen/Auth/signup.dart';
import 'package:barber_bloc/screen/start/start.dart';
import 'package:flutter/material.dart';

import '../../Theme/app_colors.dart';
import '../../widget/button/basic_app_button.dart';

class SignupOrSigninPage extends StatelessWidget {
  const SignupOrSigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 55,
                    ),
                    const Text(
                      'Enjoy Listening To Music',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    const Text(
                      'Spotify is a proprietary Swedish audio streaming and media services provider ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: AppColors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: BasicAppButton(
                              loading: false,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignupPage(),
                                  ),
                                );
                              },
                              title: 'Register'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => StartUI(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
