import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onemote/viewShortcut.dart';
import 'package:upnp/upnp.dart' as upnp;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_icons/simple_icons.dart';

import 'deviceTypes/roku.dart';
import 'remotes/RokuRemote.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneMote',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'OneMote'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _listKey = GlobalKey<AnimatedListState>();
  var devices = [];
  int validDevices = 0;
  int _selectedIndex = 0;
  bool _dropDownActive = false;

  //get index then get indi shortcut through futurebuilder

  Future<String> getShortcutIndex() async {
    final prefs = await SharedPreferences.getInstance();
    String index = prefs.getString('shortcutsIndex');
    return index;
  }

  //var _shortcutMap = jsonDecode(
  //'{"shortcuts": [{"name": "shortcut 1", "deviceType": "Roku", "createdOn": "MasterTV","actions": ["right", "left", "right"]},{"name": "shortcut 2", "deviceType": "Roku", "createdOn": "MasterTV", "actions": ["right", "left", "right"]}]}');

  List filterDevices(String deviceType) {
    List filteredList = [];

    devices.forEach((device) {
      if (device['type'].toUpperCase() == deviceType.toUpperCase())
        filteredList.add(device);
    });

    return filteredList;
  }

  bool _shortcutInProg = false;

  void scan() async {
    var disc = new upnp.DeviceDiscoverer();
    disc.quickDiscoverClients().listen((client) async {
      try {
        var dev = await client.getDevice();
        print("${dev.friendlyName}: ${dev.urlBase}");
        String address = 'http://' + dev.urlBase.split('/')[2];
        print(address);
        var iconMap = {
          'Roku': CircleAvatar(
              backgroundColor: Color(0xff662D91),
              child: Icon(
                SimpleIcons.roku,
                color: Colors.white,
              )),
          'Google Inc.': CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                FontAwesomeIcons.google,
                color: Colors.grey,
              )),
        };
        if (iconMap[dev.manufacturer] != null) {
          final deviceInit = Roku(ip: address);
          devices.add({
            'type': dev.manufacturer,
            'device': dev,
            'address': address,
            'icon': iconMap[dev.manufacturer],
            'deviceInstance': deviceInit,
            'onTap': RokuRemote(deviceInit, dev.friendlyName),
          });
          validDevices++;

          _listKey.currentState.insertItem(validDevices - 1,
              duration: Duration(milliseconds: 700));
        }
      } catch (e, stack) {
        print("ERROR: ${e} - ${client.location}");
        print(stack);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    scan();
    //getgetShortcutDataata();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_selectedIndex == 0 ? widget.title : 'Shortcuts'),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.

          child: Column(
        children: [
          LinearProgressIndicator(),
          Visibility(
              visible: _selectedIndex == 0 ? true : false,
              child: Expanded(
                  child: AnimatedList(
                      initialItemCount: validDevices,
                      key: _listKey,
                      itemBuilder: (context, index, animation) {
                        return SlideTransition(
                            position: animation.drive(Tween(
                                    begin: Offset(2, 0.0),
                                    end: Offset(0.0, 0.0))
                                .chain(CurveTween(
                                    curve: Curves.fastLinearToSlowEaseIn))),
                            child: GestureDetector(
                              onTap: () => {
                                () {
                                  devices[index]['deviceInstance'].powerOn();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            devices[index]['onTap']),
                                  );
                                }()
                              },
                              child: Card(
                                  child: ListTile(
                                leading: devices[index]['icon'],
                                title:
                                    Text(devices[index]['device'].friendlyName),
                                subtitle: Text('TCL TV'),
                                trailing: DropdownButton(
                                  isDense: true,
                                  underline: SizedBox(height: 0, width: 0),
                                  icon: Icon(Icons.more_vert),
                                  items: <String>[
                                    '',
                                    'Copy IP Address',
                                    'Open in Web',
                                    'Share',
                                  ].map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (_) {},
                                ),
                              )),
                            ));
                      }))),
          Visibility(
              visible: _selectedIndex == 1 ? true : false,
              child: Expanded(
                  child: FutureBuilder<String>(
                      future: getShortcutIndex(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          var shortcuts = jsonDecode(snapshot.data);
                          print('shortcutindexLength ' +
                              shortcuts['shortcuts'].length.toString());
                          return ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: shortcuts['shortcuts'].length,
                              itemBuilder: (BuildContext context, int index) {
                                print(snapshot.data);
                                var thisShortcut =
                                    jsonDecode(shortcuts['shortcuts'][index]);
                                List supportedShortcutDevices =
                                    filterDevices(thisShortcut['deviceType']);
                                var shorty = ViewShortcut(
                                    device: thisShortcut['deviceType'],
                                    name: thisShortcut['name'],
                                    actions: thisShortcut['actions'],
                                    selectDevice: AlertDialog(
                                      title: Text(
                                          "Select a ${thisShortcut['deviceType']} Device to Run '${thisShortcut['name']}'"),
                                      content: Container(
                                          width: 80,
                                          child: ListView.builder(
                                              itemCount:
                                                  supportedShortcutDevices
                                                      .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return InkWell(
                                                    onTap: () => {
                                                          () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            await supportedShortcutDevices[
                                                                        index][
                                                                    'deviceInstance']
                                                                .powerOn();
                                                            await supportedShortcutDevices[
                                                                        index][
                                                                    'deviceInstance']
                                                                .home();
                                                            thisShortcut[
                                                                    'actions']
                                                                .forEach(
                                                                    (action) =>
                                                                        {
                                                                          () async {
                                                                            supportedShortcutDevices[index]['deviceInstance'].run(action);
                                                                          }()
                                                                        });

                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Sucessfully ran '${thisShortcut['name']}",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  2,
                                                            );
                                                          }()
                                                        },
                                                    child: Card(
                                                      child: ListTile(
                                                        leading:
                                                            supportedShortcutDevices[
                                                                index]['icon'],
                                                        title: Text(
                                                            supportedShortcutDevices[
                                                                        index]
                                                                    ['device']
                                                                .friendlyName),
                                                        subtitle:
                                                            Text('TCL TV'),
                                                      ),
                                                    ));
                                              })),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ));
                                return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          gradient: LinearGradient(colors: [
                                            Color(0xff6f1ab1),
                                            Colors.black87
                                          ])),
                                      child: InkWell(
                                          onTap: () => {
                                                if (!_shortcutInProg)
                                                  {
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Select a ${thisShortcut['deviceType']} Device to Run '${thisShortcut['name']}'"),
                                                          content: Container(
                                                              width: 80,
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount:
                                                                          supportedShortcutDevices
                                                                              .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int index) {
                                                                        return InkWell(
                                                                            onTap: () =>
                                                                                {
                                                                                  () async {
                                                                                    setState(() {
                                                                                      _shortcutInProg = true;
                                                                                    });
                                                                                    Navigator.of(context).pop();
                                                                                    await supportedShortcutDevices[index]['deviceInstance'].powerOn();
                                                                                    await supportedShortcutDevices[index]['deviceInstance'].home();
                                                                                    thisShortcut['actions'].forEach((action) => {
                                                                                          () async {
                                                                                            supportedShortcutDevices[index]['deviceInstance'].run(action);
                                                                                          }()
                                                                                        });
                                                                                    setState(() {
                                                                                      _shortcutInProg = false;
                                                                                    });
                                                                                    Fluttertoast.showToast(
                                                                                      msg: "Sucessfully ran '${supportedShortcutDevices[index]['name']}",
                                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                                      gravity: ToastGravity.BOTTOM,
                                                                                      timeInSecForIosWeb: 2,
                                                                                    );
                                                                                  }()
                                                                                },
                                                                            child:
                                                                                Card(
                                                                              child: ListTile(
                                                                                leading: supportedShortcutDevices[index]['icon'],
                                                                                title: Text(supportedShortcutDevices[index]['device'].friendlyName),
                                                                                subtitle: Text('TCL TV'),
                                                                              ),
                                                                            ));
                                                                      })),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                'View Actions',
                                                              ),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              shorty),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    )
                                                  }
                                              },
                                          child: ListTile(
                                            leading: Icon(
                                                Icons.play_arrow_rounded,
                                                color: Colors.white),
                                            title: Text(thisShortcut['name'],
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            subtitle: Text(
                                                "${thisShortcut['actions'].length} actions • ${thisShortcut['deviceType']}",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            trailing: IconButton(
                                              icon: Icon(Icons.arrow_right_alt,
                                                  color: Colors.white),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          shorty),
                                                );
                                              },
                                            ),
                                          )),
                                    ));
                              });
                        } else {
                          return Center(
                              child: Text('No shortcuts created yet'));
                        }
                      }))),
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Open AR Mode',
        child: Icon(Icons.view_in_ar),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.devices_other_rounded),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_rounded),
            label: 'Shortcuts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
