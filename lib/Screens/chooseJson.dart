import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:zorp/Screens/home.dart';

import '../widgets/DefaultButton.dart';

class ChooseJson extends StatelessWidget {
  List<CameraDescription>? cameras = [];
  int? chosenJsonNumber;
  String? appTitle;
  ChooseJson({Key? key, this.cameras, this.appTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DefaultButton(
              btnName: "Choose 1st Json",
              ontap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              cameras: cameras,
                              title: appTitle!,
                              chosenJsonNumber: 1,
                            )));
              },
              btnColor: Colors.black,
              highlightColor: Colors.white,
              isBottom: false),
          DefaultButton(
              btnName: "Choose 2nd Json",
              ontap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              cameras: cameras,
                              title: appTitle!,
                              chosenJsonNumber: 2,
                            )));
              },
              btnColor: Colors.black,
              highlightColor: Colors.white,
              isBottom: false),
        ],
      ),
    );
  }
}
