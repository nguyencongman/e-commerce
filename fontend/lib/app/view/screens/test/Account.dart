import 'package:e_commerce/app/controllers/account/login_controller.dart';
import 'package:e_commerce/app/controllers/account/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/TextField.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(
                child: Text("Sign In"),
              ),
              Tab(
                child: Text("Sign Up"),
              )
            ]),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TabBarView(children: [LoginView(), SignUpView()]),
          ),
        ));
  }
}

class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SignupController _signupController = Get.find<SignupController>();
    return SingleChildScrollView(
        child: Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 4,
            child: Image.asset(
              'images/branding.jpg',
            ),
          ),
          const Text(
            "Create your Account",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFieldV2(
              controller: _signupController.userController.value,
              label: "Enter the email"),
          const SizedBox(
            height: 20,
          ),
          TextFieldV2(
            controller: _signupController.passwordController.value,
            label: "Enter the password",
            obs: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFieldV2(
              controller: _signupController.nameController.value,
              label: "Enter the name"),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => Text(
              "${_signupController.text.value}",
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () {
              return _signupController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              await _signupController.signupAccount();
                            }
                          },
                          child: const Text("Sign up")),
                    );
            },
          )
        ],
      ),
    ));
  }
}

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _key = GlobalKey<FormState>();
  LoginController _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height / 3,
                child: Image.asset(
                  'images/branding.jpg',
                ),
              ),
            ],
          ),
          const Text(
            "Login your Account",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFieldV2(
            controller: _loginController.emailController.value,
            label: "Enter the username",
          ),
          const SizedBox(
            height: 20,
          ),
          TextFieldV2(
              controller: _loginController.passwordController.value,
              label: "Enter the password",
              obs: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Get.toNamed('/forgotpassword');
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.lightBlue),
                  )),
            ],
          ),
          Obx(() => Text(
                _loginController.text.value,
                style: const TextStyle(color: Colors.red),
              )),
          Obx(() {
            return _loginController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            bool success =
                                await _loginController.fetchAccount();
                            if (success) {
                              Get.offNamed('/mainScreen',
                                  arguments: {"name": _loginController.name});
                            }
                          }
                        },
                        child: const Text("Login")),
                  );
          })
        ],
      ),
    ));
  }
}
