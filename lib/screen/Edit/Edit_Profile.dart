import 'package:barber_bloc/screen/Home/home_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'dart:convert';
import 'dart:io';
import '../../Theme/app_colors.dart';
import '../../model/model_user.dart';
import '../../widget/button/basic_app_button.dart';
import '../Auth/bloc/auth_bloc.dart';
import '../Auth/bloc/auth_event.dart';
import '../Auth/bloc/auth_state.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _base64Image = '';
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    if (_isLoading) return; // หยุดการทำงานหากมีการทำงานอยู่

    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _encodeImageToBase64();
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _encodeImageToBase64() async {
    if (_imageFile != null) {
      try {
        final bytes = await _imageFile!.readAsBytes();
        setState(() {
          _base64Image = base64Encode(bytes);
        });
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthFailure) {
              showTopSnackBar(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 60),
                Overlay.of(context),
                CustomSnackBar.success(
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? AppColors.lightBackground.withOpacity(0.3)
                          : AppColors.darkBackground.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                  backgroundColor: AppColors.F_Status,
                  message: state.error,
                ),
              );
              context.read<AuthBloc>().add(GetRequestedEvent());
            } else if (state is AuthSuccess) {
              showTopSnackBar(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 60),
                Overlay.of(context),
                CustomSnackBar.success(
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? AppColors.lightBackground.withOpacity(0.3)
                          : AppColors.darkBackground.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                  backgroundColor: AppColors.S_Status,
                  message: state.message,
                ),
              );

              context.read<AuthBloc>().add(GetRequestedEvent());
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                LoadingAnimationWidget.staggeredDotsWave(
                                  color:
                                      !isDarkMode ? Colors.white : Colors.black,
                                  size: MediaQuery.of(context).size.width * 0.1,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      Text(
                        "Select Picture",
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .01,
                      ),
                      _buildTextFormField(
                        isDarkMode: isDarkMode,
                        controller: _usernameController,
                        labelText: 'Username',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        isDarkMode: isDarkMode,
                        controller: _firstNameController,
                        labelText: 'First Name',
                      ),
                      _buildTextFormField(
                        isDarkMode: isDarkMode,
                        controller: _lastNameController,
                        labelText: 'Last Name',
                      ),
                      _buildTextFormField(
                        isDarkMode: isDarkMode,
                        controller: _phoneNumberController,
                        labelText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),
                      _buildTextFormField(
                        isDarkMode: isDarkMode,
                        controller: _addressController,
                        labelText: 'Address',
                      ),
                      const SizedBox(height: 20),
                      BasicAppButton(
                        loading: true,
                        onPressed: () {},
                        title: 'Update',
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is GetUser) {
              _usernameController.text = state.user.username.toString();
              _emailController.text = state.user.email.toString();
              _firstNameController.text =
                  state.user.profile!["firstName"] ?? "firstName";
              _lastNameController.text =
                  state.user.profile!["lastName"] ?? "lastName";
              _phoneNumberController.text =
                  state.user.profile!["phoneNumber"] ?? "PhoneNumber";
              _addressController.text =
                  state.user.profile!["address"] ?? "address";
              final user = state.user;
              final _profilePicture = user.profile?["picture"];

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor:
                                      isDarkMode ? Colors.white : Colors.black,
                                  backgroundImage: _imageFile != null
                                      ? FileImage(_imageFile!)
                                      : (_profilePicture != null
                                          ? MemoryImage(
                                              base64Decode(_profilePicture!),
                                            )
                                          : null),
                                  child: _profilePicture == null &&
                                          _imageFile == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      Text(
                        "Select Picture",
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .01,
                      ),
                      _buildTextFormField(
                        isDarkMode: isDarkMode,
                        controller: _usernameController,
                        labelText: 'Username',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        isDarkMode: isDarkMode,
                        controller: _firstNameController,
                        labelText: 'First Name',
                      ),
                      _buildTextFormField(
                        isDarkMode: isDarkMode,
                        controller: _lastNameController,
                        labelText: 'Last Name',
                      ),
                      _buildTextFormField(
                        isDarkMode: isDarkMode,
                        controller: _phoneNumberController,
                        labelText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),
                      _buildTextFormField(
                        isDarkMode: isDarkMode,
                        controller: _addressController,
                        labelText: 'Address',
                      ),
                      const SizedBox(height: 20),
                      BasicAppButton(
                        loading: false,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState?.validate() ?? false) {
                            final updatedUser = User(
                              email: state.user.email,
                              username: _usernameController.text.trim(),
                              profile: {
                                'firstName': _firstNameController.text.trim(),
                                'lastName': _lastNameController.text.trim(),
                                'phoneNumber':
                                    _phoneNumberController.text.trim(),
                                'address': _addressController.text.trim(),
                                'picture': _base64Image,
                              },
                            );

                            context
                                .read<AuthBloc>()
                                .add(EditRequestedEvent(user: updatedUser));
                            context.read<AuthBloc>().add(GetRequestedEvent());
                          }
                        },
                        title: 'Update',
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text("Error loading profile"));
          },
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required bool isDarkMode,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: isDarkMode ? Colors.black54 : Colors.white,
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 12.0, vertical: 8.0), // ลดขนาด padding
        ),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
