import 'package:flutter/cupertino.dart';

class Utils {
  static void showActionSheet(BuildContext context, String title, String message,
      {String cancel = 'Fermer', CupertinoActionSheetAction Function()? customAction}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(title),
        message: Text(message),
        actions: <CupertinoActionSheetAction>[
          if (customAction != null) customAction(),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(cancel),
          ),
        ],
      ),
    );
  }

  static Future<void> scrollToBottom(ScrollController scrollController) async {
    if (scrollController.hasClients && scrollController.position.maxScrollExtent > 0) {
      await Future.delayed(const Duration(milliseconds: 50));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  static Color getLevelColor(String level) {
    switch (level) {
      case '🔹':
        return CupertinoColors.systemBlue;
      case '💢':
        return CupertinoColors.systemYellow;
      case '💥':
        return CupertinoColors.systemRed;
      default:
        return CupertinoColors.systemBackground;
    }
  }
}
