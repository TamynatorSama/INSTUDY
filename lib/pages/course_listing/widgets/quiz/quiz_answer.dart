import 'dart:ui';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/usables/custom_btn.dart';
import 'package:instudy/utils/app_colors.dart';

Future<bool?> showAnswer(BuildContext context) async {
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
                  child: const PopQuizAnswer(),
                ),
              ),
            ),
          ));
}

class PopQuizAnswer extends StatefulWidget {
  const PopQuizAnswer({super.key});

  @override
  State<PopQuizAnswer> createState() => _PopQuizAnswerState();
}

class _PopQuizAnswerState extends State<PopQuizAnswer> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: Column(
          children: [
            const Gap(15),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () =>Navigator.pop(context),
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
            SvgPicture.asset("assets/icons/check_filled.svg"),
            const Gap(24),
            Text("Correct.",style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 14,color: const Color(0xff08A051)),),
            const Gap(24),
            Text("Ans: B. Diamond",style: Theme.of(context).textTheme.bodyLarge,),
            const Gap(24),
            const CustomButton(text: "Next Question") ,
            const Gap(32)
          ],
        ),
      ),
    );
  }
}

Widget _quizOptions(BuildContext context,{required String optionIndex,required String value}) =>Container(
  padding: const EdgeInsets.symmetric(horizontal:10,vertical: 8),
  constraints: BoxConstraints(minWidth: 100,maxHeight: MediaQuery.of(context).size.width - ((2*24)+30)),
  decoration: const ShapeDecoration(shape: StadiumBorder(
    
  ),color: Color(0xffF7F7F7)),
  child: 
  Text.rich(TextSpan(
    children: [
      TextSpan(
        text: "$optionIndex. ",
        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 12,color: AppColors.textColorDark2)
      ),
      TextSpan(
        text: value
      )
    ],style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 12)
  )));
