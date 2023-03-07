import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:wallet/wallet.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> getPass() async {
    Map<String, dynamic> body = {"clientID": 1234};

    Response<List<int>> response;
    Dio dio = new Dio();

    response = await dio.post(
      "https://host.com/getPass",
      data: body,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.data != null) {
      try {
        var result =
            await Wallet.presentAddPassViewController(pkpass: response.data!);
        print(result);
      } catch (e) {
        print(e.toString());
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pass example app'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text("Get Pass"),
            onPressed: () {
              getPass();
            },
          ),
        ),
      ),
    );
  }
}
