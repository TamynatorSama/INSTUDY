import 'dart:ui';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/pages/course_listing/widgets/quiz/quiz_answer.dart';
import 'package:instudy/utils/app_colors.dart';

Future<bool?> popQuiz(BuildContext context) async {
  return await showAnimatedDialog(
      barrierDismissible: true,
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      context: context,
      builder: (context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: GestureDetector(
                onTap: () {},
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                  backgroundColor: Colors.white,
                  child: const PopQuiz(),
                ),
              ),
            ),
          ));
}

class PopQuiz extends StatefulWidget {
  const PopQuiz({super.key});

  @override
  State<PopQuiz> createState() => _PopQuizState();
}

class _PopQuizState extends State<PopQuiz> {
  String value = "";

  clickAnswer(String selected) {
    value = selected;
    print(value);
    setState(() {});
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.pop(context);
      return showAnswer(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child: Column(
          children: [
            Container(
              width: 66,
              height: 66,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Color(0xffE4E4E4), Color(0xffFFFFFF)]),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27))),
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
                      ?.copyWith(fontSize: 34),
                ),
              ),
            ),
            const Gap(9),
            Text(
              "Pop Quiz",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 20),
            ),
            const Gap(24),
            const Divider(),
            const Gap(33),
            Text(
              "Which of the following is the hardest material known to man?",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const Gap(29),
            Wrap(
              runSpacing: 24,
              children: [
                Wrap(
                  spacing: 24,
                  children: [
                    _quizOptions(context,
                        optionIndex: "A",
                        value: "Gold",
                        onTap: clickAnswer,
                        isSelected: value == "A"),
                    _quizOptions(context,
                        optionIndex: "B",
                        value: "Diamond",
                        onTap: clickAnswer,
                        isSelected: value == "B"),
                  ],
                ),
                Wrap(
                  spacing: 24,
                  children: [
                    _quizOptions(context,
                        optionIndex: "C",
                        value: "Iron",
                        onTap: clickAnswer,
                        isSelected: value == "C"),
                    _quizOptions(context,
                        optionIndex: "D",
                        value: "Rubber",
                        onTap: clickAnswer,
                        isSelected: value == "D"),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _quizOptions(BuildContext context,
        {required String optionIndex,
        required String value,
        bool isSelected = false,
        Function(String value)? onTap}) =>
    InkWell(
      onTap: () => onTap?.call(optionIndex),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          constraints: BoxConstraints(
              minWidth: 100,
              maxHeight: MediaQuery.of(context).size.width - ((2 * 24) + 30)),
          decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              color: isSelected
                  ? AppColors.secondaryColor
                  : const Color(0xffF7F7F7)),
          child: Text.rich(TextSpan(
              children: [
                TextSpan(
                    text: "$optionIndex. ",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textColorDark2)),
                TextSpan(text: value)
              ],
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 12, color: isSelected ? Colors.white : null)))),
    );
