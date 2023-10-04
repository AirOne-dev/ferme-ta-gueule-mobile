import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

import 'package:ferme_ta_gueule_mobile/class/ftg.dart';
import 'package:ferme_ta_gueule_mobile/class/utils.dart';

class LogScreen extends StatefulWidget {
  final List<Map<String, String>> logs;
  final String title;
  final FTG ftg;

  const LogScreen({required this.logs, required this.title, required this.ftg, Key? key}) : super(key: key);

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  late ScrollController _scrollLogsController;

  @override
  void initState() {
    super.initState();
    _scrollLogsController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant LogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    Utils.scrollToBottom(_scrollLogsController);
  }

  @override
  Widget build(BuildContext context) {
    Widget? appBody;

    if (widget.logs.isNotEmpty) {
      appBody = ListView.builder(
        controller: _scrollLogsController,
        itemCount: widget.logs.length,
        itemBuilder: (context, index) {
          final log = widget.logs[index];
          Color bgColor = Utils.getLevelColor(log['level']!);
          return GestureDetector(
            onTap: () {
              Utils.showActionSheet(
                context,
                "${log['level']!} ${log['project']!}",
                log['message']!,
                customAction: () {
                  return CupertinoActionSheetAction(
                    onPressed: () async {
                      widget.ftg.fetchMoreInfoById(log['id']!).then((infos) => {
                            Utils.showActionSheet(context, 'Infos', infos['msg'], customAction: () {
                              return CupertinoActionSheetAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Share.share(infos['msg']!);
                                },
                                child: const Text('Partager'),
                              );
                            })
                          });
                    },
                    child: const Text('Voir plus'),
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: bgColor.withOpacity(0.75),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(log['time']!, style: const TextStyle(fontSize: 10)),
                      const SizedBox(width: 4),
                      Text(log['level']!, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(log['project']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text(log['server']!, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(log['message']!,
                      style: const TextStyle(fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        },
      );
    } else {
      appBody = const CupertinoActivityIndicator();
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
      ),
      child: Center(
        child: appBody,
      ),
    );
  }
}
