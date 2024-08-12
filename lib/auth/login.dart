import 'package:cehpoint_marketplace_agent/common/constant.dart';
import 'package:cehpoint_marketplace_agent/services/functions/auth_functions.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  String email = '';
  String password = '';
  String fullname = '';
  bool login = true;
  bool isLoading = false;

// -----------------------------------------------------------------
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  dynamic errorTextFullname;
  dynamic errorTextEmail;
  dynamic errorTextPassword;
  bool obscureText = true;
// -----------------------------------------------------------------
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: h,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          color: blue700,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome to\nCehpoint\nMarketplace",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 10,
                            width: 40,
                            decoration: BoxDecoration(
                              color: logoColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 300,
                      child: SizedBox(
                        height: 462,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Form(
                            key: _formKey,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  login
                                      ? Container()
                                      : Text(
                                          "Full Name",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: appColor),
                                        ),
                                  // ======== Full Name ========
                                  login
                                      ? Container()
                                      : TextFormField(
                                          controller: fullNameController,
                                          keyboardType: TextInputType.name,
                                          key: const ValueKey('fullname'),
                                          decoration: InputDecoration(
                                              errorText: errorTextFullname,
                                              hintText: 'Enter Full Name',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onChanged: (value) => {
                                            if (value.isEmpty)
                                              {
                                                setState(
                                                  () {
                                                    errorTextFullname = null;
                                                  },
                                                )
                                              }
                                            else if (value.length < 2)
                                              {
                                                setState(() {
                                                  errorTextFullname =
                                                      'Please enter full name';
                                                })
                                              }
                                            else
                                              {
                                                setState(() {
                                                  errorTextFullname = null;
                                                  fullname = value;
                                                })
                                              }
                                          },
                                        ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: appColor),
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    key: const ValueKey('email'),
                                    decoration: InputDecoration(
                                        errorText: errorTextEmail,
                                        hintText: "Enter Email",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          errorTextEmail = null;
                                        });
                                      } else if (value.length > 5 &&
                                          value.contains('@gmail.com')) {
                                        //add another mail domains if you need, this is just for tests
                                        setState(() {
                                          errorTextEmail = null;
                                          email = value;
                                        });
                                      } else {
                                        setState(() {
                                          errorTextEmail =
                                              'Please enter valid email';
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Password",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: appColor),
                                  ),
                                  // ======== Password ========
                                  TextFormField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    key: const ValueKey('password'),
                                    obscureText: obscureText,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              obscureText = !obscureText;
                                            });
                                          },
                                        ),
                                        errorText: errorTextPassword,
                                        hintText: 'Enter Password',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          errorTextPassword = null;
                                        });
                                      } else if (!value
                                              .contains(RegExp("[A-Z]")) &&
                                          login == false) {
                                        setState(() {
                                          errorTextPassword =
                                              'Password should have at least one uppercase letter';
                                        });
                                      } else if (value.length < 6 &&
                                          login == false) {
                                        setState(() {
                                          errorTextPassword =
                                              'Password should contain at least 6 letters';
                                        });
                                      } else {
                                        setState(() {
                                          errorTextPassword = null;
                                          password = value;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 55,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isLoading
                                            ? Colors.transparent
                                            : appColor,
                                        foregroundColor: isLoading
                                            ? Colors.transparent
                                            : whiteColor,
                                      ),
                                      onPressed: isLoading
                                          ? null
                                          : () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                                if (email.isNotEmpty &&
                                                    password.isNotEmpty) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  try {
                                                    login
                                                        ? await AuthServices
                                                            .signinUser(
                                                                email,
                                                                password,
                                                                context)
                                                        : await AuthServices
                                                            .signupUser(
                                                                email,
                                                                password,
                                                                fullname,
                                                                context);
                                                  } finally {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                }
                                              }
                                            },
                                      child: isLoading
                                          ? const CircularProgressIndicator()
                                          : Text(login ? 'Login' : 'Signup'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        login
                                            ? "Don't have an account? "
                                            : "Already have an account? ",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            login = !login;
                                            password = '';
                                            email = '';
                                            fullname = '';
                                            emailController.clear();
                                            passwordController.clear();
                                            fullNameController.clear();
                                            errorTextEmail = null;
                                            errorTextFullname = null;
                                            errorTextPassword = null;
                                          });
                                        },
                                        child: Text(
                                          login ? "Signup" : "Login",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
