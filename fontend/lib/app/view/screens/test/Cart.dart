import 'package:e_commerce/app/controllers/cartController/cart_item_controller.dart';
import 'package:e_commerce/app/controllers/cartController/cart_controller.dart';
import 'package:e_commerce/app/models/CartItem.dart';
import 'package:e_commerce/app/models/DetailsItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class Cart extends StatelessWidget {
  Cart({super.key});
  final cartItemController = Get.find<Cartitemcontroller>();
  final cartController = Get.find<CartController>();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Get.height * 0.2),
          child: ItemsCart(),
        ),
        InfoPayment()
      ],
    );
  }

  Widget InfoPayment() {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      maxChildSize: 0.6,
      minChildSize: 0.2,
      builder: (context, scrollController) {
        return Obx(
          () {
            final list = cartItemController.checkedItems;
            return Container(
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child:
                          TotalItems(cartItemController.total(), list.length),
                    ),
                    CheckAll()
                  ],
                ));
          },
        );
      },
    );
  }

  Widget CheckAll() {
    return Obx(() => Row(
          children: [
            Checkbox(
              value: cartItemController.items.every(
                (element) => element.isCheck.value,
              ),
              onChanged: (bool? value) {
                if (value != null) {
                  cartItemController.checkAll(value);
                }
              },
            ),
            Text("Check All")
          ],
        ));
  }

  String formatPrice(int number) =>
      NumberFormat("#,###", 'vi_VN').format(number);

  Widget TotalItems(double total, int quantity) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total ( ${quantity} ) ${quantity == 1 ? "item" : "items"}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "${formatPrice(total.toInt())} Đ",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
                onTap: () {
                  if (cartItemController.checkedItems.length == 0) {
                    Get.snackbar("please choose items", "No item selected");
                  } else {
                    Get.toNamed('/payment', arguments: {});
                  }
                },
                child: Text(
                  "Proceed to Payment",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }

  Widget ItemsCart() {
    return Obx(() {
      final checkEmpty = cartItemController.items;
      if (checkEmpty.isEmpty) {
        return Center(
          child: Text("Cart is Empty"),
        );
      }
      if (checkEmpty.length == 0) {
        return Center(
          child: Text("Cart is Empty"),
        );
      }
      return Container(
          child: Scrollbar(
        controller: _controller,
        thumbVisibility: true,
        child: ListView.builder(
          controller: _controller,
          itemCount: cartItemController.items.length,
          itemBuilder: (context, index) {
            final item = cartItemController.items[index];
            return Slidable(
              key: ValueKey(
                  '${item.masp}-${item.size}'), // dinh danh cho tung slidable cho flutter biet
              child: ListTitleItem(item),
              endActionPane: ActionPane(motion: ScrollMotion(), children: [
                DeleteItem(item.masp, item.size, index),
              ]),
            );
          },
        ),
      ));
    });
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

  Widget ListTitleItem(CartItems item) {
    String folder = getFolder(item.maloaisp);
    final price = NumberFormat("#,###", 'vi_VN').format(item.thanhtien.toInt());
    return ListTile(
        leading: SizedBox(
          width: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Checkbox(
                  value: item.isCheck.value,
                  onChanged: (value) {
                    item.isCheck.value = !item.isCheck.value;
                  },
                ),
              ),
              CircleAvatar(
                backgroundImage: AssetImage(
                  "images/${folder}/${item.img}",
                ),
              ),
            ],
          ),
        ),
        title: Text(
          item.tensp,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Text(
              "${item.size}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "${price} đồng",
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
          ],
        ),
        trailing: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  detailsItem _detailsItem = detailsItem(
                      magiohang: cartController.IdCart.value,
                      masp: item.masp,
                      dongia: item.dongia,
                      thanhtien: item.thanhtien,
                      size: item.size);
                  cartItemController.increaseQuantityItem(_detailsItem);
                },
                child: Icon(Icons.add),
              ),
              Text(
                '${item.soluong}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              GestureDetector(
                onTap: () {
                  detailsItem _detailsItem = detailsItem(
                      magiohang: cartController.IdCart.value,
                      masp: item.masp,
                      dongia: item.dongia,
                      thanhtien: item.thanhtien,
                      size: item.size);
                  cartItemController.decreaseQuantityItem(_detailsItem);
                },
                child: Icon(Icons.remove),
              ),
            ],
          ),
        ));
  }

  Widget DeleteItem(int masp, String size, int index) {
    return SlidableAction(
        icon: Icons.delete,
        backgroundColor: Colors.redAccent,
        onPressed: (context) {
          cartItemController.deleteItem(masp, size);
        });
  }
}
