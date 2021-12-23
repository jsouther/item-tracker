import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/screens/detail_screen.dart';
import 'package:wasteagram/screens/new_post_screen.dart';

String formatDate(DateTime date) => DateFormat("yMMMMEEEEd").format(date);

class ListScreen extends StatelessWidget {

  final String title = 'Wasteagram';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),

      //Get the stream of posts from Firestore
      body: StreamBuilder(
        stream: Firestore.instance.collection('posts').orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.documents != null && snapshot.data.documents.length > 0) {
            return Column(
              children: [
                Expanded(
                  child: PostListView(snapshot: snapshot, onTap: navigateToDetailViewScreen),
                  ),
              ]
          );
          } else {  //If there are no posts in firestore, display loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: 
        Semantics(
          child: FloatingActionButton(
            child: Icon(Icons.camera_alt),
            onPressed: () {
              selectPhoto().then((value) {
                navigateToNewPostScreen(context, value);
              });
            },
          ),
          button: true,
          enabled: true,
          onTapHint: 'Select an image from gallery',
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //Going to the new post screen first requires a file (image from gallery) passed to it
  void navigateToNewPostScreen(BuildContext context, File file) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return NewPostScreen(image: file);
      }
    ));
  }

  //Select and return an image file from the gallery
  Future<File> selectPhoto() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    final File file = File(pickedFile.path);
    return file;
  }

  void navigateToDetailViewScreen(BuildContext context, dynamic post) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return DetailScreen(post: post);
      }
    ));
  }

}

//ListView item to display each post
//Displays name and date submitted
class PostListView extends StatelessWidget {

  final AsyncSnapshot snapshot;
  final void Function(BuildContext, DocumentSnapshot) onTap;
  PostListView({this.snapshot, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) {
          var post = snapshot.data.documents[index];
          return ListTile(
            title: Text(
              formatDate(post['date'].toDate())), 
              trailing: Text(post['quantity'].toString()),
            onTap: () => onTap(context, post),
          );
        }
        ),
      ),
    button: true,
    enabled: true,
    onTapHint: 'Display post details',
    );
  }
}