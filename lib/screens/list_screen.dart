import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/main.dart';
import 'package:wasteagram/models/food_waste_post.dart';
import '../app.dart';
import '../components/waste_scaffold.dart';
import 'package:intl/intl.dart';
import 'detail_screen.dart';
import 'new_post_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key key, this.title}) : super(key: key);

  final String title;
  final DateFormat dateFormat = DateFormat("EEEE, MMM. d");

  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  File image;
  final picker = ImagePicker();
  // Grab the posts colleection off firebase and create a ListTile for each post
  @override
  Widget build(BuildContext context) {
    AppState appState = context.findAncestorStateOfType<AppState>();
    return WasteScaffold(
        title: title,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data.documents != null &&
                snapshot.data.documents.length > 0) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        var document = snapshot.data.documents[index];
                        FoodWastePost post = FoodWastePost.fromDoc(document);
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(color: Colors.white),
                            )),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 30, bottom: 10, top: 10),
                              child: ListTile(
                                title: Text(
                                    '${widget.dateFormat.format(post.date)}',
                                    style: TextStyle(fontSize: 20)),
                                trailing: Text(
                                  post.quantity.toString(),
                                  style: TextStyle(fontSize: 30),
                                ),
                                onTap: () =>
                                    pushDetail(context, appState, post),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: newPostButton())
                ],
              );
            } else {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(height: 100),
                    newPostButton()
                  ]);
            }
          },
        ));
  }

  // push the detailScreen to front and pass it the current post for this listTile
  void pushDetail(BuildContext context, AppState appState, FoodWastePost post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailScreen(
                  title: title,
                  post: post,
                )));
  }

  Widget newPostButton() {
    return SizedBox(
      height: 50,
      width: 200,
      child: Semantics(
          button: true,
          enabled: true,
          onTapHint:
              'Lets the user take a picture to begin submitting a new waste post',
          child: RaisedButton(
              child: Text("New Post", style: TextStyle(fontSize: 20)),
              onPressed: () {
                getImage();
              })),
    );
  }

  // Uses ImagePicker to prompt user to take a photo with the camera. Stores the image as a file to be passed to the NewPostScreen
  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    image = File(pickedFile.path);
    setState(() {});
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewPostScreen(title: title, image: image)));
  }
}
