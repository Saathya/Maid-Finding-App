// ignore_for_file: use_build_context_synchronously, avoid_print, depend_on_referenced_packages, deprecated_member_use

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mr_urban_customer_app/ApiServices/api_call_service.dart';
import 'package:mr_urban_customer_app/ApiServices/url.dart';
import 'package:mr_urban_customer_app/BootomBar.dart';
import 'package:mr_urban_customer_app/custom_widegt/widegt.dart';
import 'package:mr_urban_customer_app/loginAuth/forgot_password_screen.dart';
import 'package:mr_urban_customer_app/loginAuth/sign_up_screen.dart';
import 'package:mr_urban_customer_app/model/login_model.dart';
import 'package:mr_urban_customer_app/utils/AppWidget.dart';
import 'package:mr_urban_customer_app/utils/color_widget.dart';
import 'package:mr_urban_customer_app/utils/colors.dart';
import 'package:mr_urban_customer_app/utils/image_icon_path.dart';
import 'package:mr_urban_customer_app/utils/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/text_form_field.dart';

class LoginScreen extends StatefulWidget {
  final String? type;
  const LoginScreen({super.key, this.type});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  bool isSelected = false;
  String? emailId;
  String? name;
  String? mobiles;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginModel? loginModel;
  String? uid;

  final _formKey = GlobalKey<FormState>();
  ApiService service = ApiService();
  String generateRandomNumber() {
    Random random = Random();
    String randomNumber = '';

    for (int i = 0; i < 10; i++) {
      randomNumber += random.nextInt(9).toString();
    }

    return randomNumber;
  }

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      User? user = await signInWithGoogle();
      if (user != null) {
        String email = user.email!;
        String phoneNumber = user.phoneNumber ?? generateRandomNumber();

        bool userExists = await fetchUserDataAndRegister(
          user.displayName ?? 'No Name',
          email,
          phoneNumber,
          '+91',
          'Gmail',
          context,
        );

        if (userExists) {
          // User exists, navigate to BottomNavigationBarScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigationBarScreen(),
            ),
          );
        } else {
          // Registration failed, show an error message if needed
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text("Registration Failed")),
          // );
        }
      }
    } catch (e) {
      print("Error during sign-in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Sign-In Failed")),
      );
    }
  }

  Future<bool> fetchUserDataAndRegister(
    String name,
    String email,
    String mobile,
    String countryCode,
    String password,
    BuildContext context,
  ) async {
    var url = Uri.parse(Config.baseUrl + Config.fetchuser);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    print("Fetching user data for email: $email");
    print("Request URL: $url");
    print("Request Body: ${jsonEncode({'email': email})}");

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print("Response Data: $responseData");

      if (responseData['Result'] == 'true') {
        print('User data fetched successfully');
        return true; // User exists
      } else {
        print('User not found with provided email. Registering user...');
        await service.registerApi(
          name,
          email,
          mobile,
          countryCode,
          password,
          context,
        );
        return false; // Assume registration always returns false here to indicate user does not exist (since fetchUserDataAndRegister is used for registration purpose)
      }
    } else {
      print(
          'Failed to fetch user data: ${response.statusCode} - ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to fetch user data: ${response.statusCode}')),
      );
      return false; // Handle HTTP error
    }
  }

  getLoginData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mydata = (preferences.getString('loginModel'));
    var jsondecode = jsonDecode(mydata.toString());

    setState(() {
      loginModel = LoginModel.fromJson(jsondecode);
      uid = loginModel!.userLogin!.id;
      preferences.getBool("seen");
    });
  }

  late ColorNotifire notifire;
  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  clearLoginData() async {
    save("Remember", false);
    getData.remove("UserLogin");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("loginModel");
    preferences.setBool("seen", false);
    Get.to(() => const BottomNavigationBarScreen());
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: notifire.getprimerycolor,
        appBar: AppBar(
            automaticallyImplyLeading:
                false, // Add this line to disable the default back button

            // leading: IconButton(
            //     icon: Icon(Icons.arrow_back,
            //         color: notifire.getdarkscolor, size: 28),
            //     onPressed: () {
            //       if (widget.type == "payment") {
            //         Get.back();
            //       } else {
            //         Get.off(() => const BottomNavigationBarScreen());
            //       }
            //     }),
            backgroundColor: notifire.getprimerycolor,
            elevation: 0,
            title: Text(
              TextString.login,
              style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontWeight: FontWeight.bold,
                  fontFamily: CustomColors.fontFamily,
                  fontSize: 28),
            ),
            centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                TextString.letsSignYouIn,
                style: TextStyle(
                    color: notifire.getdarkscolor,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    fontFamily: CustomColors.fontFamily),
              ),
              const SizedBox(height: 14),
              Text(
                TextString.Welcomebackyouvebeenmissed,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: CustomColors.fontFamily,
                    color: notifire.greyfont),
              ),
              const SizedBox(height: 18),

              emailTextFormField(),
              const SizedBox(height: 24),

              passwordTextFormField(),

              const SizedBox(height: 24),

              /// Check Box & Forgot Password
              Row(children: [
                Checkbox(
                    splashRadius: 30,
                    value: isSelected,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    activeColor: CustomColors.primaryColor,
                    onChanged: (value) {
                      setState(() {});
                      isSelected = value!;
                      save("Remember", value);
                    }),
                Text(
                  TextString.rememberMe,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: notifire.getdarkscolor,
                      fontFamily: CustomColors.fontFamily),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Get.to(() => const ForgotPasswordScreen());
                  },
                  child: const Text(
                    TextString.forgotPassword,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: CustomColors.primaryColor,
                        fontFamily: CustomColors.fontFamily),
                  ),
                ),
              ]),

              const SizedBox(height: 24),
              // Login Button
              loginButton(),
              const SizedBox(height: 16),
              Center(
                  child: Text(
                TextString.or,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: CustomColors.fontFamily,
                    fontWeight: FontWeight.w700,
                    color: notifire.greyfont),
              )),

              const SizedBox(height: 18),
              // Sign Up Button
              signUpButton(),
              const SizedBox(height: 55),
              continueasGoogle(),
            ]),
          )),
        ),
      ),
    );
  }

  /// --------------------------------------------  Text Fields ---------------------------------------------///

  /// Email Text Field
  Widget emailTextFormField() {
    return CustomTextfield(
      fieldController: emailController,
      style: const TextStyle(color: Colors.white),
      hint: TextString.email,
      hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  // Password Text Field
  Widget passwordTextFormField() {
    return CustomTextfield(
        hint: TextString.password,
        style: const TextStyle(color: Colors.white),
        obscureText: _isObscure,
        fieldController: passwordController,
        hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        suffixIcon: IconButton(
            icon: _isObscure
                ? const Icon(Icons.remove_red_eye_outlined,
                    color: CustomColors.grey)
                : const Icon(Icons.visibility_off_outlined,
                    color: CustomColors.grey),
            onPressed: () {
              setState(() {});
              _isObscure = !_isObscure;
            }));
  }

  /// ----------------------------------- Login Button ------------------------------------------------///
  Widget loginButton() {
    return AppButton(
      buttontext: TextString.login,
      onclick: () async {
        if (_formKey.currentState!.validate()) {
          String email = emailController.text.trim();
          String password = passwordController.text.trim();

          // Validate email format using a regular expression
          if (!isValidEmail(email)) {
            // Show error message for invalid email
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Please enter a valid email address')),
            );
            return;
          }

          try {
            // Attempt to sign in with Firebase authentication
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password,
            );

            // If sign-in is successful, navigate to the next screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigationBarScreen(),
              ),
            );
          } on FirebaseAuthException catch (e) {
            String errorMessage = 'An error occurred';

            // Handle specific error codes
            if (e.code == 'wrong-password') {
              errorMessage = 'The password is incorrect.';
            } else if (e.code == 'user-not-found') {
              errorMessage = 'No user found with that email.';
            } else {
              // Handle other Firebase related errors
              print(
                  'Firebase Error: ${e.message}'); // Print or log the Firebase error message
              errorMessage = 'Firebase Error: ${e.message}';
            }

            // Display error message using ScaffoldMessenger or another appropriate method
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
              ),
            );
          } catch (e) {
            // Handle other generic errors
            print('Error occurred: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error occurred: $e'),
              ),
            );
          }
        }
      },
    );
  }

  bool isValidEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  /// ----------------------------------- Sign Up Button ------------------------------------------------///
  Widget signUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(TextString.Donthaveanaccount,
            style: TextStyle(
                fontFamily: CustomColors.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: CustomColors.grey)),
        InkWell(
          onTap: () {
            Get.to(() => const SignUpScreen());
          },
          child: const Text(TextString.signUp,
              style: TextStyle(
                  fontFamily: CustomColors.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.primaryColor)),
        )
      ],
    );
  }

  Widget continueasGoogle() {
    return Center(
      child: InkWell(
        onTap: () {
          _handleSignIn(context);
        },
        child: Container(
          height: 48,
          width: Get.width * 0.60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: notifire.greyfont, width: 1, style: BorderStyle.solid),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImagePath.googleIcon, // Path to the Google logo image
                height: 24, // Adjust the height as needed
              ),
              const SizedBox(width: 10), // Space between the logo and the text
              const Text(
                TextString.google,
                style: TextStyle(
                  fontFamily: CustomColors.fontFamily,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  }

  Widget continueAsAGuestButton() {
    return Center(
      child: InkWell(
        onTap: () {
          clearLoginData();
        },
        child: Container(
          height: 48,
          width: Get.width * 0.60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: notifire.greyfont, width: 1, style: BorderStyle.solid),
              color: notifire.detail),
          child: Center(
            child: Text(TextString.ContinueasaGuest,
                style: TextStyle(
                    fontFamily: CustomColors.fontFamily,
                    fontWeight: FontWeight.w700,
                    color: notifire.getdarkscolor)),
          ),
        ),
      ),
    );
  }
}
