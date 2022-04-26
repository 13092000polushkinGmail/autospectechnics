class Recommendation {
  final String objectId;
  final String title;
  final String vehicleNode;
  final String description;
  final bool isCompleted;
  //TODO Не уверен что нужно хранить список objectId, возможно сами объекты
  final List<String> photosIdList;
  Recommendation({
    required this.objectId,
    required this.title,
    required this.vehicleNode,
    required this.description,
    required this.isCompleted,
    required this.photosIdList,
  });
}
