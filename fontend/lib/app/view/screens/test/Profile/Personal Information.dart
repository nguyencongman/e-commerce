import 'package:e_commerce/app/controllers/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInformation extends StatelessWidget {
  PersonalInformation({super.key});
  final _formKey = GlobalKey<FormState>();
  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            Get.back();
          },
        ),
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(
            () => GestureDetector(
              child: Text(
                "Update",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _userController.isLoading == true
                        ? Colors.green
                        : Colors.grey),
              ),
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  if (_userController.isLoading.value) {
                    _userController.updateCustomer();
                  }
                }
              },
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: bodyProfile(),
    );
  }

  Widget bodyProfile() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: infomations());
  }

  Widget infomations() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            fieldInfo(_userController.nameController, "Name"),
            fieldInfo(_userController.phoneController, "Phone"),
            fieldInfo(_userController.addressController, "Adress"),
            fieldInfo(_userController.emailController, "Email")

          ],
        ),
      ),
    );
  }

  Widget fieldInfo(TextEditingController _controller, String title) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập $title';
                }
                return null;
              },
              onChanged: (value) => _userController.isLoading.value = true,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ));
  }
}
