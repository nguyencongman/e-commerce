import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:e_commerce/app/controllers/user/user_controller.dart';
import 'package:e_commerce/utils/constants/LinkConstant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/bottomItemController.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  final userControler = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            infoUser("avt1", userControler.emailController.text,
                userControler.nameController.text),
            EditProfile(),
            Settings(),
          ],
        ));
  }

  Widget infoUser(String img, String email, String name) {
    return Row(
      children: [
        //avt
        SizedBox(
          width: 100,
          child: Image(
            image: AssetImage("${LinkConstant.avatar}/${img}.jpg"),
          ),
        ),
        //info
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //name
            Text(
              "Hi, $name",
              softWrap: true,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(email, softWrap: true),
            Signout()

            //email
          ],
        ))
      ],
    );
  }

  Widget Signout() {
    Bottomitemcontroller bottom = Get.find<Bottomitemcontroller>();
    final _auth = Get.find<AuthService>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          child: TextButton(
              onPressed: () {
                _auth.logOut();
                Get.offAllNamed("/account");
                bottom.bottomItem.value = 0;
              },
              child: Text("Sign Out",
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  Widget EditProfile() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ButtonInfo(Icons.person, "Manage user", '/updateprofile')
        ],
      ),
    );
  }

  Widget Settings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Settings",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ButtonInfo(
            Icons.notifications_active, "Notification", '/updateprofile'),
        ButtonInfo(Icons.dark_mode, "Dark Mode", '/updateprofile'),
      ],
    );
  }

  Widget ButtonInfo(IconData icon, String title, String router) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon,color: Colors.black,),
          title: Text(title,style: TextStyle(
            color: Colors.black54
          ),),
          onTap: () {
            Get.toNamed('/updateprofile', arguments: {});
          },
        ),
      ),
    );
  }
}
