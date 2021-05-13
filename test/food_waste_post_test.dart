import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/models/food_waste_post.dart';

void main() {
  test('Post created from document Map should have correct values', () {
    final date = Timestamp.now();
    const imageURL = 'test';
    const quantity = 20;
    const latitude = 17.0;
    const longitude = 100.5;

    var doc = {
      'date': date,
      'quantity': quantity,
      'latitude': latitude,
      'longitude': longitude,
      'imageURL': imageURL
    };

    var foodWastePost = FoodWastePost.fromDoc(doc);

    expect(foodWastePost.date, date.toDate());
    expect(foodWastePost.quantity, quantity);
    expect(foodWastePost.latitude, latitude);
    expect(foodWastePost.longitude, longitude);
    expect(foodWastePost.imageURL, imageURL);
  });

  test('Post created without supplying date as a TimeStamp should fail', () {
    final date = DateTime.now();
    const imageURL = 'test';
    const quantity = 20;
    const latitude = 17.0;
    const longitude = 100.5;

    var doc = {
      'date': date,
      'quantity': quantity,
      'latitude': latitude,
      'longitude': longitude,
      'imageURL': imageURL
    };

    // this is a little different than setup and testing shown in exploration,
    // I wanted to test that the object only took DateStamps and not DateTimes
    expect(()=>FoodWastePost.fromDoc(doc),throwsNoSuchMethodError);
  });



}
