import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) => DateFormat("yMMMMEEEEd").format(date);

class DetailScreen extends StatelessWidget {

  final dynamic post;
  DetailScreen({this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wasteagram'),
        centerTitle: true,
      ),
      body: 
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(formatDate(post['date'].toDate()), style: Theme.of(context).textTheme.headline5),
              Image.network(post['imageURL']),
              Text('${post['quantity']} items', style: Theme.of(context).textTheme.headline4),
              Text('Location: (${post['latitude']}, ${post['longitude']})')
            ],
          ),
        ),
    );
  }
}