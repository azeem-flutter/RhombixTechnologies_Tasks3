class TripModel {
  String title;
  DateTime date;
  String location;
  String imageUrl;
  bool isDraft;
  List<PackingItem> packingList;
  TripModel({
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    this.isDraft = false,
    List<PackingItem>? packingList,
  }) : packingList = packingList ?? const [];
}

class PackingItem {
  final String label;
  final bool isEssential;

  const PackingItem({required this.label, this.isEssential = false});
}
