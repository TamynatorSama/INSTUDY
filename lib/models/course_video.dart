import 'dart:typed_data';

import 'package:instudy/models/courses_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CourseVideo {
  CourseVideo({
    required this.id,
    required this.course,
    required this.file,
    required this.s3Uri,
    required this.s3Link,
    required this.duration,
    required this.medium,
    required this.week,
    required this.transcriptReady,
    required this.segmentsReady,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final Course course;
  final FileClass file;
  final String? s3Uri;
  final String? s3Link;
  final double? duration;
  final String medium;
  final int week;
  Uint8List? thumbnail;
  final bool transcriptReady;
  final bool segmentsReady;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseVideo copyWith({
    String? id,
    Course? course,
    FileClass? file,
    String? s3Uri,
    String? s3Link,
    double? duration,
    String? medium,
    int? week,
    bool? transcriptReady,
    bool? segmentsReady,
    bool? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseVideo(
      id: id ?? this.id,
      course: course ?? this.course,
      file: file ?? this.file,
      s3Uri: s3Uri ?? this.s3Uri,
      s3Link: s3Link ?? this.s3Link,
      duration: duration ?? this.duration,
      medium: medium ?? this.medium,
      week: week ?? this.week,
      transcriptReady: transcriptReady ?? this.transcriptReady,
      segmentsReady: segmentsReady ?? this.segmentsReady,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CourseVideo.fromJson(Map<String, dynamic> json) {
    return CourseVideo(
      id: json["_id"],
      course: Course.fromJson(json["course_id"]),
      file: FileClass.fromJson(json["file"]),
      s3Uri: json["s3_uri"],
      s3Link: json["s3_link"],
      duration: json["duration"],
      medium: json["medium"],
      week: json["week"],
      transcriptReady: json["transcript_ready"] == 1,
      segmentsReady: json["segments_ready"] == 1,
      status: json["status"] == 1,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
    );
  }

  Future<Uint8List?> getThumbnail(dynamic value) async {
    if (thumbnail != null) {
      return thumbnail;
    }
    final thumbnailGenerator = await VideoThumbnail.thumbnailData(
      video: s3Link ?? "",
      timeMs: 10000,
//   thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    thumbnail = thumbnailGenerator;
    return thumbnailGenerator;
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "course_id": course.toJson(),
        "file": file.toJson(),
        "s3_uri": s3Uri,
        "s3_link": s3Link,
        "duration": duration,
        "medium": medium,
        "week": week,
        "transcript_ready": transcriptReady,
        "segments_ready": segmentsReady,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };

  @override
  String toString() {
    return "$id, $course, $file, $s3Uri, $s3Link, $duration, $medium, $week, $transcriptReady, $segmentsReady, $status, $createdAt, $updatedAt, ";
  }

  @override
    operator ==(Object other)=>other is CourseVideo && other.id == id &&transcriptReady == other.transcriptReady;
    @override
      int get hashCode => Object.hashAll([id,transcriptReady,medium,week]);
}

class FileClass {
  FileClass({
    required this.bucket,
    required this.key,
  });

  final String bucket;
  final String key;

  FileClass copyWith({
    String? bucket,
    String? key,
  }) {
    return FileClass(
      bucket: bucket ?? this.bucket,
      key: key ?? this.key,
    );
  }

  factory FileClass.fromJson(Map<String, dynamic> json) {
    return FileClass(
      bucket: json["bucket"],
      key: json["key"],
    );
  }

  Map<String, dynamic> toJson() => {
        "bucket": bucket,
        "key": key,
      };

  @override
  String toString() {
    return "$bucket, $key, ";
  }
}
