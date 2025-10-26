import 'package:e_commerce/app/controllers/bottomItemController.dart';
import 'package:e_commerce/app/view/chatbasic/chatapp.dart';
import 'package:e_commerce/app/view/screens/test/Cart.dart';
import 'package:e_commerce/app/view/screens/test/Favorite.dart';
import 'package:e_commerce/app/view/screens/test/Profile/Profile.dart';
import 'package:e_commerce/app/view/screens/test/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final bottomController = Get.find<Bottomitemcontroller>();
  final List<dynamic> pages = [const HomePage(), Favorite(), Cart(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Image.asset('images/play_store_512.png'),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Coffee House',
              style: TextStyle(
                  color: Colors.lightBlue, fontSize: 25, fontFamily: 'Roboto'),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            child: Icon(
              Icons.chat,
              color: Colors.amber[200],
            ),
            onTap: () {
              Get.toNamed("/chat");
            },
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed('/updateprofile');
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.account_circle,
                color: Colors.blue[200],
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => pages[bottomController.bottomItem.value],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            currentIndex: bottomController.bottomItem.value,
            onTap: (value) {
              bottomController.bottomItem.value = value;
            },
            selectedLabelStyle: const TextStyle(color: Colors.green),
            selectedItemColor: Colors.green,
            unselectedLabelStyle: const TextStyle(color: Colors.grey),
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border), label: "Favorite"),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined), label: "Profile")
            ]),
      ),
    );
  }
}
