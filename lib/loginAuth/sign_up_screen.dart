import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mr_urban_customer_app/ApiServices/api_call_service.dart';
import 'package:mr_urban_customer_app/BootomBar.dart';
import 'package:mr_urban_customer_app/loginAuth/login_screen.dart';
import 'package:mr_urban_customer_app/model/country_code_list_model.dart';
import 'package:mr_urban_customer_app/utils/AppWidget.dart';
import 'package:mr_urban_customer_app/utils/color_widget.dart';
import 'package:mr_urban_customer_app/utils/colors.dart';
import 'package:mr_urban_customer_app/utils/text_widget.dart';
import 'package:mr_urban_customer_app/widget/text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../IntroScreen/splash_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  bool isSelected = false;
  bool isLoading = false;

  String? _selectedCountryCode = '';

  String? selectedCity = "New Delhi";

  List<String> dummyCityNames = ["New Delhi", "Pune", "Bengaluru", "Mumbai"];

  String emailRegularParttern = r"([a-z0-9_@.]}";

  final _formKey = GlobalKey<FormState>();

  ApiService service = ApiService();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  setRegisterData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", fullNameController.text);
    prefs.setString("email", emailAddressController.text);
    prefs.setString("mobile", mobileController.text);
    prefs.setString("password", passwordController.text);
    prefs.setString("confirmPassword", confirmPasswordController.text);
    prefs.setString("code", referralCodeController.text);
    prefs.setString("countryCode", _selectedCountryCode!);

    // Debug prints to verify data is being saved
    // print('Name: ${prefs.getString("name")}');
    // print('Email: ${prefs.getString("email")}');
    // print('Mobile: ${prefs.getString("mobile")}');
    // print('Password: ${prefs.getString("password")}');
    // print('Confirm Password: ${prefs.getString("confirmPassword")}');
    // print('Referral Code: ${prefs.getString("code")}');
    // print('Country Code: ${prefs.getString("countryCode")}');
  }

  CountryCodeListModel? countryCodeListModel;
  final bool _load = false;
  @override
  void initState() {
    setState(() {
      _selectedCountryCode = '+91';
    });
    super.initState();
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
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: notifire.getdarkscolor, size: 28),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(TextString.register,
            style: TextStyle(
                color: notifire.getdarkscolor,
                fontWeight: FontWeight.bold,
                fontFamily: CustomColors.fontFamily,
                fontSize: 28)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          child: !isLoading
              ? Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(TextString.gettingStarted,
                          style: TextStyle(
                              fontSize: 24,
                              color: notifire.getdarkscolor,
                              fontWeight: FontWeight.w700,
                              fontFamily: CustomColors.fontFamily)),
                      SizedBox(height: Get.height * 0.01),
                      const Text(TextString.Seemsyouarenewhere,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontFamily: CustomColors.fontFamily,
                              color: CustomColors.grey)),
                      SizedBox(height: Get.height * 0.03),
                      nameTextField(),
                      SizedBox(height: Get.height * 0.02),
                      emailTextField(),
                      SizedBox(height: Get.height * 0.02),
                      phoneNumberTextField(),
                      SizedBox(height: Get.height * 0.02),
                      passwordTextFormField(),
                      SizedBox(height: Get.height * 0.02),
                      confirmPasswordTextFormField(),
                      SizedBox(height: Get.height * 0.02),
                      cityTextField(),
                      SizedBox(height: Get.height * 0.02),
                      referralCodeTextField(),
                      SizedBox(height: Get.height * 0.02),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                                splashRadius: 30,
                                value: isSelected,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)),
                                activeColor: CustomColors.primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    isSelected = value!;
                                  });
                                }),
                            const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      TextString
                                          .Bycreatinganaccountyouagreetoour,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: CustomColors.grey,
                                          fontSize: 13,
                                          fontFamily: CustomColors.fontFamily)),
                                  SizedBox(height: 5),
                                  Text(TextString.TermandConditions,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: CustomColors.primaryColor,
                                          fontFamily: CustomColors.fontFamily)),
                                ]),
                          ]),
                      const SizedBox(height: 27),
                      continueButton(),
                      const SizedBox(height: 18),
                      loginButton(),
                    ],
                  ),
                )
              : Column(
                  children: [
                    SizedBox(height: Get.height * 0.40),
                    Center(
                      child: SizedBox(
                        child: isLoadingIndicator(),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  /// --------------------------------------------  Text Fields ---------------------------------------------///

  /// Name Field
  Widget nameTextField() {
    return CustomTextfield(
        hint: TextString.fullName,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
        fieldController: fullNameController,
        hintStyle: TextStyle(
          fontFamily: CustomColors.fontFamily,
          color: notifire.getdarkscolor,
        ));
  }

  Widget emailTextField() {
    return CustomTextfield(
        hint: TextString.emailaddress,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        },
        fieldController: emailAddressController,
        hintStyle: TextStyle(
          fontFamily: CustomColors.fontFamily,
          color: notifire.getdarkscolor,
        ));
  }

  Widget cityTextField() {
    return InputDecorator(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 2.0), // Adjust this for more compact height
        hintStyle: TextStyle(
          fontFamily: CustomColors.fontFamily,
          color: notifire.getdarkscolor,
        ),
        labelText: TextString.city,
        labelStyle: const TextStyle(color: CustomColors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: CustomColors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: CustomColors.red, width: 0),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: CustomColors.red),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: CustomColors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.black, // Replace with your primary color
          value: selectedCity,
          isExpanded: true, // Make the dropdown full-width
          items: dummyCityNames.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedCity = value;
            });
          },
          style: const TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ),
    );
  }

  cpicker() {
    return Ink(
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            dropdownColor: Colors.black, // Replace with your primary color
            value: _selectedCountryCode,
            items: countryCode.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Text(
                      value,
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedCountryCode = value;
              });
            },
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }

  Widget phoneNumberTextField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1, color: Colors.grey)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [cpicker()]),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: CustomTextfield(
              fieldController: mobileController,
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                return null;
              },
              hint: TextString.mobileNumber,
              fieldInputType: TextInputType.number,
              hintStyle: TextStyle(
                fontFamily: CustomColors.fontFamily,
                color: notifire.getdarkscolor,
              )),
        ),
      ],
    );
  }

  Widget passwordTextFormField() {
    return CustomTextfield(
        hint: TextString.password,
        obscureText: _isObscure,
        style: const TextStyle(color: Colors.white),
        fieldController: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        hintStyle: TextStyle(
          fontFamily: CustomColors.fontFamily,
          color: notifire.getdarkscolor,
        ),
        suffixIcon: IconButton(
            icon: _isObscure
                ? const Icon(Icons.remove_red_eye_outlined,
                    color: CustomColors.grey)
                : const Icon(Icons.visibility_off_outlined,
                    color: CustomColors.grey),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }));
  }

  Widget confirmPasswordTextFormField() {
    return CustomTextfield(
        hint: TextString.confirmPassword,
        style: const TextStyle(color: Colors.white),
        obscureText: _isObscureConfirm,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please enter your confirm password';
          }
          if (val != passwordController.text) {
            return 'Not Match';
          }
          return null;
        },
        fieldController: confirmPasswordController,
        hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily),
        suffixIcon: IconButton(
            icon: _isObscureConfirm
                ? const Icon(Icons.remove_red_eye_outlined,
                    color: CustomColors.grey)
                : const Icon(Icons.visibility_off_outlined,
                    color: CustomColors.grey),
            onPressed: () {
              setState(() {
                _isObscureConfirm = !_isObscureConfirm;
              });
            }));
  }

  /// Referral Code field
  Widget referralCodeTextField() {
    return CustomTextfield(
        style: const TextStyle(color: Colors.white),
        hint: TextString.referralCode,
        fieldController: referralCodeController,
        fieldInputType: TextInputType.number,
        hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily));
  }

  /// ----------------------------------- Continue Button ------------------------------------------------///

  createUserWithEmail(String email, String password, String name, String mobile,
      String countryCode, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await setRegisterData();

        ApiService()
            .registerApi(name, email, mobile, countryCode, password, context);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigationBarScreen()));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Widget continueButton() {
    return _load == false
        ? InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                if (isSelected == true) {
                  setState(() {
                    isLoading = true;
                  });
                  createUserWithEmail(
                      emailAddressController.text,
                      passwordController.text,
                      fullNameController.text,
                      mobileController.text,
                      _selectedCountryCode!,
                      context);
                } else {
                  Fluttertoast.showToast(
                      msg: "Please accept terms and conditions");
                }
              }
            },
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: CustomColors.primaryColor),
              child: const Center(
                child: Text(TextString.Continue,
                    style: TextStyle(
                        color: CustomColors.white,
                        fontFamily: CustomColors.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          )
        : const CircularProgressIndicator();
  }

  /// ----------------------------------- Login Button ------------------------------------------------///
  Widget loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(TextString.Alreadyhaveanaccount,
            style: TextStyle(
                fontFamily: CustomColors.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: CustomColors.grey)),
        GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Text(TextString.login,
                style: TextStyle(
                    fontFamily: CustomColors.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryColor)))
      ],
    );
  }

  Dio dio = Dio();

  // MobileCheckModel? mobileCheckModel;
  // Future mobileCheckApi(String? mobile, context, String? ccode, number) async {
  //   try {
  //     var params = {"mobile": mobile};

  //     final response =
  //         await dio.post(Config.baseUrl + Config.mobileCheck, data: params);
  //     if (response.statusCode == 200) {
  //       mobileCheckModel =
  //           MobileCheckModel.fromJson(json.decode(response.data));

  //       if (mobileCheckModel!.result == "true") {
  //         verifyPhone(ccode, number, context);

  //         Fluttertoast.showToast(msg: "${mobileCheckModel?.responseMsg}");
  //       } else if (mobileCheckModel == null) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         Fluttertoast.showToast(msg: "${mobileCheckModel?.responseMsg}");
  //       } else {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         Fluttertoast.showToast(msg: "${mobileCheckModel?.responseMsg}");
  //       }
  //     }
  //   } on DioError {
  //     Fluttertoast.showToast(msg: "Error");
  //   }
  // }

  // /// verification code
  // Future<void> verifyPhone(String? ccode, number, context) async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: ccode! + number,
  //     timeout: const Duration(seconds: 120),
  //     verificationCompleted: (PhoneAuthCredential credential) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       ApiWrapper.showToastMessage("Auth Completed!");
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       ApiWrapper.showToastMessage("Auth Failed!");
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       Get.to(() => OtpVarificationScreen(verID: verificationId));
  //       ApiWrapper.showToastMessage("OTP Sent!");
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       ApiWrapper.showToastMessage("Timeout!");
  //     },
  //   );
  // }
}
