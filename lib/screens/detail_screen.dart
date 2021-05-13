import 'package:flutter/material.dart';
import '../models/food_waste_post.dart';
import '../components/waste_scaffold.dart';
import 'dart:io';
import 'package:intl/intl.dart';


class DetailScreen extends StatefulWidget {
  DetailScreen({Key key, this.title, this.post}) : super(key: key);

  final FoodWastePost post;
  final String title;
  static final DateFormat dateFormat = DateFormat("EEEE, MMM. d yyyy");

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  File image;
  
  @override
  Widget build(BuildContext context) {
    return WasteScaffold(
      title: widget.title,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Column(children: [
            Text('${DetailScreen.dateFormat.format(widget.post.date)}',
                style: TextStyle(fontSize: 30)),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: RotatedBox(
                quarterTurns: 3,
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.network(widget.post.imageURL)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('Items: ${widget.post.quantity}',
                  style: TextStyle(fontSize: 40)),
            ),
            Text('(${widget.post.latitude}, ${widget.post.longitude})',
                style: TextStyle(fontSize: 24)),
          ]),
        ),
      ),
    );
  }
}
