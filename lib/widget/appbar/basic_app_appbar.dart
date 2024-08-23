import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Theme/bloc/Them_cubit.dart';
import '../../screen/Auth/bloc/auth_bloc.dart';
import '../../screen/Auth/bloc/auth_state.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;
  const BasicAppbar(
      {this.title,
      this.hideBack = false,
      this.action,
      this.backgroundColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? const Text(''),
      actions: [action ?? Container()],
      leading: hideBack
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => {Scaffold.of(context).openDrawer()},
                child: ClipOval(
                  child: Container(
                    width: 100,
                    height: 100,
                    color: isDarkMode ? Colors.white : Colors.black,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return Center(
                            child: ClipOval(
                              child: SizedBox(
                                width: 100.0,
                                height: 100.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: !isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    size: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (state is GetUser) {
                          final user = state.user;
                          final profilePicture = user.profile?["picture"];
                          if (profilePicture != null &&
                              profilePicture.isNotEmpty) {
                            final imageBytes = const Base64Decoder()
                                .convert(profilePicture.toString());
                            return Image.memory(
                              imageBytes,
                              fit: BoxFit.cover,
                            );
                          } else {
                            final email = user.email ?? '';
                            final firstLetter =
                                email.isNotEmpty ? email[0].toUpperCase() : '?';
                            return Center(
                              child: CircleAvatar(
                                backgroundColor:
                                    isDarkMode ? Colors.white : Colors.black,
                                child: Center(
                                  child: Text(
                                    firstLetter,
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                  ),
                                ),
                              ),
                            );
                          }
                        } else if (state is AuthFailure) {
                          return const Center(
                            child: Icon(Icons.error),
                          );
                        } else {
                          return const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 50,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            )
          : IconButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await Future.delayed(Durations.long1);
                Navigator.pop(context);
              },
              icon: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 15,
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
