import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onemote/deviceTypes/roku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RokuRemote extends StatefulWidget {
  final Roku roku;
  final String name;
  RokuRemote(this.roku, this.name);

  @override
  _RokuRemoteState createState() => _RokuRemoteState();
}

class _RokuRemoteState extends State<RokuRemote> {
  bool _isRecording = false;
  List _recordedActions = [];
  String _shortcutName = 'My Shortcut 1';
  final iconColor = Color(0xffFEFFFE);

  final buttonColor = Color(0xff2A2431);

  final remoteControlKey = GlobalKey();

  Widget makeTopButton(IconData icon, Function function) {
    return ElevatedButton(
      onPressed: function,
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color(0xff504957)))),
          backgroundColor: MaterialStateProperty.all(Color(0xff2A2431))),
      child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(icon, size: 30, color: Color(0xffC8C8CA))),
    );
  }

  Widget makeBottomButton(IconData icon, Function function) {
    return ElevatedButton(
      onPressed: function,
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color(0xff3B3440)))),
          backgroundColor: MaterialStateProperty.all(Color(0xff161418))),
      child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(icon, size: 30, color: Color(0xffC8C8CA))),
    );
  }

  Widget makeTabBar(IconData icon, String label, bool isSelected,
      {Color background, Function onTap}) {
    return InkWell(
        onTap: onTap,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  color: background == null
                      ? isSelected
                          ? Color(0xffFEFFFE)
                          : Color(0xff414041)
                      : background,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: IconButton(
                  padding: EdgeInsets.fromLTRB(background == null ? 5 : 20, 5,
                      background == null ? 5 : 20, 5),
                  icon: Icon(icon, size: 20),
                  onPressed: onTap,
                  color: isSelected ? Colors.black : Colors.white)),
          Text(label, style: TextStyle(color: Color(0xff6F6E6F)))
        ]));
  }

  void coreClick(String methodName) {
    //TODO: Add support for params using contatnated flags in methodName
    widget.roku.run(methodName);
    if (_isRecording) {
      _recordedActions.add(methodName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.name),
            backgroundColor: Color(0xff662D91),
            leading: IconButton(
              icon: Icon(Icons.close_rounded),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Power Off "${widget.name}"? '),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Would you like to turn off this device?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Power Off',
                              style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            widget.roku.powerOff();
                          },
                        ),
                        TextButton(
                          child: Text('Keep Running'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.power_settings_new_rounded,
                    color: Colors.red,
                  ))
            ]),
        body: Container(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: Icon(Icons.settings_rounded,
                                size: 30, color: iconColor),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(Icons.keyboard_rounded,
                                size: 30, color: iconColor),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(Icons.search_rounded,
                                size: 30, color: iconColor),
                            onPressed: () {})
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        makeTopButton(FontAwesomeIcons.longArrowAltLeft, () {
                          coreClick('back');
                        }),
                        makeTopButton(FontAwesomeIcons.asterisk, () {
                          coreClick('info');
                        }),
                        makeTopButton(Icons.home_rounded, () {
                          coreClick('home');
                        }),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Stack(children: [
                    Image.asset('assets/rokuRemote.webp',
                        key: remoteControlKey,
                        width: MediaQuery.of(context).size.width - 115),
                    Positioned(
                        left: ((MediaQuery.of(context).size.width - 100) - 95) /
                            2,
                        child: Opacity(
                            opacity: 0,
                            child: ElevatedButton(
                              onPressed: () {
                                coreClick('up');
                              },
                              child: SizedBox(
                                  height: (MediaQuery.of(context).size.width -
                                          100) /
                                      5,
                                  width: ((MediaQuery.of(context).size.width -
                                              100) /
                                          4) -
                                      5),
                            ))),
                    Positioned(
                        bottom: 0,
                        left: ((MediaQuery.of(context).size.width - 100) - 95) /
                            2,
                        child: Opacity(
                            opacity: 0,
                            child: ElevatedButton(
                              onPressed: () {
                                coreClick('down');
                              },
                              child: SizedBox(
                                  height: (MediaQuery.of(context).size.width -
                                          100) /
                                      5,
                                  width: ((MediaQuery.of(context).size.width -
                                              100) /
                                          4) -
                                      5),
                            ))),
                    Positioned(
                        top: ((MediaQuery.of(context).size.width - 100) / 2) -
                            50,
                        left: ((MediaQuery.of(context).size.width - 100) / 2) -
                            150,
                        child: Opacity(
                            opacity: 0,
                            child: ElevatedButton(
                              onPressed: () {
                                coreClick('left');
                              },
                              child: SizedBox(
                                  height: (MediaQuery.of(context).size.width +
                                          110) /
                                      5,
                                  width: ((MediaQuery.of(context).size.width -
                                              100) /
                                          4) -
                                      5),
                            ))),
                    Positioned(
                        top: ((MediaQuery.of(context).size.width - 100) / 2) -
                            50,
                        right: ((MediaQuery.of(context).size.width - 100) / 2) -
                            150,
                        child: Opacity(
                            opacity: 0,
                            child: ElevatedButton(
                              onPressed: () {
                                coreClick('right');
                              },
                              child: SizedBox(
                                  height: (MediaQuery.of(context).size.width +
                                          110) /
                                      5,
                                  width: ((MediaQuery.of(context).size.width -
                                              100) /
                                          4) -
                                      5),
                            ))),
                    Positioned(
                        top: ((MediaQuery.of(context).size.width - 100) / 2) -
                            50,
                        left: ((MediaQuery.of(context).size.width - 195) / 2),
                        child: Opacity(
                            opacity: 0,
                            child: ElevatedButton(
                              onPressed: () {
                                coreClick('select');
                              },
                              child: SizedBox(
                                  height: (MediaQuery.of(context).size.width +
                                          110) /
                                      5,
                                  width: ((MediaQuery.of(context).size.width -
                                              100) /
                                          4) -
                                      5),
                            )))
                  ])),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(25, 25, 25, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        makeBottomButton(Icons.undo, () {
                          coreClick('instantReplay');
                        }),
                        makeBottomButton(Icons.mic, () {
                          coreClick('instantReplay');
                        }),
                        makeBottomButton(Icons.headset_rounded, () {
                          coreClick('instantReplay');
                        }),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        makeBottomButton(Icons.fast_rewind_rounded, () {
                          coreClick('rev');
                        }),
                        makeBottomButton(Icons.play_arrow_rounded, () {
                          coreClick('rev');
                        }),
                        makeBottomButton(Icons.fast_forward_rounded, () {
                          coreClick('fwd');
                        }),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        makeBottomButton(Icons.volume_off, () {
                          coreClick('fwd');
                        }),
                        makeBottomButton(Icons.volume_down_rounded, () {
                          coreClick('volumeDown');
                        }),
                        makeBottomButton(Icons.volume_up_rounded, () {
                          coreClick('volumeUp');
                        }),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        makeTabBar(Icons.settings_remote, 'Remote', true,
                            onTap: () {}),
                        makeTabBar(Icons.touch_app, 'Record Actions', false,
                            background: Colors.red, onTap: () async {
                          print("clicked");
                          if (!_isRecording) {
                            print("started recording actions");
                            setState(() {
                              _isRecording = true;
                            });
                          } else {
                            print("parsing recording actions");

                            setState(() {
                              _isRecording = false;
                            });

                            //finished recording session

                            //copy data locally and reset global list
                            List localList = _recordedActions;
                            _recordedActions = [];

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Name Your Shourtcut'),
                                    content: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _shortcutName = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          hintText: "My Shortcut 1"),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red)),
                                        child: Text('Discard',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xff662D91))),
                                        child: Text('Save',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () async {
                                          print('saving...');
                                          final prefs = await SharedPreferences
                                              .getInstance();

                                          String existingIndex =
                                              prefs.getString('shortcutsIndex');

                                          var parsedExistingIndex = jsonDecode(
                                              jsonEncode({"shortcuts": []}));

                                          if (existingIndex != null) {
                                            parsedExistingIndex =
                                                jsonDecode(existingIndex);
                                          }

                                          var shoutcutData = {
                                            "name": _shortcutName,
                                            "deviceType": "Roku",
                                            "createdOn": "deviceID",
                                            "actions": localList
                                          };

                                          parsedExistingIndex['shortcuts']
                                              .add(jsonEncode(shoutcutData));

                                          prefs.setString('shortcutsIndex',
                                              jsonEncode(parsedExistingIndex));

                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        }),
                        makeTabBar(Icons.filter_none, 'Channels', false,
                            onTap: () {}),
                      ],
                    ))
              ],
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xff272329),
                      Color(0xff231E24),
                      Color(0xff211E24),
                      Color(0xff18191B),
                      Color(0xff151514),
                      Color(0xff111011),
                    ],
                    begin: const FractionalOffset(0.2, 0.0),
                    end: const FractionalOffset(0.5, 0.5),
                    stops: [0.0, 0.3, 0.65, 0.75, 0.8, 1.0],
                    tileMode: TileMode.clamp))));
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.3821970, size.height * 0.9181356);
    path_0.cubicTo(
        size.width * 0.3668939,
        size.height * 0.9092373,
        size.width * 0.3569697,
        size.height * 0.8970339,
        size.width * 0.3538636,
        size.height * 0.8834746);
    path_0.cubicTo(
        size.width * 0.3525758,
        size.height * 0.8779661,
        size.width * 0.3515152,
        size.height * 0.8276271,
        size.width * 0.3515152,
        size.height * 0.7728814);
    path_0.cubicTo(
        size.width * 0.3515152,
        size.height * 0.7211864,
        size.width * 0.3507576,
        size.height * 0.6910169,
        size.width * 0.3490909,
        size.height * 0.6800847);
    path_0.cubicTo(
        size.width * 0.3486364,
        size.height * 0.6768644,
        size.width * 0.3473485,
        size.height * 0.6724576,
        size.width * 0.3463636,
        size.height * 0.6704237);
    path_0.cubicTo(
        size.width * 0.3408333,
        size.height * 0.6592373,
        size.width * 0.3356061,
        size.height * 0.6539831,
        size.width * 0.3228030,
        size.height * 0.6468644);
    path_0.cubicTo(
        size.width * 0.3155303,
        size.height * 0.6427966,
        size.width * 0.3155303,
        size.height * 0.6427966,
        size.width * 0.2375000,
        size.height * 0.6422881);
    path_0.cubicTo(
        size.width * 0.1560606,
        size.height * 0.6416949,
        size.width * 0.1382576,
        size.height * 0.6411864,
        size.width * 0.1325758,
        size.height * 0.6396610);
    path_0.cubicTo(
        size.width * 0.1241667,
        size.height * 0.6372881,
        size.width * 0.1109848,
        size.height * 0.6238136,
        size.width * 0.1062879,
        size.height * 0.6127119);
    path_0.cubicTo(
        size.width * 0.1013636,
        size.height * 0.6009322,
        size.width * 0.1012121,
        size.height * 0.5976271,
        size.width * 0.1018182,
        size.height * 0.4792373);
    path_0.cubicTo(
        size.width * 0.1023485,
        size.height * 0.3775424,
        size.width * 0.1023485,
        size.height * 0.3775424,
        size.width * 0.1051515,
        size.height * 0.3711864);
    path_0.cubicTo(
        size.width * 0.1090909,
        size.height * 0.3621186,
        size.width * 0.1150000,
        size.height * 0.3540678,
        size.width * 0.1212121,
        size.height * 0.3491525);
    path_0.cubicTo(
        size.width * 0.1226515,
        size.height * 0.3480508,
        size.width * 0.1240152,
        size.height * 0.3468644,
        size.width * 0.1242424,
        size.height * 0.3466102);
    path_0.cubicTo(
        size.width * 0.1249242,
        size.height * 0.3457627,
        size.width * 0.1313636,
        size.height * 0.3425424,
        size.width * 0.1340909,
        size.height * 0.3416949);
    path_0.cubicTo(
        size.width * 0.1387879,
        size.height * 0.3401695,
        size.width * 0.1578788,
        size.height * 0.3397458,
        size.width * 0.2382576,
        size.height * 0.3391525);
    path_0.cubicTo(
        size.width * 0.3170455,
        size.height * 0.3385593,
        size.width * 0.3170455,
        size.height * 0.3385593,
        size.width * 0.3215909,
        size.height * 0.3360169);
    path_0.cubicTo(
        size.width * 0.3287121,
        size.height * 0.3322034,
        size.width * 0.3361364,
        size.height * 0.3263559,
        size.width * 0.3400000,
        size.height * 0.3216102);
    path_0.cubicTo(
        size.width * 0.3433333,
        size.height * 0.3176271,
        size.width * 0.3471970,
        size.height * 0.3099153,
        size.width * 0.3490909,
        size.height * 0.3038136);
    path_0.cubicTo(
        size.width * 0.3505303,
        size.height * 0.2991525,
        size.width * 0.3515152,
        size.height * 0.2619492,
        size.width * 0.3515152,
        size.height * 0.2110169);
    path_0.cubicTo(
        size.width * 0.3515152,
        size.height * 0.1546610,
        size.width * 0.3525758,
        size.height * 0.1026271,
        size.width * 0.3538636,
        size.height * 0.09618644);
    path_0.cubicTo(
        size.width * 0.3554545,
        size.height * 0.08838983,
        size.width * 0.3643182,
        size.height * 0.07593220,
        size.width * 0.3727273,
        size.height * 0.06957627);
    path_0.cubicTo(
        size.width * 0.3772727,
        size.height * 0.06610169,
        size.width * 0.3832576,
        size.height * 0.06322034,
        size.width * 0.3886364,
        size.height * 0.06194915);
    path_0.cubicTo(
        size.width * 0.4037879,
        size.height * 0.05813559,
        size.width * 0.5768939,
        size.height * 0.05864407,
        size.width * 0.5895455,
        size.height * 0.06254237);
    path_0.cubicTo(
        size.width * 0.5910606,
        size.height * 0.06296610,
        size.width * 0.5950000,
        size.height * 0.06483051,
        size.width * 0.5982576,
        size.height * 0.06661017);
    path_0.cubicTo(
        size.width * 0.6071212,
        size.height * 0.07144068,
        size.width * 0.6151515,
        size.height * 0.08076271,
        size.width * 0.6200000,
        size.height * 0.09169492);
    path_0.cubicTo(
        size.width * 0.6236364,
        size.height * 0.1000000,
        size.width * 0.6236364,
        size.height * 0.1000000,
        size.width * 0.6241667,
        size.height * 0.2001695);
    path_0.cubicTo(
        size.width * 0.6246212,
        size.height * 0.3004237,
        size.width * 0.6246212,
        size.height * 0.3004237,
        size.width * 0.6283333,
        size.height * 0.3088983);
    path_0.cubicTo(
        size.width * 0.6340909,
        size.height * 0.3222034,
        size.width * 0.6434091,
        size.height * 0.3315254,
        size.width * 0.6556818,
        size.height * 0.3362712);
    path_0.cubicTo(
        size.width * 0.6597727,
        size.height * 0.3379661,
        size.width * 0.6978788,
        size.height * 0.3389831,
        size.width * 0.7691667,
        size.height * 0.3393220);
    path_0.cubicTo(
        size.width * 0.8394697,
        size.height * 0.3397458,
        size.width * 0.8394697,
        size.height * 0.3397458,
        size.width * 0.8450000,
        size.height * 0.3427966);
    path_0.cubicTo(
        size.width * 0.8553788,
        size.height * 0.3484746,
        size.width * 0.8650000,
        size.height * 0.3593220,
        size.width * 0.8693182,
        size.height * 0.3699153);
    path_0.cubicTo(
        size.width * 0.8744697,
        size.height * 0.3826271,
        size.width * 0.8745455,
        size.height * 0.3844915,
        size.width * 0.8739394,
        size.height * 0.5025424);
    path_0.cubicTo(
        size.width * 0.8734091,
        size.height * 0.6038136,
        size.width * 0.8734091,
        size.height * 0.6038136,
        size.width * 0.8713636,
        size.height * 0.6084746);
    path_0.cubicTo(
        size.width * 0.8646970,
        size.height * 0.6241525,
        size.width * 0.8530303,
        size.height * 0.6363559,
        size.width * 0.8415909,
        size.height * 0.6396610);
    path_0.cubicTo(
        size.width * 0.8359848,
        size.height * 0.6411864,
        size.width * 0.8196212,
        size.height * 0.6416102,
        size.width * 0.7382576,
        size.height * 0.6422034);
    path_0.cubicTo(
        size.width * 0.6602273,
        size.height * 0.6427966,
        size.width * 0.6602273,
        size.height * 0.6427966,
        size.width * 0.6511364,
        size.height * 0.6478814);
    path_0.cubicTo(
        size.width * 0.6391667,
        size.height * 0.6544915,
        size.width * 0.6338636,
        size.height * 0.6601695,
        size.width * 0.6284091,
        size.height * 0.6724576);
    path_0.cubicTo(
        size.width * 0.6246212,
        size.height * 0.6809322,
        size.width * 0.6246212,
        size.height * 0.6809322,
        size.width * 0.6240909,
        size.height * 0.7677966);
    path_0.cubicTo(
        size.width * 0.6236364,
        size.height * 0.8562712,
        size.width * 0.6231818,
        size.height * 0.8786441,
        size.width * 0.6218182,
        size.height * 0.8838983);
    path_0.cubicTo(
        size.width * 0.6200000,
        size.height * 0.8912712,
        size.width * 0.6162879,
        size.height * 0.8979661,
        size.width * 0.6102273,
        size.height * 0.9047458);
    path_0.cubicTo(
        size.width * 0.6050000,
        size.height * 0.9105932,
        size.width * 0.6029545,
        size.height * 0.9122034,
        size.width * 0.5955303,
        size.height * 0.9163559);
    path_0.cubicTo(
        size.width * 0.5868182,
        size.height * 0.9211864,
        size.width * 0.5868182,
        size.height * 0.9211864,
        size.width * 0.4871212,
        size.height * 0.9211864);
    path_0.cubicTo(
        size.width * 0.3874242,
        size.height * 0.9211864,
        size.width * 0.3874242,
        size.height * 0.9211864,
        size.width * 0.3821970,
        size.height * 0.9181356);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff5f2993).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
