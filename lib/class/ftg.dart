import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:ferme_ta_gueule_mobile/class/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:serious_python/serious_python.dart';

import '../views/log_screen.dart';

class FTG {
  CupertinoTabController tabController = CupertinoTabController(initialIndex: 0);
  Map<int, List<Map<String, String>>> logsByTabIndex = {};
  Map<String, dynamic> status = {};

  bool isFetchingLogs = true;
  bool _logFetchingLoop = false;

  int _errorCount = 0;

  StreamController<String> controller = StreamController<String>();
  late Stream<String> stream;

  FTG() {
    stream = controller.stream;
    start();
  }

  Future<void> start() async {
    try {
      await stop();
      SeriousPython.run("app/app.zip", appFileName: "ferme-ta-gueule.pyc", environmentVariables: {"webserver": "true"});
      _logFetchingLoop = true;
      _startLogFetchingLoop();
      _updateRoutes();
    } catch (e) {
      print(e);
    }
  }

  Future<void> stop() async {
    _logFetchingLoop = false;
    return sendCommand('stop');
  }

  Future<dynamic> sendCommand(String command) {
    return fetch(parametters: '/command/$command').then((value) => value['command_output'] ?? {});
  }

  Future<dynamic> fetch({String parametters = ''}) async {
    // if (_errorCount >= 5) {
    //   _errorCount = 0;
    //   await stop();
    //   await start();
    // }
    try {
      var decoded = await http.get(Uri.parse("http://localhost:8000$parametters")).then((res) => jsonDecode(res.body));
      status = decoded['status'];
      return decoded;
    } catch (error) {
      _errorCount++;
      status = {};
      return {};
    }
  }

  Future<List<Map<String, String>>> getLogs() async {
    try {
      var response = (await fetch().then((value) => value['logs_since_last_call'] ?? []) as List<dynamic>)
          .map((e) => e.toString().trim())
          .toList();
      var elems = response.where((e) => e.isNotEmpty).toList();
      if (elems.isNotEmpty) {
        controller.add('new log');
        return _transformLogs(elems);
      }
    } catch (error) {
      print(error);
    }
    return [];
  }

  Future<dynamic> fetchMoreInfoById(String id) async {
    return sendCommand(id);
  }

  Future<void> _startLogFetchingLoop() async {
    while (_logFetchingLoop) {
      if (isFetchingLogs) {
        var logs = await getLogs();
        if (logs.isNotEmpty) {
          if (logsByTabIndex[tabController.index] == null) {
            logsByTabIndex[tabController.index] = logs;
          } else {
            logsByTabIndex[tabController.index]?.addAll(logs);
          }
        }
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _updateRoutes() async {
    var result = {};
    while (result.isEmpty && !result.containsKey('indexes')) {
      result = await sendCommand('ls');
      await Future.delayed(const Duration(milliseconds: 100));
    }
    final routes = (result['indexes'] as List<dynamic>).map((e) => e.toString()).toList();
    for (var route in routes) {
      Globals.routes['/index/$route'] = (context) => LogScreen(
            logs: Globals.ftg.logsByTabIndex[routes.indexOf(route)] ?? [],
            title: 'FTG - Index $route',
            ftg: Globals.ftg,
          );
    }
  }

  List<Map<String, String>> _transformLogs(List<String> logs) {
    List<Map<String, String>> result = [];

    for (String log in logs) {
      var splited = log.split(' [-] ');

      result.add({
        'time': splited[0],
        'level': splited[1],
        'server': splited[2],
        'id': splited[3],
        'project': splited[4],
        'message': splited[5],
      });
    }
    return result;
  }
}

String replaceWithRandom(String input) {
  Random random = Random();
  String output = '';

  for (int i = 0; i < input.length; i++) {
    int randomCharCode = random.nextInt(26) + 97; // generates a random lowercase character
    String randomChar = String.fromCharCode(randomCharCode);
    output += randomChar;
  }

  return output;
}
