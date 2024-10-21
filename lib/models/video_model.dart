class VideoModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String duration;
  final String videoUrl;
  final String description;
  final String author;
  final String views;
  final String uploadTime;

  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.videoUrl,
    required this.description,
    required this.author,
    required this.views,
    required this.uploadTime,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
  return VideoModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    thumbnailUrl: json['thumbnailUrl'] ?? '',
    duration: json['duration'] ?? '',
    videoUrl: json['videoUrl'] ?? '',
    description: json['description'] ?? '',
    author: json['author'] ?? '',
    views: json['views'] ?? '',
    uploadTime: json['uploadTime'] ?? '',
  );
}
}