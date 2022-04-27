import 'package:flutter/material.dart';

class ErrorDialogWidget {
  ErrorDialogWidget.showConnectionError(BuildContext context) {
    _showErrorDialogWidget(
      context: context,
      errorMessage: 'Проверьте подключение к интернету и повторите попытку',
    );
  }

  ErrorDialogWidget.showUnknownError(BuildContext context) {
    _showErrorDialogWidget(
      context: context,
      errorMessage: 'Произошла ошибка, пожалуйста, повторите попытку',
    );
  }

  ErrorDialogWidget.showErrorWithMessage(
      BuildContext context, String errorMessage) {
    _showErrorDialogWidget(
      context: context,
      errorMessage: errorMessage,
    );
  }

  void _showErrorDialogWidget({
    required BuildContext context,
    required String errorMessage,
  }) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Произошла ошибка'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ок'),
          ),
        ],
      ),
    );
  }
}
