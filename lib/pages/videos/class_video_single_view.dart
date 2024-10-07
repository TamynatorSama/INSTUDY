import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/pages/course_listing/course_holder.dart';
import 'package:instudy/utils/app_colors.dart';

class ClassVideoSingleView extends StatelessWidget {
  const ClassVideoSingleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "INSTUDY",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 1,
        scrolledUnderElevation: 0,
        shadowColor: AppColors.accentColor,
        actions: [
          SvgPicture.asset("assets/icons/notification.svg"),
          const Gap(24),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(24),
                InkWell(
                    // visualDensity: VisualDensity.compact,
                    // style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(1))),
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back)),
                const Gap(10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Hardness of Materials",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Gap(5),
                    Expanded(
                      child: Text(
                        "Full Class Video",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  ],
                ),
                const Gap(7),
                Wrap(
                  spacing: 10,
                  children: [
                    videoInfo(context,
                        icon: "assets/icons/small_user.svg",
                        value: "Prof. john"),
                    videoInfo(context,
                        icon: "assets/icons/small_video_camera.svg",
                        value: "1 of 5"),
                    videoInfo(context, value: "5 hours ago"),
                  ],
                ),
                const Gap(20),
                Container(
                  width: double.maxFinite,
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: AppColors.accentColor,
                  ),
                ),
                const Gap(20),
                Text(
                  "Audio Transcript",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 14,
                      ),
                ),
                const Gap(13),
                TextFormField(
                  decoration: InputDecoration(
                      filled: true,
                      prefixIcon: IntrinsicWidth(
                        child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: SvgPicture.asset(
                              "assets/icons/search_large.svg",
                              width: 24,
                            )),
                      ),
                      hintText: "Search  Transcript",
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      // fillColor: Colors.blueAccent,
                      fillColor: const Color(0xffFAFAFA),
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(44)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(44)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(44)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(44)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(44))),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
          const Gap(10),
          const Divider(),
          const Gap(20),
          Expanded(
            child: Scrollbar(child: ListView.separated(itemBuilder: (context,index)=>_buildTranscipts(context,isShowing: index==0, text: "Today we are going to learn about the hardness of materials.",timeStamp: index*  10), separatorBuilder: (context,index)=>const Gap(15), itemCount: 2)),
          )
        ],
      ),
    );
  }
}

Widget _buildTranscipts(BuildContext context,{required int timeStamp,required String text,bool isShowing = false}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  child: Column
  (
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(constructTimer(timeStamp),style: Theme.of(context).textTheme.displaySmall,),
      const Gap(8),
      Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: ShapeDecoration(shape: RoundedRectangleBorder(side: BorderSide(width: 1,color:AppColors.accentColor ),borderRadius: BorderRadius.circular(14)),color: isShowing?const Color(0xffFAFAFA):Colors.white),
        child: LayoutBuilder(builder: (context,constraints)=>ConstrainedBox(constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),child: Text(text,style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: isShowing?null:AppColors.textColorDark2),),)),
      ),
    ],
  ),
);

String constructTimer(int counter) {
  int hours = (counter / 3600).floor();
  int minutes = ((counter % 3600) / 60).floor();
  int secs = counter % 60;

  return "${hours <= 0 ? "" : hours.toString().padLeft(2, '0')}${hours <= 0 ? "" : ":"}${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
}

// padding: const EdgeInsets.only(left:20.0,right: 10),
