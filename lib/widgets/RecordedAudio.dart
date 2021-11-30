import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

class RecordedAudio extends StatefulWidget {
  final List<String> records;
  const RecordedAudio({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  _RecordedAudioState createState() => _RecordedAudioState();
}

class _RecordedAudioState extends State<RecordedAudio> {
  late int _totalTime;
  late int _currentTime;
  double _percent = 0.0;
  int _selected = -1;
  bool isPlay = false;
  AudioPlayer advancedPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return widget.records.length > 0
        ? Card(
            elevation: 5,
            child: ExpansionTile(
              title: Text(
                'Audio Record ${widget.records.length - widget.records.length - 1}',
                style: TextStyle(color: Colors.black),
              ),
              onExpansionChanged: ((newState) {
                if (newState) {
                  setState(() {
                    _selected = widget.records.length - 1;
                  });
                }
              }),
              children: [
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        minHeight: 5,
                        backgroundColor: Colors.black,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        value: _selected == widget.records.length - 1
                            ? _percent
                            : 0,
                      ),
                      Row(
                        children: [
                          (isPlay)
                              ? _AudioControl(
                                  ico: Icons.pause,
                                  onPressed: () {
                                    setState(() {
                                      isPlay = false;
                                    });
                                    advancedPlayer.pause();
                                  })
                              : _AudioControl(
                                  ico: Icons.play_arrow,
                                  onPressed: () {
                                    setState(() {
                                      isPlay = true;
                                    });
                                    advancedPlayer.play(
                                        widget.records.elementAt(
                                            widget.records.length - 1),
                                        isLocal: true);
                                    setState(() {});
                                    setState(() {
                                      _selected = widget.records.length - 1;
                                      _percent = 0.0;
                                    });
                                    advancedPlayer.onPlayerCompletion
                                        .listen((_) {
                                      setState(() {
                                        _percent = 0.0;
                                      });
                                    });
                                    advancedPlayer.onDurationChanged
                                        .listen((duration) {
                                      setState(() {
                                        _totalTime = duration.inMicroseconds;
                                      });
                                    });
                                    advancedPlayer.onAudioPositionChanged
                                        .listen((duration) {
                                      setState(() {
                                        _currentTime = duration.inMicroseconds;
                                        _percent = _currentTime.toDouble() /
                                            _totalTime.toDouble();
                                      });
                                    });
                                  }),
                          _AudioControl(
                              ico: Icons.stop,
                              onPressed: () {
                                advancedPlayer.stop();
                                setState(() {
                                  _percent = 0.0;
                                });
                              }),
                          _AudioControl(
                              ico: Icons.share,
                              onPressed: () {
                                Directory appDirec = Directory(widget.records
                                    .elementAt(widget.records.length - 1));
                                List<String> list = List.empty(growable: true);
                                list.add(appDirec.path);
                                Share.shareFiles(list);
                              }),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}

class _AudioControl extends StatelessWidget {
  final IconData ico;
  final VoidCallback onPressed;

  const _AudioControl({Key? key, required this.ico, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 48.0,
      child: RaisedButton(
          child: Icon(
            ico,
            color: Colors.white,
          ),
          onPressed: onPressed),
    );
  }
}
