class TripModel {
  String title;
  DateTime date;
  String location;
  String imageUrl;
  bool isDraft;
  TripModel({
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    this.isDraft = false,
  });
}
