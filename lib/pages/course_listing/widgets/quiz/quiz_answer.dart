import 'dart:ui';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/models/quiz.dart';
import 'package:instudy/usables/custom_btn.dart';
import 'package:instudy/utils/app_colors.dart';

Future<bool?> showAnswer(BuildContext context,
    {required Option chosenOption, required Option answer}) async {
  return await showAnimatedDialog(
      barrierDismissible: true,
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 900),
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
                  child: PopQuizAnswer(chosenOption: chosenOption,answer: answer,),
                ),
              ),
            ),
          ));
}

class PopQuizAnswer extends StatefulWidget {
  final Option chosenOption;
  final Option answer;
  const PopQuizAnswer(
      {super.key,
      required this.chosenOption,
      required this.answer});

  @override
  State<PopQuizAnswer> createState() => _PopQuizAnswerState();
}

class _PopQuizAnswerState extends State<PopQuizAnswer> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: Column(
          children: [
            const Gap(15),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => Navigator.pop(context),
                icon: SvgPicture.asset(
                  "assets/icons/close.svg",
                  width: 24,
                ),
              ),
            ),
            const Gap(10),
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
            const Gap(24),
            SvgPicture.asset(widget.chosenOption.answer? "assets/icons/correct.svg":"assets/icons/wrong.svg",width: 60,),
            const Gap(24),
            Text(
              widget.chosenOption.answer? "Correct.":"Incorrect",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontSize: 14, color:widget.chosenOption.answer? const Color(0xff08A051):Colors.red),
            ),
            const Gap(24),
            Text(
              "Ans: ${widget.answer.optionLetter.toUpperCase()}. ${widget.answer.optionText}",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            CustomButton(text: "Close",onTap: ()=>Navigator.pop(context)),
            const Gap(32)
          ],
        ),
      ),
    );
  }
}

Widget _quizOptions(BuildContext context,
        {required String optionIndex, required String value}) =>
    Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        constraints: BoxConstraints(
            minWidth: 100,
            maxHeight: MediaQuery.of(context).size.width - ((2 * 24) + 30)),
        decoration: const ShapeDecoration(
            shape: StadiumBorder(), color: Color(0xffF7F7F7)),
        child: Text.rich(TextSpan(
            children: [
              TextSpan(
                  text: "$optionIndex. ",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 12, color: AppColors.textColorDark2)),
              TextSpan(text: value)
            ],
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 12))));
