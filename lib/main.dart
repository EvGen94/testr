import 'dart:ui';
import './model/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'chartScreen.dart';
import './model/users.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final User user;
  MyApp({this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TestApp',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/users/");
    var jsonData = json.decode(data.body);
    List<User> users = [];
    jsonData.forEach((curValue) {
      print(curValue);
      User curUser = User.fromMapUsers(curValue);
      users.add(curUser);
      // print(users[curValue]);
    });

    return users;
  }

  Future<List<User>> _getToDos() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/todos/");
    var jsonData = json.decode(data.body);
    List<User> toDos = [];
    jsonData.forEach((curValue) {
      print(curValue);
      User curToDos = User.fromMapTodos(curValue);
      toDos.add(curToDos);
      //  print(toDos[curValue]);
    });

    return toDos;
  }

  Future<List<User>> _myString1;
  Future<List<User>> _myString2;

  @override
  void initState() {
    super.initState();
    _myString1 = _getUsers();
    _myString2 = _getToDos();
  }
   Data data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TestApp'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                "TestApp",
                textAlign: TextAlign.justify,
                textScaleFactor: 2.0,
              ),
            ),
            ListTile(
              title: Text("First"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Second"),
              onTap: () {
               

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChartScreen(value: data,)),
                );
                print("object");
              },
            )
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: TabBar(
                tabs: [
                  Tab(child: Text('Users')),
                  Tab(child: Text('ToDos')),
                ],
                indicatorColor: Colors.white,
              ),
            ),
            body: TabBarView(
              children: [
                _buildListUsers(key: "key1", string: "Users: "),
                _buildListToDos(key: "key2", string: "ToDos: ")
              ],
            )),
      ),
    );
  }

  Widget _buildListUsers({String key, String string}) {
    final List<Data> users = [];
    return Container(
      child: FutureBuilder(
        future: _myString1,
        builder: (BuildContext contex, AsyncSnapshot snapchot) {
          if (snapchot.data == null) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              key: PageStorageKey(key),
              itemCount: snapchot.data.length,
              itemBuilder: (BuildContext context, int index) {
                //  key: UniqueKey();
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      snapchot.data[index].isSelectedUser
                          ? snapchot.data[index].isSelectedUser = false
                          : snapchot.data[index].isSelectedUser = true;
                      Data users = Data(
                          name: snapchot.data[index].name,
                          username: snapchot.data[index].username);
                    });
                  },
                  /*child: AnimatedContainer(
                                  color: snapchot.data[index].isSelectedUser
                                      ? Colors.red[100]
                                      : Colors.transparent,
                                  duration: Duration(milliseconds: 250),*/
                  child: Card(
                    color: snapchot.data[index].isSelectedUser
                        ? Colors.green[200]
                        : Colors.white,
                    margin: EdgeInsets.all(10),
                    // shape
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.blue[200],
                              child: Text(
                                '${snapchot.data[index].name[0]}  ${snapchot.data[index].username[0]}',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7)),
                              ),
                              radius: 40,
                            ),
                            Text('Email: ${snapchot.data[index].email}',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black.withOpacity(0.7))),
                            SizedBox(
                              height: 45,
                            ),
                            Text(snapchot.data[index].name,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black.withOpacity(0.7))),
                          ]),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildListToDos({String key, String string}) {
    return Container(
      child: FutureBuilder(
        future: _myString2,
        builder: (BuildContext contex, AsyncSnapshot snapchot) {
          if (snapchot.data == null) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              key: PageStorageKey(key),
              itemCount: snapchot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(snapchot.data[index].title),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}