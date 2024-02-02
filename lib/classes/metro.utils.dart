import 'package:flutter/material.dart';
import 'package:metro/classes/constants.dart';
import 'package:metro/providers/provider_metro.dart';
import 'package:provider/provider.dart';

class MetroUtils {

  static void showSnackbar(BuildContext context, String message, { Color? color }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );

    // Find the ScaffoldMessenger and show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Shows an alert dialog with title(optional), String text or custom Widget
  /// positive and negative button with relative text and callbacks
  /// AlertDialog automatically close after any option is selected
  static Future<void> showOptionDialog({
    required BuildContext context,
    required String positiveActionText,
    required String negativeActionText,
    required void Function()? positiveActionCallback,
    String? title,
    String? text,
    Widget? content,
    bool? barrierDismissible,
    void Function()? negativeActionCallback,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: (content != null) ? content : ((text != null) ? Text(text) : const SizedBox()),
          actions: <Widget>[
            OutlinedButton(
              onPressed: negativeActionCallback ?? () => Navigator.pop(context),
              child: Text(negativeActionText),
            ),
            FilledButton(
              onPressed: positiveActionCallback,
              child: Text(positiveActionText),
            ),
          ],
        );
      },
    );
  }

  static void handleContentVisibility(BuildContext context) {
    MetroProvider provider = Provider.of<MetroProvider>(context, listen: false);
    provider.contentVisible = true;
    if (!provider.autoHideContent) return;

    if (provider.running) {
      Future.delayed(const Duration(seconds: Constants.AUTO_HIDE_CONTENT_TIMEOUT)).then((value) {
        if (provider.running) provider.contentVisible = false;
      });
    }
  }

}