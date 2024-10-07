import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/pages/course_listing/widgets/quiz/question_dialog.dart';
import 'package:instudy/utils/app_colors.dart';

bool isOpened = false;

Future openMoreOptions(BuildContext context) async {
  isOpened = true;
  await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isDismissible: true,
      builder: (_) => const ContentOptions());
  isOpened = false;
}

class ContentOptions extends StatelessWidget {
  const ContentOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24.0, 0, 24.0, MediaQuery.paddingOf(context).bottom + 20),
      child: Wrap(
        runSpacing: 24,
        children: [
          _option(context,
              value: "Go to full Video", icon: "assets/icons/play.svg"),
          _option(context,
              value: "Add to a Tag collection", icon: "assets/icons/plus.svg"),
          _option(context, value: "Create Pop Quiz on Topic", isSpecial: true,
              onTap: () {
            Navigator.pop(context);
            return popQuiz(context);
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
