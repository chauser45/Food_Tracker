
class FoodWastePost {
  DateTime date;
  String imageURL;
  int quantity;
  double latitude;
  double longitude;

  FoodWastePost(
      {this.date, this.imageURL, this.quantity, this.latitude, this.longitude});

  FoodWastePost.fromDoc(var document) {
    date = document['date'].toDate();
    quantity = document['quantity'];
    imageURL = document['imageURL'];
    longitude = document['longitude'];
    latitude = document['latitude'];
  }
}
