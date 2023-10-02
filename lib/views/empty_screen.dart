import 'package:flutter/cupertino.dart';

class EmptyScreen extends StatefulWidget {
  final Map<String, dynamic> status;

  const EmptyScreen({required this.status, Key? key}) : super(key: key);

  @override
  _EmptyScreenState createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EmptyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget appBody;

    appBody = (widget.status.containsKey('index'))
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text("pause : ${widget.status['pause'] ? 'true' : 'false'}"),
              Text("index : ${widget.status['index']}"),
              Text("url : ${widget.status['url']}"),
              Text("now : ${widget.status['now']}"),
              const Spacer(),
            ],
          )
        : const CupertinoActivityIndicator();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: Center(
        child: appBody,
      ),
    );
  }
}
