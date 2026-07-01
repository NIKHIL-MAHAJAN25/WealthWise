class NewsModel {
  final String uuid;
  final String title;
  final String? description;
  final String? imageUrl;
  final String url;
  final String? source;
  final String publishedAt;
  const NewsModel({
    required this.uuid,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
    required this.source,
    required this.publishedAt
    
  });
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      uuid: json['uuid'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      url: json['url'],
      source: json['source'],
      publishedAt: json['published_at'],
    );
  }
}
