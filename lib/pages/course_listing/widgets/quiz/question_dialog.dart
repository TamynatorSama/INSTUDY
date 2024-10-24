import 'dart:ui';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/models/quiz.dart';
import 'package:instudy/pages/course_listing/widgets/quiz/quiz_answer.dart';
import 'package:instudy/utils/app_colors.dart';

Future<bool?> popQuiz(BuildContext context, {required Quiz popQuiz}) async {
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
                  child: PopQuiz(
                    popQuiz: popQuiz,
                  ),
                ),
              ),
            ),
          ));
}

class PopQuiz extends StatefulWidget {
  final Quiz popQuiz;
  const PopQuiz({super.key, required this.popQuiz});

  @override
  State<PopQuiz> createState() => _PopQuizState();
}

class _PopQuizState extends State<PopQuiz> {
  String value = "";

  clickAnswer(Option option) {
    value = option.optionLetter ;
    print(value);
    setState(() {});
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.pop(context);
      return showAnswer(context,chosenOption: option,answer: widget.popQuiz.options.firstWhere((e)=>e.answer));
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
              widget.popQuiz.question,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const Gap(29),
            Wrap(
              runSpacing: 10,
              children: [
                Wrap(
                    spacing: 24,
                    children: List.generate(
                      widget.popQuiz.options.length.clamp(0, 2),
                      (index) {
                        Option option = widget.popQuiz.options[index];
                        return _quizOptions(context,
                            option: option,
                            onTap: clickAnswer,
                            isSelected: value == option.optionLetter.toUpperCase());
                      },
                    )),
                Wrap(
                    spacing: 24,
                    children: List.generate(
                      widget.popQuiz.options.sublist(2).length,
                      (index) {
                        Option option = widget.popQuiz.options.sublist(2)[index];
                        return _quizOptions(context,
                            option: option,
                            onTap: clickAnswer,
                            isSelected: value == option.optionLetter.toUpperCase());
                      },
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _quizOptions(BuildContext context,
        {required Option option,
        bool isSelected = false,
        Function(Option option)? onTap}) =>
    InkWell(
      onTap: () => onTap?.call(option),
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
                    text: "${option.optionLetter}. ",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textColorDark2)),
                TextSpan(text: option.optionText)
              ],
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 12, color: isSelected ? Colors.white : null)))),
    );
