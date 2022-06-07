import 'package:flutter/material.dart';

abstract class PhotoOptionDialogWidget {
  static Future<bool?> isDeleteOption({
    required BuildContext context,
  }) async {
    bool? isDelete;
    await showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Выберите действие'),
        content: const Text('Что сделать с фотографией?'),
        actions: [
          TextButton(
            onPressed: () {
              isDelete = true;
              Navigator.of(context).pop();
            },
            child: const Text('Удалить'),
          ),
          TextButton(
            onPressed: () {
              isDelete = false;
              Navigator.of(context).pop();
            },
            child: const Text('Выбрать другую'),
          ),
        ],
      ),
    );
    return isDelete;
  }
}