class FoodWastePost {
  DateTime date;
  String imageURL;
  int quantity;
  double latitude;
  double longitude;

  FoodWastePost({this.date, this.imageURL, this.quantity, this.latitude, this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'imageURL': imageURL,
      'quantity': quantity,
      'latitude': latitude,
      'longitude': longitude
    };
  }

}