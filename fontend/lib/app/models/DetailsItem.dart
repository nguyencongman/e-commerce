class detailsItem{
  int magiohang;
  int masp;
  double dongia;
  double thanhtien;
  String size;

  detailsItem({
    required this.magiohang,
    required this.masp,
    required this.dongia,
    required this.thanhtien,
    required this.size,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'detailsItem(magiohang:${magiohang} ,masp:${masp} ,dongia:${dongia} ,'
        'thanhtien:${thanhtien} ,size:${size} ,)';
  }
  Map<String,dynamic> tojson() {
    return {
      'magiohang':this.magiohang,
      'masp':this.masp,
      'dongia':this.dongia,
      'thanhtien':this.thanhtien,
      'size':this.size
    };
  }



}