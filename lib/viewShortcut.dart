import 'package:flutter/material.dart';

import 'deviceTypes/roku.dart';
import 'deviceTypes/stringToInstance.dart';

class ViewShortcut extends StatelessWidget {
  final String name;
  final List actions;
  final String device;
  final Widget selectDevice;

  ViewShortcut({this.name, this.actions, this.device, this.selectDevice});

  String formatAction(String action) {
    String formatted =
        action[0].toUpperCase() + action.substring(1); //cap first letter
    RegExp exp = RegExp("/([A-Z])/g");
    Iterable<RegExpMatch> matches = exp.allMatches(formatted);

    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: IconButton(
          icon: Icon(Icons.play_arrow_rounded),
          onPressed: () {
            showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return selectDevice;
                });
          },
        ),
      ),
      body: Center(
          child: Column(children: [
        Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: actions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(
                          stringToInstance(device).actionIcon(actions[index])),
                      title: Text(
                        formatAction(actions[index]),
                      ),
                      trailing:
                          Icon(Icons.arrow_right_alt, color: Colors.white),
                    ),
                  );
                }))
      ])),
    );
  }
}
