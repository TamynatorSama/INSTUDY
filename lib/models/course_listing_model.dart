import 'package:instudy/models/course_video.dart';
import 'package:instudy/models/courses_model.dart';
import 'package:instudy/models/video_transcript.dart';

class CourseListingModel {
  final Course course;
  final CourseVideo video;
  final double startTime;
  final double endTime;
  final String id;
  final DateTime createdAt;
  final int segmentNumber;
  final int segmentTotal;
  final bool bookmark;
  final String note;
  final List<TimedTranscript> transcript;

  const CourseListingModel(
      {required this.course,
      required this.createdAt,
      required this.endTime,
      required this.id,
      required this.startTime,
      required this.bookmark,
      required this.note,
      required this.segmentTotal,
      required this.segmentNumber,
      required this.transcript,
      required this.video});

  factory CourseListingModel.fromJson(Map<String, dynamic> json) =>
      CourseListingModel(
          course: Course.fromJson(
            json["course_id"],
          ),
          note: json["note"] ?? "",
          bookmark: json["bookmark"] == 1,
          video: CourseVideo.fromJson(json["video_id"],
              course: Course.fromJson(
                json["course_id"],
              )),
          id: json["_id"],
          createdAt: DateTime.parse(json["createdAt"]),
          startTime: double.parse(json["start_time"].toString()),
          segmentNumber: int.tryParse(json["segment_number"].toString()) ?? 0,
          segmentTotal: int.tryParse(json["segment_total"].toString()) ?? 0,
          endTime: double.parse(json["end_time"].toString()),
          transcript: (json["timed_transcript"] as List)
              .map((e) => TimedTranscript.fromJson(e))
              .toList());

  CourseListingModel copyWith({bool? bookmark, String? note}) =>
      CourseListingModel(
          course: course,
          createdAt: createdAt,
          endTime: endTime,
          id: id,
          startTime: startTime,
          bookmark: bookmark ?? this.bookmark,
          note: note ?? this.note,
          segmentTotal: segmentTotal,
          segmentNumber: segmentNumber,
          transcript: transcript,
          video: video);
}
