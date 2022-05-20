import 'package:autospectechnics/domain/date_formatter.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/completed_repair_service.dart';
import 'package:autospectechnics/domain/services/image_service.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';

class AddingCompletedRepairViewModel extends ChangeNotifier {
  final String _vehicleObjectId;

  final _completedRepairService = CompletedRepairService();
  final _vehicleService = VehicleService();
  final _imageService = ImageService();

  bool isLoadingProgress = false;
  int selectedVehiicleNodeIndex = -1;
  DateTime _selectedDate = DateTime.now();

  final titleTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  AddingCompletedRepairViewModel(
    this._vehicleObjectId,
  );

  List<Image> get imageList => _imageService.imageList;

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
      await _completedRepairService.createCompletedRepair(
        title: title,
        mileage: mileage,
        description: description,
        date: _selectedDate,
        vehicleNode: vehicleNode,
        vehicleObjectId: _vehicleObjectId,
        imagesList: _imageService.imageFileList,
      );
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
}
