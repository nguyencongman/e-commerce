import 'package:e_commerce/app/controllers/favoriteController.dart';
import 'package:e_commerce/app/models/sanpham.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Favorite extends StatelessWidget {
  Favorite({super.key});
  final favoriteController = Get.find<FavoriteController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "My favorites",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto"),
              ),
            ),
            SizedBox(
                height: Get.height / 1.5,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      // ignore: invalid_use_of_protected_member
                      final item = favoriteController.items[index];
                      return Slidable(child: listTileItem(context, item));
                    },
                    // ignore: invalid_use_of_protected_member
                    itemCount: favoriteController.items.value.length,
                  ),
                ))
          ],
        ));
  }

  String getFolder(int maloai) {
    if (maloai == 1) {
      return "coffee";
    } else if (maloai == 2) {
      return "juice";
    } else {
      return "tea";
    }
  }

  Widget listTileItem(BuildContext context, SanPhamModel item) {
    final price = NumberFormat('#,###', 'vi_VN').format(item.dongia);
    final folder = getFolder(item.maloaisp);
    return GestureDetector(
        onTap: () {
          Get.toNamed("/details", arguments: {"product": item});
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('images/$folder/${item.img}'),
          ),
          title: Text(
            item.tensp,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            "$price đồng",
            style: const TextStyle(fontSize: 16, color: Colors.black45),
          ),
          trailing: GestureDetector(
            child: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Xoá ${item.tensp} khỏi danh sách?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Huỷ")),
                      TextButton(
                          onPressed: () {
                            favoriteController.remove(item.masp);
                            Get.back();
                          },
                          child: const Text("Oke")),
                    ],
                  );
                },
              );
            },
          ),
        ));
  }
}
