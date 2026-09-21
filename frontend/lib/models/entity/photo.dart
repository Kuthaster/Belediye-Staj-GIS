class PhotoDTO {
  final int objectId;
  final String photoUrl;
  final bool hasPrevious;
  final DateTime uploadedAt;

  PhotoDTO({
    required this.objectId,
    required this.photoUrl,
    required this.hasPrevious,
    required this.uploadedAt,
  });

  factory PhotoDTO.fromJson(Map<String, dynamic> json) {
    return PhotoDTO(
      objectId: json['objectId'],
      photoUrl: json['photoUrl'],
      hasPrevious: json['hasPrevious'],
      uploadedAt: DateTime.parse(json['uploadedAt'] + 'Z'),
    );
  }
}
