import 'package:e_commerce/app/controllers/cartController/cart_item_controller.dart';
import 'package:e_commerce/app/controllers/paymentController/payment_controller.dart';
import 'package:e_commerce/app/controllers/user/user_controller.dart';
import 'package:e_commerce/app/view/widgets/ListTitleItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Payment extends StatelessWidget {
  Payment({super.key});
  final _cartItemController = Get.find<Cartitemcontroller>();
  final _userController = Get.find<UserController>();
  final _paymentController = Get.find<PaymentController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Address
              inFoCustomer(),
              //Items
              const Text(
                "Items",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              inFoItems(),
              total(),
              paymentMethod(),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          thickness: 2,
        ),
        Row(
          children: [
            const Text(
              "Payment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () async {
                  var items = _cartItemController.checkedItems
                      .map((e) => e.ToJson())
                      .toList();
                  var total = _cartItemController.total();
                  final url =
                      await _paymentController.CreateOrder(items, total);
                  if (url.isNotEmpty) {
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw "Khong mo duoc momo";
                    }
                  }
                },
                child: const Text("proccess"))
          ],
        )
      ],
    );
  }

  Widget total() {
    final total =
        NumberFormat("#,###", "vi_VN").format(_cartItemController.total());
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "Total:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 10,
          ),
          Text("$total Đồng")
        ],
      ),
    );
  }

  Widget inFoItems() {
    final listItem = _cartItemController.checkedItems;
    return SizedBox(
        height: Get.height / 5,
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            itemCount: listItem.length,
            itemBuilder: (context, index) {
              return ListTitleItem(item: listItem[index]);
            },
          ),
        ));
  }

  Widget inFoCustomer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                Text(
                  "Address",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )
                //
              ],
            ),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Back",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),

        //Address
        Obx(() {
          final data = _userController.khachhang.value;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name:${data.hoten != "" ? data.hoten : "No data"}'),
                  Text(
                      'Address:${data.diachi != "" ? data.diachi : "No data"}'),
                  Text(
                      'Phone:${data.diachi != "" ? data.dienthoai : "No data"}'),
                ],
              ),
              TextButton(
                  onPressed: () {
                    Get.toNamed("/updateprofile", arguments: {});
                  },
                  child: const Text(
                    "Change",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  ))
            ],
          );
        }),
      ],
    );
  }
}
