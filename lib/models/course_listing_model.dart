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
  final List<TimedTranscript> transcript;

  const CourseListingModel(
      {required this.course,
      required this.createdAt,
      required this.endTime,
      required this.id,
      required this.startTime,
      required this.transcript,
      required this.video});

  factory CourseListingModel.fromJson(Map<String, dynamic> json) =>
      CourseListingModel(
          course: Course.fromJson(
            json["course_id"],
          ),
          video: CourseVideo.fromJson(json["video_id"],course: Course.fromJson(
            json["course_id"],
          )),
          id: json["_id"],
          createdAt: DateTime.parse(json["createdAt"]),
          startTime: double.parse(json["start_time"].toString()),
          endTime: double.parse(json["end_time"].toString()),
          transcript: (json["timed_transcript"] as List)
              .map((e) => TimedTranscript.fromJson(e))
              .toList());
}
