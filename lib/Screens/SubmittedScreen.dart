import 'package:flutter/material.dart';
import 'package:zorp/Screens/chooseJson.dart';

class SubmittedScreen extends StatefulWidget {
  @override
  _SubmittedScreenState createState() => _SubmittedScreenState();
}

class _SubmittedScreenState extends State<SubmittedScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  "Your form has been submitted.",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(5),
                color: Colors.green,
                child: InkWell(
                  onTap: () {},
                  splashColor: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    //width: double.infinity,
                    height: 40,
                    width: 80,
                    child: Center(
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
