import 'package:flutter/material.dart';

abstract class ConfirmDialogWidget {
  static Future<bool> isConfirmed({
    required BuildContext context,
  }) async {
    bool isConfirmed = false;
    await showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Подтверждение действия'),
        content: const Text('Вы уверены, что хотите продолжить?'),
        actions: [
          TextButton(
            onPressed: () {
              isConfirmed = false;
              Navigator.of(context).pop();
            },
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              isConfirmed = true;
              Navigator.of(context).pop();
            },
            child: const Text('Продолжить'),
          ),
        ],
      ),
    );
    return isConfirmed;
  }
}
