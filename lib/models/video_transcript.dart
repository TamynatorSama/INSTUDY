class VideoTranscript {
  final String? id;
  final String title;
  final String fullTranscript;
  final String videoID;
  final List<TimedTranscript> transcripts;

  const VideoTranscript(
      {this.id,
      required this.fullTranscript,
      required this.title,
      required this.transcripts,
      required this.videoID});

  factory VideoTranscript.fromJson(Map<String, dynamic> json) {
    return VideoTranscript(
      id: json["_id"],
      title: json["title"],
      videoID: json["video_id"],
      fullTranscript: json["full_transcript"],
      transcripts: (json["timed_transcript"] as List).map((e)=>TimedTranscript.fromJson(e)).toList()
    );
  }
}

class TimedTranscript {
  TimedTranscript({
    required this.startTime,
    required this.endTime,
    required this.transcript,
  });

  final double startTime;
  final double endTime;
  final String transcript;

  TimedTranscript copyWith({
    double? startTime,
    double? endTime,
    String? transcript,
  }) {
    return TimedTranscript(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      transcript: transcript ?? this.transcript,
    );
  }

  factory TimedTranscript.fromJson(Map<String, dynamic> json) {
    return TimedTranscript(
      startTime: double.parse(json["start_time"].toString()),
      endTime: double.parse(json["end_time"].toString()),
      transcript: json["transcript"],
    );
  }

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
        "end_time": endTime,
        "transcript": transcript,
      };

  @override
  String toString() {
    return "$startTime, $endTime, $transcript,";
  }
}
