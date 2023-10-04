import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:serious_python/serious_python.dart';

import 'package:ferme_ta_gueule_mobile/views/log_screen.dart';

class FTG {
  CupertinoTabController tabController = CupertinoTabController(initialIndex: 1);
  Map<int, List<Map<String, String>>> logsByTabIndex = {};
  Map<String, dynamic> status = {};

  bool isFetchingLogs = true;
  bool _logFetchingLoop = false;

  int _errorCount = 0;

  StreamController<String> controller = StreamController<String>();
  late Stream<String> stream;

  var routes = {};

  FTG() {
    stream = controller.stream;
    start();
  }

  // Start the ftg instance and start the log fetching loop
  Future<void> start() async {
    try {
      await stop();
      SeriousPython.run("app/app.zip", appFileName: "ferme-ta-gueule.pyc", environmentVariables: {"webserver": "true"});
      _logFetchingLoop = true;
      _startLogFetchingLoop();
      _updateRoutes();
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 1000));
      return start();
    }
  }

  // Stop the ftg instance and reset the class variables
  Future<void> stop() async {
    var res = sendCommand('stop');
    _errorCount = 0;
    _logFetchingLoop = false;
    isFetchingLogs = true;
    status = {};
    logsByTabIndex = {};
    return res;
  }

  // Send a command to the ftg instance
  Future<dynamic> sendCommand(String command) {
    return fetch(parametters: '/command/$command').then((value) => value['command_output'] ?? {});
  }

  // Fetch data from the ftg instance
  Future<dynamic> fetch({String parametters = ''}) async {
    try {
      var decoded = await http.get(Uri.parse("http://localhost:8000$parametters")).then((res) => jsonDecode(res.body));
      status = decoded['status'] ?? {};
      return decoded;
    } catch (error) {
      _errorCount++;
      status = {};
      return {};
    }
  }

  // Fetch logs from the ftg instance and transform them to a list of log objects
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

  // Fetch more info about a log by its id
  Future<dynamic> fetchMoreInfoById(String id) async {
    return sendCommand(id);
  }

  // Start a loop that fetches logs every 500ms
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

  // Update convert ftg indexes to routes that will be used by the app
  Future<void> _updateRoutes() async {
    // if the app is not started, we wait 100ms and try again
    // this is because the app is not started yet, so the indexes are not available
    var result = await sendCommand('ls');
    if (!result.containsKey('indexes')) {
      await Future.delayed(const Duration(milliseconds: 100));
      return _updateRoutes();
    }

    // we update the routes
    final rts = (result['indexes'] as List<dynamic>).map((e) => e.toString()).toList();
    for (var route in rts) {
      routes['/index/$route'] = (context) => LogScreen(
            logs: logsByTabIndex[rts.indexOf(route)] ?? [],
            title: 'FTG - Index $route',
            ftg: this,
          );
    }

    // after the routes are updated, we can set the initial index of the tabController to the current index of FTG
    tabController.index = routes.keys.toList().indexOf('/index/${status['index']}');
  }

  // Convert a list of logs from the server to a list of log objects
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
