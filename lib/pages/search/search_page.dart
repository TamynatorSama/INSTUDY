import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/pages/course_listing/course_holder.dart';
import 'package:instudy/utils/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool hasRecent = false;
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
        body: ListView(
          children: [
            const Gap(24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(44)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(44)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(44)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(44)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
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
                if(hasRecent)
                ...[
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Recent",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 10,color: AppColors.textColorDark2),
                    ),
                  ),
                  const Gap(18),
                  const Divider(),
                  const Gap(18),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [_buildRecent(context)],
                      ))
                ]
                ,if(!hasRecent)...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Results".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 10,color: AppColors.textColorDark2),
                        ),
                        Text(
                          "105 Videos found",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 10,color: AppColors.textColorDark2),
                        ),
                      ],
                    ),
                  ),
                  const Gap(18),
                  const Divider(),
                  const Gap(18),
                ]
              ],
            )
          ],
        ));
  }
}

Widget _buildRecent(BuildContext context, {bool isBold = false}) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
            ),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MET 101",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Gap(2),
                videoInfo(context,
                    icon: "assets/icons/small_user.svg", value: "Prof. john"),
              ],
            )
          ],
        ),
        IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close)),
      ],
    );
