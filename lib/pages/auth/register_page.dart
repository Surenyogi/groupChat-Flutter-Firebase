import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/helper_function.dart';
import 'package:group_chat_app/pages/home_page.dart';
import 'package:group_chat_app/services/auth_service.dart';

import '../../shared/constants.dart';
import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  bool obscure = true;
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Zee Chat',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 108, 50),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Create your Account to exolore more',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Hero(
                          tag: 'login',
                          child: SizedBox(
                            height: 300,
                            width: 400,
                            child: Image.asset(
                              'assets/register.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Image.asset(
                        //   "assets/register.png",
                        // ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: textInputDecoration.copyWith(
                            labelText: "Full Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              fullName = val;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          // to check the validation
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email.';
                            }

                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Enter a valid Email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          obscureText: true,
                          textInputAction: TextInputAction.go,
                          decoration: textInputDecoration.copyWith(
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                              icon: Icon(
                                obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Constants().primaryColor,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Please enter your password.';
                            }

                            if (value!.length < 6) {
                              return 'Please enter a valid password.';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants().primaryColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Crete Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            onPressed: () {
                              register();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Already have an Account?",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " Login",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, const RegisterPage());
                                    }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //saving the shared preferences
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUserNameSF(fullName);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
