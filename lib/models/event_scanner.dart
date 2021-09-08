class EventScannerModel {
  EventScannerModel({
    this.body,
    this.code,
    this.message,
  });

  List<EventScannerData> body;
  int code;
  String message;

  factory EventScannerModel.fromJson(Map<String, dynamic> json) => EventScannerModel(
    body: List<EventScannerData>.from(json["body"].map((x) => EventScannerData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );
}

class EventScannerData {
  EventScannerData({
    this.eventId,
    this.description,
    this.eventDate,
    this.eventEndDate,
    this.status,
    this.location,
    this.start,
    this.end,
    this.summary,
    this.picture,
    this.paid,
    this.price,
    this.productId,
    this.shareNews,
    this.createdBy,
    this.created,
    this.updated,
    this.media,
  });

  int eventId;
  String description;
  DateTime eventDate;
  DateTime eventEndDate;
  bool status;
  String location;
  String start;
  String end;
  String summary;
  int picture;
  bool paid;
  dynamic price;
  String productId;
  bool shareNews;
  String createdBy;
  DateTime created;
  DateTime updated;
  List<Media> media;

  factory EventScannerData.fromJson(Map<String, dynamic> json) => EventScannerData(
    eventId: json["event_id"] == null ? null : json["event_id"],
    description: json["description"] == null ? null : json["description"],
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    eventEndDate: json["event_end_date"] == null ? null : DateTime.parse(json["event_end_date"]),
    status: json["status"] == null ? null : json["status"],
    location: json["location"] == null ? null : json["location"],
    start: json["start"] == null ? null : json["start"],
    end: json["end"] == null ? null : json["end"],
    summary: json["summary"] == null ? null : json["summary"],
    picture: json["picture"] == null ? null : json["picture"],
    paid: json["paid"] == null ? null : json["paid"],
    price: json["price"] == null ? null : json["price"],
    productId: json["product_id"] == null ? null : json["product_id"],
    shareNews: json["share_news"] == null ? null : json["share_news"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
    media: json["Media"] == null ? null : List<Media>.from(json["Media"].map((x) => Media.fromJson(x))),
  );
}

class Media {
  Media({
    this.mediaId,
    this.status,
    this.contentType,
    this.fileLength,
    this.originalName,
    this.path,
    this.createdBy,
    this.created,
    this.updated,
  });

  int mediaId;
  String status;
  String contentType;
  int fileLength;
  String originalName;
  String path;
  String createdBy;
  DateTime created;
  DateTime updated;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    mediaId: json["media_id"] == null ? null : json["media_id"],
    status: json["status"] == null ? null : json["status"],
    contentType: json["content_type"] == null ? null : json["content_type"],
    fileLength: json["file_length"] == null ? null : json["file_length"],
    originalName: json["original_name"] == null ? null : json["original_name"],
    path: json["path"] == null ? null : json["path"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
  );
}
