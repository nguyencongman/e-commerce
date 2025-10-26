import 'package:e_commerce/app/models/CartItem.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTitleItem extends StatelessWidget {
  const ListTitleItem({super.key, required this.item});
  final CartItems item;
  @override
  Widget build(BuildContext context) {
    String folder = getFolder(item.maloaisp);
    final price = NumberFormat("#,###", 'vi_VN').format(item.thanhtien.toInt());
    return ListTile(
        leading: SizedBox(
          width: 100,
          child: CircleAvatar(
            backgroundImage: AssetImage(
              "images/$folder/${item.img}",
            ),
          ),
        ),
        title: Text(
          item.tensp,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Text(
              item.size,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "$price đồng",
              style: const TextStyle(fontSize: 16, color: Colors.black45),
            ),
          ],
        ),
        trailing: Text(
          '${item.soluong}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
}
