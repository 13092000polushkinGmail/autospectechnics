import 'package:image_picker/image_picker.dart';

//TODO Изначально делал этот класс, потому что в нем было много кода из образца на flutter.dev в документации к ImagePicker, в конечном итоге решил вынести этот код в модель
class AppImagePicker {
  List<XFile>? _imageFileList;
  List<XFile>? get imageFileList => _imageFileList;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final List<XFile>? pickedFileList = await _imagePicker.pickMultiImage();
      _imageFileList = pickedFileList;
    } catch (e) {
      rethrow;
    }
  }

  //TODO Не стал прописывать: в документации к ImagePicker сказано, что это вызывается когда приложение закрывается из-за большой нагрузки на память, протестировать этот случай, открыв много приложений и забив оперативку
  // Future<void> retrieveLostData() async {
  //   final LostDataResponse response = await _imagePicker.retrieveLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     _imageFile = response.file;
  //     _imageFileList = response.files;
  //     notifyListeners();
  //   } else {
  //     _errorMessage = 'Произошла ошибка. Пожалуйста, повторите попытку.';
  //     notifyListeners();
  //   }
  // }
}
