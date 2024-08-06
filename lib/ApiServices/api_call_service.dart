// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unused_catch_clause, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mr_urban_customer_app/ApiServices/url.dart';
import 'package:mr_urban_customer_app/BootomBar.dart';
import 'package:mr_urban_customer_app/loginAuth/login_screen.dart';
import 'package:mr_urban_customer_app/loginAuth/otpverification_screen_2.dart';
import 'package:mr_urban_customer_app/model/edit_profile_model.dart';
import 'package:mr_urban_customer_app/model/forget_password_model.dart';
import 'package:mr_urban_customer_app/model/image_upload_model.dart';
import 'package:mr_urban_customer_app/model/login_model.dart';
import 'package:mr_urban_customer_app/model/register_model.dart';
import 'package:mr_urban_customer_app/utils/AppWidget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../AppScreens/Home/home_screen.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Dio dio = Dio();

  /// Get Login Data
  getLoginData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mydata = (preferences.getString('loginModel'));
    var jsondecode = jsonDecode(mydata.toString());
    if (kDebugMode) {}

    loginModel = LoginModel.fromJson(jsondecode);
    uid = loginModel!.userLogin!.id!;
  }

  /// set Image
  setImage() async {
    String raJson = jsonEncode(imageUploadModel);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("imageUploadModel", raJson);
  }

  setData() async {
    String raJson = jsonEncode(registerModel);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("registerModel", raJson);
  }

  setLoginData() async {
    String raJson = jsonEncode(loginModel);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("loginModel", raJson);
    if (kDebugMode) {}
    if (kDebugMode) {}
  }

  /// ------------------------------- Register Api ----------------------------- ///
  RegisterModel? registerModel;

  LoginModel? loginModel;
  Future<void> registerApi(
    String? name,
    String? email,
    String? mobile,
    String? countryCode,
    String? password,
    BuildContext context,
  ) async {
    try {
      var url = Uri.parse(Config.baseUrl + Config.register);
      var body = json.encode({
        "name": name,
        "email": email,
        "mobile": mobile,
        "ccode": countryCode,
        "password": password
      });

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print("Registration Response Data: $responseData");

        if (responseData["Result"] == "true") {
          // Registration successful, process the user data
          var userLoginData = responseData["UserLogin"];
          print("UserLogin Data: $userLoginData");

          save("Firstuser", true);
          save("Remember", true);
          save("UserLogin", userLoginData);

          // Optionally, process the login model if needed
          // loginModel = LoginModel.fromJson(responseData);
          // setData();
          // setLoginData();

          // Navigate to the next screen upon successful registration
          // save("Firstuser", true);
          // save("UserLogin", userLoginData);
          // uid = userLoginData["id"]; // Assuming "id" is the key for user ID

          Fluttertoast.showToast(msg: "${responseData["ResponseMsg"]}");

          // Navigate to BottomNavigationBarScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigationBarScreen(),
            ),
          );
        } else {
          // Registration failed, show error message
          Fluttertoast.showToast(
              msg: "Registration Failed: ${responseData["ResponseMsg"]}");
        }
      } else {
        // Handle HTTP error
        print("Failed to register. Error: ${response.body}");
        Fluttertoast.showToast(msg: "Failed to register");
      }
    } catch (e) {
      // Handle other errors
      print("Error caught: $e");
      Fluttertoast.showToast(msg: "Error");
    }
  }

  Future<void> loginApi(
    String? mobile,
    String? password,
    BuildContext context,
    String type,
  ) async {
    try {
      var url = Uri.parse(Config.baseUrl + Config.login);
      var body = json.encode({
        "email": mobile,
        "password": password,
      });

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        loginModel = LoginModel.fromJson(responseData);
        setLoginData();
        setImage();

        if (loginModel?.result == "true") {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
          save("Firstuser", true);
          save("UserLogin", responseData["UserLogin"]);
          uid = responseData["UserLogin"]["id"];
          if (type == "payment") {
            Get.back();
          } else {
            Get.off(() => const BottomNavigationBarScreen());
          }

          (route) => false;

          /// OneSignal Shared SendTag
          OneSignal.shared.sendTag("user_id", loginModel?.userLogin?.id);
        } else if (loginModel == null) {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        } else {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        }
      } else {
        // Print the error response for debugging
        print("Failed to login. Error: ${response.body}");
        Fluttertoast.showToast(msg: "Failed to login");
      }
    } catch (e) {
      // Print other errors for debugging
      print("Error caught: $e");
      Fluttertoast.showToast(msg: "Error");
    }
  }

  loginApi2(String? mobile, password, context, type) async {
    try {
      var params = {"email": mobile, "password": password};

      final response =
          await dio.post(Config.baseUrl + Config.login, data: params);
      if (response.statusCode == 200) {
        loginModel = LoginModel.fromJson(response.data);
        setLoginData();
        setImage();

        if (loginModel?.result == "true") {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
          if (type == "payment") {
            Get.back();
          } else {
            Get.off(() => const BottomNavigationBarScreen());
          }
          (route) => false;

          /// OneSignal Shared SendTag
          OneSignal.shared.sendTag("user_id", loginModel?.userLogin?.id);
          save("Firstuser", false);
          save("UserLogin", response.data["UserLogin"]);
        } else if (loginModel == null) {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        } else {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        }
      }
    } on DioException {
      Fluttertoast.showToast(msg: "Error");
    }
  }

  /// --------------------------- forgot Password Api ----------------------------- ///
  ForgotPasswordModel? forgotPasswordModel;

  /// Forgot password Api
  Future forgetPasswordApi(String? number, password, context) async {
    try {
      var params = {"email": number, "password": password};
      final response =
          await dio.post(Config.baseUrl + Config.forgotPassword, data: params);
      if (response.statusCode == 200) {
        forgotPasswordModel = ForgotPasswordModel.fromJson(response.data);

        if (forgotPasswordModel?.result == "true") {
          Fluttertoast.showToast(msg: "${forgotPasswordModel?.responseMsg}");
          Get.to(() => const LoginScreen());
        } else if (forgotPasswordModel == null) {
          Fluttertoast.showToast(msg: "${forgotPasswordModel?.responseMsg}");
        } else {
          Fluttertoast.showToast(msg: "${forgotPasswordModel?.responseMsg}");
        }
      }
    } on DioException {
      Fluttertoast.showToast(msg: "Error");
    }
  }

  /// Forgot verification code
  Future<void> forgotVerifyPhone(number, context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + number,
      verificationCompleted: (PhoneAuthCredential credential) {
        // ApiWrapper.showToastMessage("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        // ApiWrapper.showToastMessage("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) async {
        var signature = await SmsAutoFill().getAppSignature;

        print(signature);
        Fluttertoast.showToast(msg: "Otp sent successfully");
        Get.to(() => OtpVerificationScreenTwo());
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // ApiWrapper.showToastMessage("Timeout!");
      },
    );
  }

  /// -------------------------- Profile Image UpLoad Api --------------------------///
  ImageUploadModel? imageUploadModel;
  profileImageUploadApi(String? image, context) async {
    try {
      var params = {
        "uid": uid,
        "img": image,
      };

      final response =
          await dio.post(Config.baseUrl + Config.profileImage, data: params);
      if (response.statusCode == 200) {
        loginModel = LoginModel.fromJson(response.data);
        setLoginData();
        setData();
        if (loginModel?.result == "true") {
          save("UserLogin", response.data["UserLogin"]);

          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        } else if (loginModel == null) {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        } else {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        }
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: "Error");
    }
  }

  /// -------------------------- Profile Edit Api --------------------------///
  EditProfileModel? editProfileModel;

  Future<void> profileEditApi(String? name, String? email, String? mobile,
      String? ccode, context) async {
    try {
      var url = Uri.parse(
          Config.baseUrl + Config.profileEdit); // Use correct endpoint URL
      var body = json.encode({
        "email": email,
        "name": name,
        "mobile": mobile,
        "ccode": ccode,
      });

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        editProfileModel = EditProfileModel.fromJson(responseData);

        if (editProfileModel?.result == "true") {
          Fluttertoast.showToast(msg: "${editProfileModel?.responseMsg}");
          Navigator.pop(
              context); // Close the current screen after successful update

          // Assuming you have a method to refresh the UI or data after profile edit
          getLoginData();
        } else {
          Fluttertoast.showToast(msg: "${editProfileModel?.responseMsg}");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Failed to update profile: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
