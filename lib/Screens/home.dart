import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zorp/widgets/DefaultButton.dart';
import 'package:zorp/Screens/SubmittedScreen.dart';
import 'package:zorp/widgets/camera_recorder.dart';
import 'package:zorp/Screens/video_player.dart';
import '../widgets/RecordedAudio.dart';
import '../models/MyJson.dart';
import '../widgets/view.dart';

class HomePage extends StatefulWidget {
  List<CameraDescription>? cameras = [];
  int? chosenJsonNumber;
  final String _appTitle;

  HomePage(
      {Key? key, required String title, this.cameras, this.chosenJsonNumber})
      : assert(title != null),
        _appTitle = title,
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Directory? appDir;
  late List<String>? records;
  late List<MyJson> data;
  XFile? videoFile;

  @override
  void initState() {
    super.initState();

    getdata(widget.chosenJsonNumber);

    records = [];
    getExternalStorageDirectory().then((value) async {
      appDir = value!;
      // String directoryPath = appDir!.path + '/Audiorecords/';
      // Directory("${appDir!.path}/Audiorecords/").delete(recursive: true);
      // await Directory(directoryPath).create(recursive: true);
      Directory appDirec = Directory("${appDir!.path}/Audiorecords/");
      appDir = appDirec;
      //appDir!.listSync(recursive: false);
      appDir!.list().listen((onData) {
        Directory(onData.path).delete(recursive: true);
      }).onDone(() {
        records = records!.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    appDir = null;
    records = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget._appTitle,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (records!.length == 0)
              ? DefaultButton(
                  btnName: "Record Your Audio",
                  ontap: () async {
                    bool granted = await _getPermissions();
                    if (granted) {
                      show(context);
                    }
                  },
                  btnColor: Colors.brown,
                  highlightColor: Colors.white,
                  isBottom: false)
              : RecordedAudio(
                  records: records!,
                ),
          (videoFile == null)
              ? DefaultButton(
                  btnName: "Record Product Video",
                  ontap: () async {
                    bool granted = await _getPermissions();
                    if (granted) {
                      XFile? file = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraRecorder(
                                  cameras: widget.cameras,
                                  maxLengthInSeconds:
                                      data[0].maxLengthInSeconds)));
                      setState(() {
                        videoFile = file;
                      });
                    }
                  },
                  btnColor: Colors.brown,
                  highlightColor: Colors.white,
                  isBottom: false)
              : Card(
                  elevation: 5,
                  child: ExpansionTile(
                    title: Text(
                      'Recorded Video',
                      style: TextStyle(color: Colors.black),
                    ),
                    children: [
                      Container(
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultButton(
                                btnName: "Play Video",
                                ontap: () {
                                  if (validateForm()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreen(
                                                  videoFile: videoFile,
                                                )));
                                  }
                                  //print(data[1].mandatory);
                                },
                                btnColor: Colors.blue,
                                highlightColor: Colors.white,
                                isBottom: false)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          DefaultButton(
              btnName: "Submit",
              ontap: () {
                if (validateForm()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubmittedScreen()));
                }
                print(data[1].mandatory);
              },
              btnColor: Colors.green,
              highlightColor: Colors.white,
              isBottom: false),
        ],
      ),
    );
  }

  bool validateForm() {
    bool result = true;

    if (data[0].mandatory == true && videoFile == null) {
      Fluttertoast.showToast(
          msg: "Video is Required", backgroundColor: Colors.red);
      result = false;
    }
    if (data[1].mandatory == true && records!.length == 0) {
      Fluttertoast.showToast(
          msg: "Audio is Required", backgroundColor: Colors.red);
      result = false;
    }
    return result;
  }

  Future<bool> _getPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
      Permission.camera
    ].request();
    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.storage] == PermissionStatus.granted &&
        statuses[Permission.microphone] == PermissionStatus.granted) {
      return true;
    } else {
      Fluttertoast.showToast(msg: "Allow required permissions to the app");
      return false;
    }
  }

  _onFinish() {
    records!.clear();
    print(records!.length.toString());
    appDir!.list().listen((onData) {
      records!.add(onData.path);
    }).onDone(() {
      records!.sort();
      records = records!.toList();
      setState(() {});
    });
  }

  void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white70,
          child: Recorder(
            save: _onFinish,
            maxLengthInSeconds: data[1].maxLengthInSeconds,
          ),
        );
      },
    );
  }

  Future<void> getdata(int? index) async {
    final String response = await rootBundle
        .loadString('fakeData/fakeData${index.toString()}.json');
    List<MyJson> mydata = myJsonFromJson(response);

    setState(() {
      data = mydata;
    });
  }
}
