import 'package:autospectechnics/domain/date_formatter.dart';
import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/completed_repair_service.dart';
import 'package:autospectechnics/domain/services/image_service.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';

class AddingCompletedRepairViewModel extends ChangeNotifier {
  late final _completedRepairService = CompletedRepairService(_vehicleObjectId);
  final _vehicleService = VehicleService();
  final _imageService = ImageService();

  CompletedRepair? _completedRepair;
  bool isLoadingProgress = false;
  int selectedVehiicleNodeIndex = -1;
  DateTime _selectedDate = DateTime.now();

  final titleTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  Map<String, String> imagesFromServerIdURLs = {};
  List<String> imagesIDsToDelete = [];

  final String _vehicleObjectId;
  final String _completedRepairObjectId;
  AddingCompletedRepairViewModel(
    this._vehicleObjectId,
    this._completedRepairObjectId,
    BuildContext context,
  ) {
    if (_completedRepairObjectId != '') {
      _getCompletedRepair(context);
    }
  }

  List<Image> get pickedImageList => _imageService.imageList;
  String get screenTitle =>
      _completedRepairObjectId == '' ? 'Добавить в историю' : 'Редактирование';

  String get selectedDate => DateFormatter.getFormattedDate(_selectedDate);

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(_selectedDate.year),
      locale: const Locale("ru", "RU"),
      lastDate: _selectedDate.add(const Duration(days: 30)),
      initialDatePickerMode: DatePickerMode.day,
      helpText: 'Выберите дату исполнения ремонтной работы',
    );
    if (picked != null) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  Future<void> pickImage({
    required BuildContext context,
  }) async {
    try {
      await _imageService.pickImage();
      notifyListeners();
    } catch (e) {
      ErrorDialogWidget.showErrorWithMessage(
        context,
        'Произошла ошибка при выборе изображения, пожалуйста, повторите попытку',
      );
    }
  }

  void deleteImageFile(
    BuildContext context,
    int imageIndex,
  ) {
    try {
      _imageService.deleteImageFromFileList(imageIndex);
      notifyListeners();
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }
  }

  void deleteImageFromServer(
    BuildContext context,
    String imageObjectId,
  ) {
    try {
      imagesFromServerIdURLs.remove(imageObjectId);
      imagesIDsToDelete.add(imageObjectId);
      notifyListeners();
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }
  }

  Future<void> _getCompletedRepair(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _completedRepair = await _completedRepairService
          .geCompletedRepairFromHive(_completedRepairObjectId);
      if (_completedRepair == null) {
        ErrorDialogWidget.showDataSyncingError(context);
      }
      titleTextControler.text = _completedRepair?.title ?? '';
      descriptionTextControler.text = _completedRepair?.description ?? '';
      selectedVehiicleNodeIndex =
          VehicleNodeNames.getIndexByName(_completedRepair?.vehicleNode ?? '');
      _selectedDate = _completedRepair?.date ?? DateTime.now();
      imagesFromServerIdURLs = Map<String, String>.from(
          _completedRepair?.imagesIdUrl ?? <String, String>{});
    } on ApiClientException catch (exception) {
      switch (exception.type) {
        case ApiClientExceptionType.network:
          ErrorDialogWidget.showConnectionError(context);
          break;
        case ApiClientExceptionType.emptyResponse:
          ErrorDialogWidget.showEmptyResponseError(context);
          break;
        case ApiClientExceptionType.other:
          ErrorDialogWidget.showErrorWithMessage(context, exception.message);
          break;
      }
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }
    isLoadingProgress = false;
    notifyListeners();
  }

  Future<void> saveToDatabase(BuildContext context) async {
    List<String> _errorList = [];

    final title = titleTextControler.text.trim();
    final description = descriptionTextControler.text.trim();

    if (selectedVehiicleNodeIndex < 0) {
      _errorList.add('Выберите узел автомобиля.');
    }

    if (title.isEmpty) {
      _errorList.add('Поле "Название" не может быть пустым.');
    }

    if (description.isEmpty) {
      _errorList.add('Поле "Описание" не может быть пустым.');
    }

    if (_errorList.isNotEmpty) {
      String _errorMessage = '';
      for (var i = 0; i < _errorList.length; i++) {
        _errorMessage += '${i + 1}) ${_errorList[i]}\n';
      }
      ErrorDialogWidget.showErrorWithMessage(context, _errorMessage);
      return;
    }

    isLoadingProgress = true;
    notifyListeners();

    final vehicleNode =
        VehicleNodeNames.getNameByIndex(selectedVehiicleNodeIndex);

    try {
      final vehicle = await _vehicleService.getVehicleFromHive(
          vehicleObjectId: _vehicleObjectId);
      int mileage = 0;
      if (vehicle != null) {
        mileage = vehicle.mileage;
      }
      if (_completedRepairObjectId == '') {
        await _completedRepairService.createCompletedRepair(
          title: title,
          mileage: mileage,
          description: description,
          date: _selectedDate,
          vehicleNode: vehicleNode,
          imagesList: _imageService.imageFileList,
        );
      } else {
        await _imageService.deleteImagesFromServer(imagesIDsToDelete);
        for (var id in imagesIDsToDelete) {
          _completedRepair?.imagesIdUrl.remove(id);
        }
        await _completedRepairService.updateCompletedRepair(
          objectId: _completedRepairObjectId,
          title: title == _completedRepair?.title ? null : title,
          mileage: mileage == _completedRepair?.mileage ? null : mileage,
          date: _selectedDate == _completedRepair?.date ? null : _selectedDate,
          vehicleNode:
              vehicleNode == _completedRepair?.vehicleNode ? null : vehicleNode,
          description:
              description == _completedRepair?.description ? null : description,
          imagesList: _imageService.imageFileList,
        );
      }
      Navigator.of(context).pop();
    } on ApiClientException catch (exception) {
      switch (exception.type) {
        case ApiClientExceptionType.network:
          ErrorDialogWidget.showConnectionError(context);
          break;
        case ApiClientExceptionType.emptyResponse:
          ErrorDialogWidget.showEmptyResponseError(context);
          break;
        case ApiClientExceptionType.other:
          ErrorDialogWidget.showErrorWithMessage(context, exception.message);
          break;
      }
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }

    isLoadingProgress = false;
    notifyListeners();
  }

  void setSelectedVehiicleNodeIndex(int index) {
    selectedVehiicleNodeIndex = index;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _completedRepairService.dispose();
    await _vehicleService.dispose();
    super.dispose();
  }
}
