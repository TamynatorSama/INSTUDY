import 'dart:async';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instudy/models/video_transcript.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:easy_debounce/easy_debounce.dart';

class OverlayControls extends StatefulWidget {
  final CachedVideoPlayerPlusController control;
  final VideoTranscript? transcripts;

  const OverlayControls({
    super.key,
    required this.control,
    this.transcripts
  });

  @override
  State<OverlayControls> createState() => _OverlayControlsState();
}

class _OverlayControlsState extends State<OverlayControls>
    with TickerProviderStateMixin {
  // AnimationController? _control;
  // AnimationController? _opacity;
  // AnimationController? _right;
  // AnimationController? _left;
  bool offstage = false;
  Timer? _allControl;

  bool showAll = false;
  bool showLeft = false;
  bool showRight = false;
  bool showBottom = false;

  bool captionActive = false;

  @override
  void initState() {
    // _control = AnimationController(
    //     vsync: this, duration: const Duration(microseconds: 500));
    // _opacity = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 100));
    // _right = AnimationController(
    //     vsync: this, duration: const Duration(microseconds: 150));
    // _left = AnimationController(
    //     vsync: this, duration: const Duration(microseconds: 150));
    // _opacity!.forward();

    super.initState();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.control,
        builder: (context, _) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              widget.control.value.isBuffering
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const SizedBox(),
              GestureDetector(
                onTap: () {
                  _allControl?.cancel();
                  setState(() {
                    showBottom = true;
                    showAll = true;
                  });

                  // _allControl.call();

                  EasyDebounce.debounce(
                      'all-controls', // <-- An ID for this particular debouncer
                      const Duration(seconds: 2), // <-- The debounce duration
                      () async {
                    _allControl = Timer(const Duration(seconds: 2), () async {
                      setState(() => showAll = false);
                      await Future.delayed(const Duration(seconds: 2),
                          () => setState(() => showBottom = false));
                    });
                  } // <-- The target method
                      );
                },
                child: Container(
                  color: showAll
                      ? Colors.black.withOpacity(0.4)
                      : Colors.black.withOpacity(0),
                  child: OrientationBuilder(builder: (context, orientation) {
                    return Stack(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onDoubleTap: () {
                                  //seeking backward function
                                  setState(() => showLeft = true);
                                  widget.control.seekTo(
                                      widget.control.value.position -
                                          const Duration(seconds: 3));

                                  EasyDebounce.cancel("left-controls");
                                  EasyDebounce.debounce(
                                      'left-controls', // <-- An ID for this particular debouncer
                                      const Duration(
                                          seconds:
                                              1), // <-- The debounce duration
                                      () async {
                                    await Future.delayed(
                                        const Duration(seconds: 1),
                                        () => setState(() => showLeft = false));
                                  } // <-- The target method
                                      );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 100),
                                  alignment: Alignment.center,
                                  color: Colors.black.withOpacity(0),
                                  width: double.maxFinite,
                                  child: AnimatedOpacity(
                                    opacity: showLeft || showAll ? 1 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SvgPicture.string(
                                        '''<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none" stroke="white" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path d="M7 9L4 6l3-3"/><path d="M15.997 17.918A6.002 6.002 0 0 0 15 6H4m2 8v6m3-4.5v3a1.5 1.5 0 0 0 3 0v-3a1.5 1.5 0 0 0-3 0"/></g></svg>'''),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: showAll ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Stack(
                                children: [
                                  IconButton(
                                      splashColor:
                                          Colors.black.withOpacity(0.5),
                                      splashRadius: 10,
                                      onPressed: () {
                                        if (widget.control.value.isPlaying) {
                                          widget.control.pause();
                                        } else {
                                          widget.control.play();
                                        }

                                        _allControl?.cancel();
                                        setState(() {
                                          showBottom = true;
                                          showAll = true;
                                        });

                                        // _allControl.call();

                                        EasyDebounce.debounce(
                                            'all-controls', // <-- An ID for this particular debouncer
                                            const Duration(
                                                seconds:
                                                    2), // <-- The debounce duration
                                            () async {
                                          _allControl =
                                              Timer(const Duration(seconds: 2),
                                                  () async {
                                            setState(() => showAll = false);
                                            await Future.delayed(
                                                const Duration(seconds: 2),
                                                () => setState(
                                                    () => showBottom = false));
                                          });
                                        } // <-- The target method
                                            );
                                      },
                                      icon: SvgPicture.string(widget
                                              .control.value.isPlaying
                                          ? '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="white" d="M2 6c0-1.886 0-2.828.586-3.414S4.114 2 6 2s2.828 0 3.414.586S10 4.114 10 6v12c0 1.886 0 2.828-.586 3.414S7.886 22 6 22s-2.828 0-3.414-.586S2 19.886 2 18zm12 0c0-1.886 0-2.828.586-3.414S16.114 2 18 2s2.828 0 3.414.586S22 4.114 22 6v12c0 1.886 0 2.828-.586 3.414S19.886 22 18 22s-2.828 0-3.414-.586S14 19.886 14 18z"/></svg>'
                                          : '''<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none" fill-rule="evenodd"><path d="m12.593 23.258l-.011.002l-.071.035l-.02.004l-.014-.004l-.071-.035q-.016-.005-.024.005l-.004.01l-.017.428l.005.02l.01.013l.104.074l.015.004l.012-.004l.104-.074l.012-.016l.004-.017l-.017-.427q-.004-.016-.017-.018m.265-.113l-.013.002l-.185.093l-.01.01l-.003.011l.018.43l.005.012l.008.007l.201.093q.019.005.029-.008l.004-.014l-.034-.614q-.005-.018-.02-.022m-.715.002a.02.02 0 0 0-.027.006l-.006.014l-.034.614q.001.018.017.024l.015-.002l.201-.093l.01-.008l.004-.011l.017-.43l-.003-.012l-.01-.01z"/><path fill="white" d="M5.669 4.76a1.47 1.47 0 0 1 2.04-1.177c1.062.454 3.442 1.533 6.462 3.276c3.021 1.744 5.146 3.267 6.069 3.958c.788.591.79 1.763.001 2.356c-.914.687-3.013 2.19-6.07 3.956c-3.06 1.766-5.412 2.832-6.464 3.28c-.906.387-1.92-.2-2.038-1.177c-.138-1.142-.396-3.735-.396-7.237c0-3.5.257-6.092.396-7.235"/></g></svg>''')),
                                ],
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onDoubleTap: () {
                                  setState(() => showRight = true);

                                  widget.control.seekTo(
                                      widget.control.value.position +
                                          const Duration(seconds: 3));
                                  EasyDebounce.cancel("right-controls");
                                  EasyDebounce.debounce(
                                      'right-controls', // <-- An ID for this particular debouncer
                                      const Duration(
                                          seconds:
                                              1), // <-- The debounce duration
                                      () async {
                                    await Future.delayed(
                                        const Duration(seconds: 1),
                                        () =>
                                            setState(() => showRight = false));
                                  } // <-- The target method
                                      );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 100),
                                  alignment: Alignment.center,
                                  color: Colors.black.withOpacity(0),
                                  width: double.maxFinite,
                                  child: AnimatedOpacity(
                                    opacity: showRight || showAll ? 1 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SvgPicture.string(
                                        '''<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none" stroke="white" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path d="m17 9l3-3l-3-3"/><path d="M8 17.918A6 6 0 0 1 3 12a6 6 0 0 1 6-6h11m-8 8v6m3-4.5v3a1.5 1.5 0 0 0 3 0v-3a1.5 1.5 0 0 0-3 0"/></g></svg>'''),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                        //progress indicator, timer , settings, flip_screen widget
                        Offstage(
                          // duration:  Duration(seconds:(showBottom || showAll)?1:4),
                          offstage: !showBottom,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 11,
                                  child: VideoProgressIndicator(
                                    widget.control,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                        playedColor: AppColors.primaryColor),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (widget
                                                  .control.value.isPlaying) {
                                                widget.control.pause();
                                              } else {
                                                widget.control.play();
                                                setState(() {
                                                  showAll = false;
                                                });
                                              }
                                            },
                                            icon: SvgPicture.string(widget
                                                    .control.value.isPlaying
                                                ? '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="white" d="M2 6c0-1.886 0-2.828.586-3.414S4.114 2 6 2s2.828 0 3.414.586S10 4.114 10 6v12c0 1.886 0 2.828-.586 3.414S7.886 22 6 22s-2.828 0-3.414-.586S2 19.886 2 18zm12 0c0-1.886 0-2.828.586-3.414S16.114 2 18 2s2.828 0 3.414.586S22 4.114 22 6v12c0 1.886 0 2.828-.586 3.414S19.886 22 18 22s-2.828 0-3.414-.586S14 19.886 14 18z"/></svg>'
                                                : '''<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none" fill-rule="evenodd"><path d="m12.593 23.258l-.011.002l-.071.035l-.02.004l-.014-.004l-.071-.035q-.016-.005-.024.005l-.004.01l-.017.428l.005.02l.01.013l.104.074l.015.004l.012-.004l.104-.074l.012-.016l.004-.017l-.017-.427q-.004-.016-.017-.018m.265-.113l-.013.002l-.185.093l-.01.01l-.003.011l.018.43l.005.012l.008.007l.201.093q.019.005.029-.008l.004-.014l-.034-.614q-.005-.018-.02-.022m-.715.002a.02.02 0 0 0-.027.006l-.006.014l-.034.614q.001.018.017.024l.015-.002l.201-.093l.01-.008l.004-.011l.017-.43l-.003-.012l-.01-.01z"/><path fill="white" d="M5.669 4.76a1.47 1.47 0 0 1 2.04-1.177c1.062.454 3.442 1.533 6.462 3.276c3.021 1.744 5.146 3.267 6.069 3.958c.788.591.79 1.763.001 2.356c-.914.687-3.013 2.19-6.07 3.956c-3.06 1.766-5.412 2.832-6.464 3.28c-.906.387-1.92-.2-2.038-1.177c-.138-1.142-.396-3.735-.396-7.237c0-3.5.257-6.092.396-7.235"/></g></svg>''')),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                              "${constructTimer(widget.control.value.position.inSeconds)} / ${constructTimer(widget.control.value.duration.inSeconds)}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium
                                                  ?.copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                captionActive = !captionActive;
                                              });
                                            },
                                            icon: SvgPicture.string(''''<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 512 512"><path fill="white" d="M464 64H48C21.5 64 0 85.5 0 112v288c0 26.5 21.5 48 48 48h416c26.5 0 48-21.5 48-48V112c0-26.5-21.5-48-48-48M218.1 287.7c2.8-2.5 7.1-2.1 9.2.9l19.5 27.7c1.7 2.4 1.5 5.6-.5 7.7c-53.6 56.8-172.8 32.1-172.8-67.9c0-97.3 121.7-119.5 172.5-70.1c2.1 2 2.5 3.2 1 5.7l-17.5 30.5c-1.9 3.1-6.2 4-9.1 1.7c-40.8-32-94.6-14.9-94.6 31.2c.1 48 51.1 70.5 92.3 32.6m190.4 0c2.8-2.5 7.1-2.1 9.2.9l19.5 27.7c1.7 2.4 1.5 5.6-.5 7.7c-53.5 56.9-172.7 32.1-172.7-67.9c0-97.3 121.7-119.5 172.5-70.1c2.1 2 2.5 3.2 1 5.7L420 222.2c-1.9 3.1-6.2 4-9.1 1.7c-40.8-32-94.6-14.9-94.6 31.2c0 48 51 70.5 92.2 32.6"/></svg>'''
,width: 22,colorFilter: ColorFilter.mode(!captionActive?Colors.white.withOpacity(0.7):Colors.white,BlendMode.srcIn),
                                        )),IconButton(
                                            onPressed: () {
                                              setLandscape(false);
                                              // Provider.of<StateManager>(context,
                                              //         listen: false)
                                              //     .setOrientation(context);
                                            },
                                            icon: const Icon(
                                              Icons.fit_screen,
                                              color: Colors.white,
                                            ))
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          );
        });
  }
}

String constructTimer(int counter) {
  int hours = (counter / 3600).floor();
  int minutes = ((counter % 3600) / 60).floor();
  int secs = counter % 60;

  return "${hours <= 0 ? "" : hours.toString().padLeft(2, '0')}${hours <= 0 ? "" : ":"}${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
}

Future setLandscape(bool setLand) async {
  if (setLand) {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  } else {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
}

Future reset() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
