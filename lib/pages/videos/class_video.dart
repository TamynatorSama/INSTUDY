import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/pages/course_listing/course_holder.dart';
import 'package:instudy/pages/videos/class_video_single_view.dart';
import 'package:instudy/utils/app_colors.dart';

class ClassVideoPage extends StatefulWidget {
  const ClassVideoPage({super.key});

  @override
  State<ClassVideoPage> createState() => _ClassVideoPageState();
}

class _ClassVideoPageState extends State<ClassVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            const Gap(24),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                            hintText: "Search  with keyword",
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
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
                    ),
                    const Gap(10),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.pop(context),
                      icon: SvgPicture.asset(
                        "assets/icons/tune.svg",
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(31),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "RECENT CLASS VIDEOS".toUpperCase(),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 10, color: AppColors.textColorDark2),
                    ),
                    Text(
                      "2 Class Videos",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 10, color: AppColors.textColorDark2),
                    ),
                  ],
                ),
              ),
              const Gap(18),
              const Divider(),
              const Gap(18),
            ]),
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (context, index) => const Column(
                  children: [
                    const Gap(24),
                    Divider(),
                    Gap(24)
                  ],
                ),
                itemBuilder: (context,index)=>_buildClassVideoHolder(context))
            ),
          ],
        );
  }
}

Widget _buildClassVideoHolder(BuildContext context) => InkWell(
  onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>const ClassVideoSingleView())),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      children: [
        Container(
          height: 100,
          width: 100,
          
          decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),color: AppColors.accentColor),
        ),
        const Gap(13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("MET 101",style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 10,color: AppColors.textColorDark2),),
              const Gap(4),
              Text("Hardness of Materials",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.displayMedium,),
              const Gap(4),
               Text("Full Class Video",
               
               style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 10,color: AppColors.textColorDark2),),
               const Gap(16),       
              Wrap(
                                      spacing: 10,
                                      children: [
                                        videoInfo(context,
                                            icon: "assets/icons/small_user.svg",
                                            value: "Prof. john"),
                                        videoInfo(context,
                                            icon:
                                                "assets/icons/small_video_camera.svg",
                                            value: "1 of 5"),
                                        videoInfo(context, value: "5 hours ago"),
                                      ],
                                    )
            ],
          ),
        )
      ],
    ),
  ),
);
