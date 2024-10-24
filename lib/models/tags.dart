import 'package:instudy/models/course_video.dart';
import 'package:instudy/models/courses_model.dart';
import 'package:instudy/models/video_transcript.dart';

class Tags {
  final String tag;
  final List<Value> tagContent;

  const Tags({required this.tag, required this.tagContent});

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
      tag: json["tag"],
      tagContent:
          (json["values"] as List).map((e) => Value.fromJson(e)).toList());

  Tags copyWith({List<Value>? tagContent}) =>
      Tags(tag: tag, tagContent: tagContent ?? this.tagContent);
}

class Value {
  final FeedDetails feed;
  final CourseVideo video;

  const Value({required this.feed, required this.video});

  factory Value.fromJson(Map<String, dynamic> json) => Value(
      feed: FeedDetails.fromJson(json["feedDetails"]), video: CourseVideo.fromJson(json["video"],course: FeedDetails.fromJson(json["feedDetails"]).courseFromFeedDetails()));

  Value copyWith({FeedDetails? feed, CourseVideo? video}) =>
      Value(feed: feed ?? this.feed, video: video ?? this.video);

  @override
  bool operator ==(Object other) =>
      other is Value && other.feed == feed && other.video == video;
}

class FeedDetails {
  final double startTime;
  final double endTime;
  final String id;
  final String fullTranscript;
  final String courseID;
  final String? videoID;
  final DateTime createdAt;
  final int segmentNumber;
  final int segmentTotal;
  final List<TimedTranscript> transcript;
  final bool isVisible;
  final bool status;

  const FeedDetails(
      {required this.createdAt,
      required this.endTime,
      required this.id,
      required this.fullTranscript,
      required this.courseID,
      this.videoID,
      required this.isVisible,
      required this.startTime,
      required this.segmentTotal,
      required this.segmentNumber,
      required this.transcript,
      required this.status});

  @override
  bool operator ==(Object other) => other is FeedDetails && other.id == id;

  factory FeedDetails.fromJson(Map<String, dynamic> json,
          {bool fromBookMark = false}) =>
      FeedDetails(
          status: json["status"] == 1,
          isVisible: json["is_visible"] == 1,
          id: json["_id"],
          videoID: json[fromBookMark ? "vi" : "video_id"],
          courseID: json["course_id"],
          fullTranscript: json["transcript"],
          createdAt: DateTime.parse(json["createdAt"]),
          startTime: double.parse(json["start_time"].toString()),
          segmentNumber: int.tryParse(json["segment_number"].toString()) ?? 0,
          segmentTotal: int.tryParse(json["segment_total"].toString()) ?? 0,
          endTime: double.parse(json["end_time"].toString()),
          transcript: (json["timed_transcript"] as List)
              .map((e) => TimedTranscript.fromJson(e))
              .toList());

  @override
  int get hashCode => Object.hashAll([courseID, id, id, videoID]);
  Course courseFromFeedDetails() => Course(
      degree: "",
      id: courseID,
      instructor: "",
      name: "",
      semesterType: "",
      status: status,
      title: "");
}
