import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vibrate/vibrate.dart';

class Roku {
  final String ip;
  Roku({this.ip = ' '});

  Uri uriPath(String path) {
    print(ip + '/' + path);
    return Uri.parse(ip + '/' + path);
  }

  Future post(Uri url) {
    return http.post(url, headers: {
      "User-Agent": "Roku/5 CFNetwork/1220.1 Darwin/20.3.0",
      "Accept": "*/*",
      "Accept-Language": "en-us",
      //"Accept-Encoding": "gzip, deflate",  //only on supported platforms (iOS)
    });
  }

  void powerOn() async {
    await post(uriPath('keypress/PowerOn'));
  }

  void powerOff() async {
    await post(uriPath('keypress/PowerOff'));
  }

  void powerToggle() async {
    await post(uriPath('keypress/Power'));
  }

  void right() async {
    await post(uriPath('keypress/Right'));
  }

  void left() async {
    await post(uriPath('keypress/Left'));
  }

  void home() async {
    await post(uriPath('keypress/Home'));
  }

  void rev() async {
    await post(uriPath('keypress/Rev'));
  }

  void fwd() async {
    await post(uriPath('keypress/Fwd'));
  }

  void select() async {
    await post(uriPath('keypress/Select'));
  }

  void up() async {
    await post(uriPath('keypress/Up'));
  }

  void down() async {
    await post(uriPath('keypress/Down'));
  }

  void back() async {
    await post(uriPath('keypress/Back'));
  }

  void instantReplay() async {
    await post(uriPath('keypress/InstantReplay'));
  }

  void info() async {
    await post(uriPath('keypress/Info'));
  }

  void backspace() async {
    await post(uriPath('keypress/Backspace'));
  }

  void search() async {
    await post(uriPath('keypress/Search'));
  }

  void enter() async {
    await post(uriPath('keypress/Enter'));
  }

  void launch(String appID) async {
    await post(uriPath('launch/' + appID));
  }

  void install(String appID) async {
    await post(uriPath('install/' + appID));
  }

  void appIcon(String appID) async {
    await post(uriPath('query/icon/' + appID)); //parse xml
  }

  void channels(String appID) async {
    await post(uriPath('query/apps')); //parse xml
  }

  void activeChannel() async {
    await post(uriPath('query/tv-active-channel')); //parse xml
  }

  void volumeUp() async {
    await post(uriPath('keypress/VolumeUp'));
  }

  void volumeDown() async {
    await post(uriPath('keypress/VolumeDown'));
  }

  void play() async {
    await post(uriPath('keypress/Play'));
  }

  void pause() async {
    await post(uriPath('keypress/Pause'));
  }

  void type(String typeString) async {
    await post(uriPath('keypress/LIT_' + typeString));
  }

  void run(String methodName,
      {String appID = '', bool hapticFeedback, String typeString = ''}) {
    if (hapticFeedback == null) {
      hapticFeedback = Platform.isIOS;
    }

    if (hapticFeedback) Vibrate.feedback(FeedbackType.light);

    switch (methodName) {
      case 'powerOn':
        return powerOn();
      case 'powerOff':
        return powerOff();
      case 'powerToggle':
        return powerToggle();
      case 'right':
        return right();
      case 'left':
        return left();
      case 'home':
        return home();
      case 'rev':
        return rev();
      case 'select':
        return select();
      case 'up':
        return up();
      case 'down':
        return down();
      case 'back':
        return back();
      case 'instantReplay':
        return instantReplay();
      case 'info':
        return info();
      case 'backspace':
        return backspace();
      case 'search':
        return search();
      case 'enter':
        return enter();
      case 'activeChannel':
        return activeChannel();
      case 'launch':
        return launch(appID);
      case 'install':
        return install(appID);
      case 'appIcon':
        return appIcon(appID);
      case 'volumeUp':
        return volumeUp();
      case 'volumeDown':
        return volumeDown();
      case 'play':
        return play();
      case 'pause':
        return pause();
      case 'type':
        return type(typeString);
    }
  }

  IconData actionIcon(methodName) {
    switch (methodName) {
      case 'right':
        return Icons.subdirectory_arrow_right_rounded;
      case 'left':
        return Icons.subdirectory_arrow_left_rounded;
      case 'home':
        return Icons.home_rounded;
      case 'rev':
        return Icons.fast_rewind_rounded;
      case 'select':
        return Icons.touch_app_rounded;
      case 'up':
        return Icons.north;
      case 'down':
        return Icons.south;
      case 'back':
        return FontAwesomeIcons.longArrowAltLeft;
      case 'instantReplay':
        return Icons.undo;
      case 'info':
        return FontAwesomeIcons.asterisk;
      case 'backspace':
        return Icons.backspace_rounded;
      case 'search':
        return Icons.search_rounded;
      case 'enter':
        return Icons.keyboard_return_rounded;
      case 'launch':
        return Icons.launch;
      case 'volumeUp':
        return Icons.volume_up_rounded;
      case 'volumeDown':
        return Icons.volume_down_rounded;
      case 'play':
        return Icons.play_circle_fill_rounded;
      case 'pause':
        return Icons.pause_circle_filled_rounded;
    }
  }
}
