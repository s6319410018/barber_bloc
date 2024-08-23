import 'package:barber_bloc/screen/Delete/Delete_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:animations/animations.dart';

import '../../../widget/button/basic_app_button.dart';
import '../../Auth/bloc/auth_bloc.dart';
import '../../Auth/bloc/auth_event.dart';
import '../../Auth/bloc/auth_state.dart';
import '../../Edit/Edit_Profile.dart';
import '../../start/start.dart';
import 'Avatar.dart';

class CustomDrawer extends StatefulWidget {
  final bool isDarkMode;

  const CustomDrawer({super.key, required this.isDarkMode});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _profileController;
  late final Animation<double> _profileFadeAnimation;
  late final Animation<double> _profileScaleAnimation;

  @override
  void initState() {
    super.initState();
    _profileController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _profileFadeAnimation = CurvedAnimation(
      parent: _profileController,
      curve: Curves.ease,
    );
    _profileScaleAnimation =
        Tween<double>(begin: 0.8, end: 1.0).animate(_profileFadeAnimation);
  }

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                color: widget.isDarkMode
                    ? Colors.black.withOpacity(0.9)
                    : Colors.white.withOpacity(0.9),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      // Show a loading indicator while the data is being fetched
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is GetUser) {
                      // Data is loaded, proceed to build the widget
                      final user = state.user;
                      final profilePicture = user.profile?["picture"];
                      final username = user.username;

                      return AnimatedOpacity(
                        duration: Durations.medium2,
                        opacity:
                            1, // You can adjust the opacity based on other conditions if needed
                        curve: Curves.linear,
                        child: FadeTransition(
                          opacity: _profileFadeAnimation,
                          child: ScaleTransition(
                            scale: _profileScaleAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: Icon(
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.09,
                                          Icons.close_rounded,
                                          color: widget.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Avatar(
                                            isDarkMode: widget.isDarkMode,
                                            email: user.email,
                                            image: profilePicture,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Username"),
                                                            content:
                                                                Text(username),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    "Close"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        username!.length > 10
                                                            ? "${username.substring(0, 10)}..."
                                                            : username,
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: widget
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "${user.email}",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.bold,
                                              color: widget.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (state is AuthFailure) {
                      // Handle error state
                      return Center(
                        child: Text(
                          'Error: ${state.error}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      // Handle other states or default case
                      return Center(
                        child: Text(
                          'Please wait...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                OpenContainer(
                  closedElevation: 0,
                  openElevation: 0,
                  closedColor: Colors.transparent,
                  openColor: Colors.transparent,
                  closedBuilder: (context, action) {
                    return ListTile(
                      title: const Text('Edit Profile'),
                      onTap: action,
                    );
                  },
                  openBuilder: (context, action) {
                    return EditProfile();
                  },
                ),
                OpenContainer(
                  closedElevation: 0,
                  openElevation: 0,
                  closedColor: Colors.transparent,
                  openColor: Colors.transparent,
                  closedBuilder: (context, action) {
                    return ListTile(
                      title: const Text('Delete Account'),
                      onTap: action,
                    );
                  },
                  openBuilder: (context, action) {
                    return DeleteUI(); // Placeholder for delete confirmation
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoggedOut) {
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 300),
                    child: BasicAppButton(
                      loading: true,
                      onPressed: () {},
                      title: 'Logout',
                    ),
                  );
                } else {
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 300),
                    child: BasicAppButton(
                      loading: false,
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<AuthBloc>().add(LogoutRequestedEvent());
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StartUI(),
                              ),
                            );
                          });
                        });
                      },
                      title: 'Logout',
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
