import 'package:e_commerce/app/controllers/bottomItemController.dart';
import 'package:e_commerce/app/controllers/cartController/cart_item_controller.dart';
import 'package:e_commerce/app/controllers/cartController/cart_controller.dart';
import 'package:e_commerce/app/controllers/detailsProduct/CoffeeSizeController.dart';
import 'package:e_commerce/app/controllers/favoriteController.dart';
import 'package:e_commerce/app/models/sanpham.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:e_commerce/app/models/DetailsItem.dart';

class DetailsProduct extends StatelessWidget {
  DetailsProduct({super.key});

  final args = Get.arguments;
  final CoffeeSizeController controller = Get.find<CoffeeSizeController>();
  final CartController cartController = Get.find<CartController>();
  final Cartitemcontroller cartitemcontroller = Get.find<Cartitemcontroller>();
  final FavoriteController _favoriteController = Get.find<FavoriteController>();
  final bottomController = Get.find<Bottomitemcontroller>();

  @override
  Widget build(BuildContext context) {
    final SanPhamModel sanpham = args['product'];
    return Scaffold(
        body: Column(
      children: [mainItem(sanpham), DetailsItem(sanpham)],
    ));
  }

  // mainItem
  Widget mainItem(SanPhamModel sanpham) {
    final String folder;
    if (sanpham.maloaisp == 1) {
      folder = "coffee";
    } else if (sanpham.maloaisp == 2) {
      folder = "juice";
    } else {
      folder = "tea";
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: Get.height / 3,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'images/$folder/${sanpham.img}',
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon:
                            const Icon(Icons.arrow_back_ios_rounded, size: 15),
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                      ),
                      Obx(
                        () {
                          bool isFavoreite = _favoriteController.items.any(
                            (e) => e.masp == sanpham.masp,
                          );
                          return IconButton(
                            onPressed: () {
                              if (!isFavoreite) {
                                _favoriteController.addItem(sanpham.masp);
                              }
                            },
                            icon: Icon(
                              isFavoreite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 15,
                              color: isFavoreite ? Colors.red : Colors.black,
                            ),
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.white)),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sanpham.tensp,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.amber[300]),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "3.7",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget DetailsItem(SanPhamModel sanpham) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Coffee Size",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto"),
              ),
              const SizedBox(
                height: 10,
              ),
              coffeeSize(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "About",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                ),
              ),
              about(sanpham),
              const SizedBox(
                height: 50,
              ),
              addToCart(sanpham),
            ],
          ),
        ),
      ),
    );
  }

  Widget coffeeSize() {
    final size = ['Small', 'Medium', 'Large'];
    return Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: size.map((e) {
          return GestureDetector(
            onTap: () {
              controller.size.value = e;
            },
            child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    color: e == controller.size.value
                        ? Colors.green
                        : Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(e),
                )),
          );
        }).toList()));
  }

  Widget about(SanPhamModel sanpham) {
    CoffeeSizeController controller = Get.put(CoffeeSizeController());
    return Obx(() => SizedBox(
          height: Get.height / 5,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "${sanpham.mota} ${sanpham.mota}${sanpham.mota}",
                maxLines: controller.expand.value == false ? 3 : null,
                overflow: controller.expand.value == false
                    ? TextOverflow.ellipsis
                    : null,
              ),
              InkWell(
                onTap: () {
                  controller.expand.value = !controller.expand.value;
                },
                child: Text(
                  controller.expand.value == false ? "Read more" : "Show less",
                  style: TextStyle(
                      color: controller.expand.value == false
                          ? Colors.blueAccent
                          : Colors.redAccent),
                ),
              ),
            ]),
          ),
        ));
  }

  Widget addToCart(SanPhamModel sanpham) {
    String priceformat =
        NumberFormat("#,###", 'vi_VN').format(sanpham.dongia.toInt());
    return GestureDetector(
      onTap: () {
        detailsItem item = detailsItem(
            magiohang: cartController.IdCart.value,
            masp: sanpham.masp,
            dongia: sanpham.dongia,
            thanhtien: sanpham.dongia,
            size: controller.size.value);
        cartitemcontroller.addItem(item);
        bottomController.bottomItem.value = 2;
        Get.back();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(30)),
        height: Get.height / 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Add to Cart",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "$priceformat đồng",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
