import 'package:flutter/material.dart';

class ErrorDialogWidget {
  ErrorDialogWidget.showConnectionError(BuildContext context) {
    _showErrorDialogWidget(
      context: context,
      title: 'Произошла ошибка',
      errorMessage: 'Проверьте подключение к интернету и повторите попытку',
    );
  }

  ErrorDialogWidget.showUnknownError(BuildContext context) {
    _showErrorDialogWidget(
      context: context,
      title: 'Произошла ошибка',
      errorMessage: 'Произошла ошибка, пожалуйста, повторите попытку',
    );
  }

  ErrorDialogWidget.showErrorWithMessage(
      BuildContext context, String? errorMessage) {
    _showErrorDialogWidget(
      context: context,
      title: 'Произошла ошибка',
      errorMessage:
          errorMessage ?? 'Произошла ошибка, пожалуйста, повторите попытку',
    );
  }

  ErrorDialogWidget.showEmptyResponseError(BuildContext context) {
    _showErrorDialogWidget(
      context: context,
      title: 'Что-то пошло не так',
      errorMessage:
          'На сервере пока нет нужных Вам данных. Пожалуйста, добавьте их, если требуется',
    );
  }

  void _showErrorDialogWidget({
    required BuildContext context,
    required String errorMessage,
    required String title,
  }) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
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
