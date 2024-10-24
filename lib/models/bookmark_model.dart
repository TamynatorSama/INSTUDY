import 'package:instudy/models/course_listing_model.dart';
import 'package:instudy/models/course_video.dart';
import 'package:instudy/models/tags.dart';

class Bookmark {
  final String id;
  final FeedDetails feed;
  final CourseVideo video;
  final bool bookMark;
  final DateTime createdAt;

  const Bookmark(
      {required this.bookMark,
      required this.createdAt,
      required this.feed,
      required this.id,
      required this.video});

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
      bookMark: bool.tryParse(json["bookmark"]) ?? false,
      id: json["_id"],
      feed: FeedDetails.fromJson(json["feed_id"], fromBookMark: true),
      video: CourseVideo.fromJson(json["feed_id"]["video_id"],course: FeedDetails.fromJson(json["feed_id"], fromBookMark: true).courseFromFeedDetails()),
      createdAt: DateTime.parse(json["createdAt"]));

  Bookmark copyWith({bool? bookMark}) => Bookmark(
      bookMark: bookMark ?? this.bookMark,
      createdAt: createdAt,
      feed: feed,
      id: id,
      video: video);


  CourseListingModel courseListing() => CourseListingModel(
      course: feed.courseFromFeedDetails(),
      createdAt: createdAt,
      endTime: feed.endTime,
      bookmark: bookMark,
      note: "",
      id: id,
      startTime: feed.startTime,
      segmentTotal: feed.segmentTotal,
      segmentNumber: feed.segmentNumber,
      transcript: feed.transcript,
      video: video);
}
