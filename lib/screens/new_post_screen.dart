import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:wasteagram/main.dart';
import 'package:wasteagram/models/food_waste_post.dart';
import '../app.dart';
import '../components/waste_scaffold.dart';
import 'package:intl/intl.dart';
import 'detail_screen.dart';
import 'package:location/location.dart';

class NewPostScreen extends StatefulWidget {
  final String title;
  final File image;

  NewPostScreen({Key key, this.title, this.image}) : super(key: key);

  @override
  NewPostScreenState createState() => NewPostScreenState();
}

class NewPostScreenState extends State<NewPostScreen> {
  final formKey = GlobalKey<FormState>();
  double latitude;
  double longitude;
  int quantity;
  LocationData locationData;
  var locationService = Location();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  @override
  Widget build(BuildContext context) {
    return WasteScaffold(
      title: title,
      body: Center(
        child: Form(
          key: formKey,
          child: Column(children: [
            SizedBox(
                width: 250,
                height: 250,
                child: RotatedBox(
                    quarterTurns: 3,
                    child: Semantics(
                        image: true,
                        hint: 'An image of food waste',
                        child: Image.file(widget.image)))),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Number of Items:',
                    border: OutlineInputBorder(),
                    hintText: 'Enter the quantity of this wasted item'),
                validator: (value) => validateQuantity(value),
                onSaved: (value) {
                  quantity = int.parse(value);
                },
              ),
            ),
            SizedBox(
                height: 100,
                width: 100,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Semantics(
                    button: true,
                    enabled: true,
                    onTapHint:
                        'Submits the current photo and quantity as a new post',
                    child: IconButton(
                      icon: Icon(Icons.upload_sharp),
                      onPressed: () => validateAndUpload(context),
                    ),
                  ),
                ))
          ]),
        ),
      ),
    );
  }

  String validateQuantity(String rating) {
    if (rating == '') {
      return 'This field cannot be blank';
    } else {
      return null;
    }
  }

  // call to validate the form, checking that quantity is not empty, then saves
  // and uploads the image to the cloud storage in firebase. Waits for the cloud url to
  // return and then uses that to save a post in the firebase collection
  void validateAndUpload(BuildContext context) async {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formKey.currentState.save();
      var imageURL = await postImage(widget.image);
      // convert location data to the correct decimla places
      latitude = double.parse(locationData.latitude.toStringAsFixed(3));
      longitude = double.parse(locationData.longitude.toStringAsFixed(3));
      FirebaseFirestore.instance.collection('posts').add({
        'quantity': quantity,
        'date': DateTime.now(),
        'imageURL': imageURL,
        'latitude': latitude,
        'longitude': longitude
      });
      Navigator.pop(context);
    }
  }

// posts the current image to cloud storage
  Future postImage(File image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(DateTime.now().toString());
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    final url = await storageReference.getDownloadURL();
    return url;
  }

  // below method taken from location package documentation and professor's example.
  void retrieveLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }
      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }
      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    setState(() {});
  }
}
