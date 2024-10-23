import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:instudy/models/video_transcript.dart';
import 'package:instudy/provider/course_video_listing_provider.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:instudy/utils/overlay_control.dart';
import 'package:provider/provider.dart';

class VideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final VideoTranscript? transcripts;
  const VideoPlayer({super.key, this.videoUrl, this.transcripts});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // if (context.read<CourseVideoListingProvider>().landScape) {
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeLeft,
    //     // DeviceOrientation.landscapeRight,
    //   ]);
    // }

    if (context.read<CourseVideoListingProvider>().controller == null) {
      context.read<CourseVideoListingProvider>().controller =
          CachedVideoPlayerPlusController.networkUrl(
              Uri.parse(widget.videoUrl!))
            ..initialize().then((_) {
              context
                  .read<CourseVideoListingProvider>()
                  .controller!
                  .seekTo(const Duration(seconds: 1));
              context.read<CourseVideoListingProvider>().controller!.play();
              if(mounted){
                setState(() {});
              }
            });
    }

    super.initState();
  }

  @override
  void dispose() {
    // if (context.read<CourseVideoListingProvider>().done) {
      print("disposing");
      context.read<CourseVideoListingProvider>().controller?.dispose();
      context.read<CourseVideoListingProvider>().controller = null;
    // }
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return context
                .read<CourseVideoListingProvider>()
                .controller
                ?.value
                .isInitialized ??
            false
        ? Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              OrientationBuilder(builder: (context, orientation) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedVideoPlayerPlus(context
                        .read<CourseVideoListingProvider>()
                        .controller!));
                // return AspectRatio(
                //   aspectRatio: orientation == Orientation.portrait
                //       ? _controller.value.aspectRatio
                //       : MediaQuery.of(context).size.width >
                //               MediaQuery.of(context).size.height
                //           ? MediaQuery.of(context).size.width /
                //               MediaQuery.of(context).size.height
                //           : MediaQuery.of(context).size.height /
                //               MediaQuery.of(context).size.width,
                //   child: CachedVideoPlayerPlus(_controller),
                // );
              }),
              OverlayControls(
                transcripts: widget.transcripts,
                switchToLandScape: () => context
                    .read<CourseVideoListingProvider>()
                    .setLandscape(context),
                control: context.read<CourseVideoListingProvider>().controller!,
              )
            ],
          )
        : AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: AppColors.accentColor.withOpacity(0.3),
              ),
            ),
          );
  }
}

String convertDuration(Duration pos) {
  var newposition = pos.inSeconds;

  var minString = "";
  var secString = "";

  var min = (newposition / 60).floor();
  if (min < 10) {
    minString = "0$min";
  } else {
    minString = "$min";
  }
  if (newposition < 10) {
    secString = "0$newposition";
  } else {
    secString = "$newposition";
  }

  return "$minString : $secString";
}
