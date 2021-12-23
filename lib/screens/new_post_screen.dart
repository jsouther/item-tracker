import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasteagram/models/food_waste_post.dart';

class NewPostScreen extends StatefulWidget {

  final File image;

  NewPostScreen({this.image});

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormState>();
    final foodWastePost = FoodWastePost();

    String validateInt(value) {
      if (value.isEmpty) {
        return 'Please enter a number';
      } else {
        return null;
      }
    }

    void saveQuantity(value) {
      foodWastePost.quantity = num.tryParse(value);
    }

    addLocationToPost() async {
      //Mostly from code provided in the Platform Hardware Services exploration module
      //---------------------------------------------------
      LocationData locationData;
      var locationService = Location();
      
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
    //--------------------------------------------------------
    foodWastePost.latitude = locationData.latitude;
    foodWastePost.longitude = locationData.longitude;
    }

    void addDateToPost() {
      foodWastePost.date = DateTime.now();
    }

    void addImageURLToPost(value) {
      foodWastePost.imageURL = value.toString();
    }

    uploadImageToFirebase() async {
      StorageReference storageReference = FirebaseStorage.instance.ref().child(DateTime.now().toString());
      StorageUploadTask uploadTask = storageReference.putFile(widget.image);
      await uploadTask.onComplete;
      return await storageReference.getDownloadURL();
    }

    void savePost() async {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        Navigator.pop(context);
        await addLocationToPost();
        addDateToPost();
        final url = await uploadImageToFirebase();
        addImageURLToPost(url);
        final postMap = foodWastePost.toMap();
        Firestore.instance.collection('posts').add(postMap);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('New Post'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: Image.file(widget.image)
            ),
            NumberOnlyFormField(validator: validateInt, onSaved: saveQuantity),
            BottomAlignedBigButton(formKey: formKey, onPressed: savePost),
          ]
        )
      ),
    );
  }
}
  

//CUSTOM WIDGETS
class NumberOnlyFormField extends StatelessWidget {

  final String Function(dynamic) validator;
  final void Function(dynamic) onSaved;

  NumberOnlyFormField({this.validator, this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Number of Wasted Items',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        onSaved: onSaved,
        validator: validator
      ),
    enabled: true,
    textField: true,
    onTapHint: 'Enter number of wasted items',
    );
  }
}

class BottomAlignedBigButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final void Function() onPressed;

  BottomAlignedBigButton({this.formKey, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: MaterialButton(
            minWidth: double.infinity,
            height: 100,
            color: ButtonTheme.of(context).colorScheme.primary,
            onPressed: onPressed,
            child: Icon(Icons.cloud_upload),
          ),
        ),
        enabled: true,
        button: true,
        onTapHint: 'Upload post to the cloud',
      ),
    );
  }
}