import 'package:flutter/cupertino.dart';
import 'package:mdi/mdi.dart';

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

  static MdiIconData iconFromFirstLetter(String word) {
    var letter = word[0].toUpperCase();
    switch (letter) {
      case 'A':
        return Mdi.alphaACircleOutline;
      case 'B':
        return Mdi.alphaBCircleOutline;
      case 'C':
        return Mdi.alphaCCircleOutline;
      case 'D':
        return Mdi.alphaDCircleOutline;
      case 'E':
        return Mdi.alphaECircleOutline;
      case 'F':
        return Mdi.alphaFCircleOutline;
      case 'G':
        return Mdi.alphaGCircleOutline;
      case 'H':
        return Mdi.alphaHCircleOutline;
      case 'I':
        return Mdi.alphaICircleOutline;
      case 'J':
        return Mdi.alphaJCircleOutline;
      case 'K':
        return Mdi.alphaKCircleOutline;
      case 'L':
        return Mdi.alphaLCircleOutline;
      case 'M':
        return Mdi.alphaMCircleOutline;
      case 'N':
        return Mdi.alphaNCircleOutline;
      case 'O':
        return Mdi.alphaOCircleOutline;
      case 'P':
        return Mdi.alphaPCircleOutline;
      case 'Q':
        return Mdi.alphaQCircleOutline;
      case 'R':
        return Mdi.alphaRCircleOutline;
      case 'S':
        return Mdi.alphaSCircleOutline;
      case 'T':
        return Mdi.alphaTCircleOutline;
      case 'U':
        return Mdi.alphaUCircleOutline;
      case 'V':
        return Mdi.alphaVCircleOutline;
      case 'W':
        return Mdi.alphaWCircleOutline;
      case 'X':
        return Mdi.alphaXCircleOutline;
      case 'Y':
        return Mdi.alphaYCircleOutline;
      case 'Z':
        return Mdi.alphaZCircleOutline;

      // numbers
      case '0':
        return Mdi.numeric0CircleOutline;
      case '1':
        return Mdi.numeric1CircleOutline;
      case '2':
        return Mdi.numeric2CircleOutline;
      case '3':
        return Mdi.numeric3CircleOutline;
      case '4':
        return Mdi.numeric4CircleOutline;
      case '5':
        return Mdi.numeric5CircleOutline;
      case '6':
        return Mdi.numeric6CircleOutline;
      case '7':
        return Mdi.numeric7CircleOutline;
      case '8':
        return Mdi.numeric8CircleOutline;
      case '9':
        return Mdi.numeric9CircleOutline;
      default:
        return Mdi.alertCircleOutline;
    }
  }
}
