import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/models/course_listing_model.dart';
import 'package:instudy/pages/course_listing/widgets/quiz/question_dialog.dart';
import 'package:instudy/pages/course_listing/widgets/tag_selector.dart';
import 'package:instudy/pages/videos/class_video_single_view.dart';
import 'package:instudy/provider/dashboard_provider.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:provider/provider.dart';

bool isOpened = false;

Future openMoreOptions(BuildContext context,
    {required CourseListingModel listingModel}) async {
  isOpened = true;
  await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isDismissible: true,
      builder: (_) => ContentOptions(
            listingModel: listingModel,
          ));
  isOpened = false;
}

class ContentOptions extends StatefulWidget {
  final CourseListingModel listingModel;
  const ContentOptions({super.key, required this.listingModel});

  @override
  State<ContentOptions> createState() => _ContentOptionsState();
}

class _ContentOptionsState extends State<ContentOptions> {
  OverlayEntry? entry;

  loadQuiz() {
    entry = OverlayEntry(
        builder: (context) => SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Center(
                child: Container(
                  height: 70,
                  width: 70,
                  padding: const EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white),
                  child: const CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ));

    Overlay.of(context).insert(entry!);
  }

  removeEntry() {
    if (entry?.mounted ?? false) {
      entry?.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24.0, 0, 24.0, MediaQuery.paddingOf(context).bottom + 20),
      child: Wrap(
        runSpacing: 24,
        children: [
          _option(context,
              value: "Go to full Video",
              icon: "assets/icons/play.svg", onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClassVideoSingleView(
                          course: widget.listingModel.video,
                        )));
          }),
          _option(context,
              value: "Add to a Tag collection",
              icon: "assets/icons/plus.svg", onTap: () {
            Navigator.pop(context);
            chooseTag(context, widget.listingModel.id);
          }),
          _option(context, value: "Create Pop Quiz on Topic", isSpecial: true,
              onTap: () async {
            loadQuiz();
            await context
                .read<DashboardProvider>()
                .getQuiz(context, feedID: widget.listingModel.id)
                .then((value) {
              removeEntry();
              if (value == null) {
                return value;
              }
              Navigator.pop(context);
              return popQuiz(context, popQuiz: value);
            });
          }),
        ],
      ),
    );
  }
}

Widget _option(BuildContext context,
        {String? icon,
        required String value,
        bool isSpecial = false,
        Function()? onTap}) =>
    InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isSpecial) ...[
            CircleAvatar(
              backgroundColor: AppColors.accentColor,
              radius: 20,
              child: Badge(
                alignment: const AlignmentDirectional(0.5, -1),
                backgroundColor: Colors.transparent,
                smallSize: 20,
                largeSize: 25,
                label: SvgPicture.asset("assets/icons/spakle.svg"),
                offset: const Offset(-0, -3),
                child: Text(
                  "?",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 24),
                ),
              ),
            ),
            const Gap(10),
          ],
          if (icon != null) ...[
            CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: SvgPicture.asset(
                  icon,
                  width: 28,
                )),
            const Gap(10),
          ],
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 14),
          )
        ],
      ),
    );
