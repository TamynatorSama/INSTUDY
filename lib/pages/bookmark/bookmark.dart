import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/pages/course_listing/course_holder.dart';
import 'package:instudy/utils/app_colors.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool hasRecent = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

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
                const Gap(21),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(6)),
                  child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 12),
                      unselectedLabelStyle: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 12, color: AppColors.textColorDark2),
                      indicator: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 19.6,
                              offset: const Offset(0, 1),
                              color: AppColors.accentColor)
                        ],
                        borderRadius: BorderRadius.circular(7),
                      ),
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          text: "Bookmarks",
                        ),
                        Tab(
                          text: "Tags",
                        ),
                      ]),
                ),
              ],
            ),
            const Gap(24),
            Expanded(
                child: TabBarView(controller: _tabController, children: [
              ListView(
                children: const [
                  CourseContentHolder(
                    value: 1,
                  )
                ],
              ),
              Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1,
                  crossAxisSpacing: 24,
                  children: [
                    _buildTags(context,text: "Materials"),
                    _buildTags(context,text:"Heat")
                  ],
                ),
              )
            ])),
          ],
        ));
  }
}

Widget _buildTags(BuildContext context,{required String text}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: double.infinity,
            decoration: ShapeDecoration(
              color: AppColors.accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
        const Gap(10),
        Text(
          text,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
