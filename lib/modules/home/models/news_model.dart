/// Sample model — one article from the Spaceflight News API v4
/// (`/articles` → `{ results: [ ... ] }`).
class NewsModel {
  final int? id;
  final String? title;
  final String? url;
  final String? imageUrl;
  final String? newsSite;
  final String? summary;
  final String? publishedAt;

  NewsModel({
    this.id,
    this.title,
    this.url,
    this.imageUrl,
    this.newsSite,
    this.summary,
    this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json['id'] as int?,
        title: json['title']?.toString(),
        url: json['url']?.toString(),
        imageUrl: json['image_url']?.toString(),
        newsSite: json['news_site']?.toString(),
        summary: json['summary']?.toString(),
        publishedAt: json['published_at']?.toString(),
      );
}
