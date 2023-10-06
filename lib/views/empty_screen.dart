import 'package:ferme_ta_gueule_mobile/class/ftg.dart';
import 'package:flutter/cupertino.dart';

class EmptyScreen extends StatefulWidget {
  final Map<String, dynamic> status;
  final FTG ftg;

  const EmptyScreen({required this.status, required this.ftg, Key? key}) : super(key: key);

  @override
  State<EmptyScreen> createState() => _EmptyScreenState();
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
              CupertinoButton(
                color: CupertinoColors.destructiveRed,
                onPressed: () {
                  // stop the ftg instance
                  widget.ftg.stop().then((_) {
                    Navigator.pushReplacementNamed(context, '/', arguments: {
                      'ftg': FTG(),
                      'message': 'FTG is reloading...',
                    });
                  });
                },
                child: const Text('Stop'),
              ),
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
