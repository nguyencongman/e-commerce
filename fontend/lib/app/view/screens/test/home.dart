import 'package:e_commerce/app/constants.dart';
import 'package:e_commerce/app/controllers/sanphamController.dart';
import 'package:e_commerce/app/models/sanpham.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SanPhamController sanPhamController = Get.find<SanPhamController>();
  ScrollController _controller = ScrollController();
  final List<Map<String, String>> categories = [
    {
      'name': 'coffee',
      'image': 'images/coffee/americano.jpg',
      'folder': 'coffee'
    },
    {'name': 'juice', 'image': 'images/juice/apple.jpg', 'folder': 'juice'},
    {'name': 'tea', 'image': 'images/tea/black.jpg', 'folder': 'tea'}
  ];
  final List<String> pages = ['home', 'favorite', 'cart', 'profile'];

  String getFolderFromCategory(int category) {
    switch (category) {
      case 1:
        return 'coffee';
      case 2:
        return 'juice';
      case 3:
        return 'tea';
      default:
        return 'coffee';
    }
  }

  @override
  Widget build(BuildContext context) {
    return home();
  }

  Widget home() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Have a nice day! ",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: "Roboto"),
            ),
            const SizedBox(
              height: 10,
            ),
            searchBarHome(),
            Categories(),
            bestSeller(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget carouselViewHome() {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.menu));
  }

  Widget searchBarHome() {
    List<SanPhamModel> products = sanPhamController.all_Products;

    return SearchAnchor.bar(
      suggestionsBuilder: (context, controller) {
        return products
            .where((item) =>
                controller.text.isEmpty ||
                item.tensp
                    .toLowerCase()
                    .contains(controller.text.toLowerCase()))
            .map(
              (e) => ListTile(
                onTap: () {
                  controller.closeView(e.tensp);
                  Get.toNamed("/details", arguments: {'product': e});
                },
                title: Text(e.tensp),
                splashColor: Colors.blue.withOpacity(0.3), // màu ripple
              ),
            );
      },
    );
    // return SearchBar(
    //   hintText: "Search any products...",
    //   leading: Icon(Icons.search),
    //   trailing: [
    //     TextButton(onPressed: ()async{
    //
    //     }, child: Text("Search"))
    //   ],
    //   shape: WidgetStatePropertyAll(
    //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    // );
  }

  Widget Categories() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Categories",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold),
            ),
          ),
          Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [selectCategory(), itemsCategory()],
          ))
        ],
      ),
    );
  }

  Widget bestSeller() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bestsellers",
          style: TextStyle(
              fontSize: 20,
              color: Colors.blue[900],
              fontWeight: FontWeight.bold),
        ),
        bestsellerItems()
      ],
    );
  }

  Widget bestsellerItems() {
    return SizedBox(
      height: Get.height / 5,
      child: ListView.builder(
        itemCount: sanPhamController.bestSeller_items.length,
        itemBuilder: (context, index) {
          final item = sanPhamController.bestSeller_items[index];
          return InkWell(
            onTap: () async {
              final sanpham =
                  await sanPhamController.fetchProductById(item.masp);
              Get.toNamed('/details', arguments: {'product': sanpham});
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                    'images/${ApiConstants.getFolderFromCategory(item.maloaisp)}/${item.img}'),
              ),
              title: Text(
                item.tensp,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                "${item.soluong} sold",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget selectCategory() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((e) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              selectedColor: Colors.blueGrey,
              showCheckmark: false,
              backgroundColor: Colors.greenAccent,
              label: Text(
                e['name']!,
                style: TextStyle(
                    color: sanPhamController.selectedCategory.value == e['name']
                        ? Colors.white
                        : Colors.black),
              ),
              avatar: Image.asset(
                "${e['image']}",
                height: 30,
                width: 30,
              ),
              selected: sanPhamController.selectedCategory.value == e['name'],
              onSelected: (value) {
                sanPhamController.selectedCategory.value = e['name']!;
                sanPhamController.loadData();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget itemsCategory() {
    return Scrollbar(
        thumbVisibility: true,
        controller: _controller,
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          child: Row(
              children: sanPhamController.categoryProducts.map(
            (e) {
              return itemCategory(e);
            },
          ).toList()),
        ));
  }

  Widget itemCategory(SanPhamModel sp) {
    final folder = getFolderFromCategory(sp.maloaisp);
    String priceformat =
        NumberFormat("#,###", 'vi_VN').format(sp.dongia.toInt());
    return InkWell(
      onTap: () async {
        final sanpham = await sanPhamController.fetchProductById(sp.masp);
        Get.toNamed('/details', arguments: {'product': sanpham});
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height / 5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image.asset('images/$folder/${sp.img}'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        sp.tensp,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '$priceformat đ',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
