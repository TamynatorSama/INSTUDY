import 'dart:ui';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:instudy/repo/dashboard_repo.dart';
import 'package:instudy/usables/custom_btn.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:typewritertext/typewritertext.dart';

Future<bool?> askQuestion(BuildContext context,
    {required String feedID}) async {
  return await showAnimatedDialog(
      barrierDismissible: true,
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      context: context,
      
      builder: (context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.pop(context),
            // child: BackdropFilter(
            // filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: GestureDetector(
              onTap: () {},
              child: Dialog(
                
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              
                insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                backgroundColor: Colors.white,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 400),
                  child: AskQuestion(
                    feedID: feedID,
                  ),
                ),
              ),
            ),
            // ),
          ));
}

class AskQuestion extends StatefulWidget {
  final String feedID;
  const AskQuestion({super.key, required this.feedID});

  @override
  State<AskQuestion> createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  bool done = false;
  bool isLoadingAnswer = false;
  String? answer;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15, top: 20),
        child: Column(
          children: [
            Container(
              width: 66,
              height: 66,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                  color: const Color(0xffFAFAFA),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: Text(
                "?",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 34),
              ),
            ),
            const Gap(9),
            Text(
              "Ask a question",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 20),
            ),
            const Gap(5),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(20),
                    Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    constraints: BoxConstraints(maxWidth: done?MediaQuery.sizeOf(context).width*0.65:double.maxFinite),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  width: done ?null : double.maxFinite,
                  decoration: ShapeDecoration(
                      color: const Color(0xffFAFAFA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                    child: done?Text(_controller.text,style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 13),) : TextFormField(
                      controller: _controller,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "What do you want know ?",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 13, color: AppColors.textColorDark2),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 13),
                    ),
                  ),
                ),
                
                if (done) ...[
                  const Gap(15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      width: MediaQuery.sizeOf(context).width*0.65,
                      decoration: ShapeDecoration(
                          color: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: isLoadingAnswer
                          ? SpinKitThreeBounce(
                              size: 20,
                              itemBuilder: (context, index) => const CircleAvatar(
                                radius: 1,
                                backgroundColor: Colors.white,
                              ),
                            )
                          : !isLoadingAnswer && answer == null
                              ? Text(
                                  "Couldn't get an answer to that question",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 13, color: Colors.white),
                                )
                              : TypeWriter.text(
                                  answer!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 13, color: Colors.white),
                                  duration: const Duration(milliseconds: 50),
                                ),
                    ),
                  )
                ],
                const Gap(20),
                  ],
                ),
              ),
            ),
            const Gap(5),
            CustomButton(
              text: done ? "Close" : "Send",
              showLoader: false,
              onTap: () async {
                if (!done) {
                  isLoadingAnswer = true;
                  setState(() {
                    done = true;
                  });
                  await DashboardRepo()
                      .askQuestion(
                          feedID: widget.feedID, question: "what is aws batch  used for exactly")
                      .then((value) {
                    isLoadingAnswer = false;
                    if (value.status) {
                      answer = value.result;
                    }
                    setState(() {});
                  });
                  return;
                }
                Navigator.pop(context);
              },
            ),
            const Gap(20),
          ],
        ));
  }
}
// {{base}}/api/v1/secure/feeds/ask/6717f1d53839c3d4cbd9f939
// {
//     "question": "when did AWS start?"
// }
// {
//   "status": "SUCCESS",
//   "code": 200,
//   "message": "successful!",
//   "data": "AWS started its journey with Kubernetes in 2017."
// }

