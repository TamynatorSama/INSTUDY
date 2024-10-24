import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/models/tags.dart';
import 'package:instudy/pages/course_listing/course_holder.dart';
import 'package:instudy/provider/bookmark_tag_provider.dart';
import 'package:instudy/usables/expandable_scrollable_widget.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (context.read<BookmarkTagProvider>().bookMarks.isEmpty) {
        context.read<BookmarkTagProvider>().fetchBookMarks(context: context);
      }
      if (context.read<BookmarkTagProvider>().tags.isEmpty) {
        context.read<BookmarkTagProvider>().fetchTags(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkTagProvider>(
      builder: (_, ref, __) {
        return Column(
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
              RefreshIndicator(
                onRefresh: ()async{
            await context.read<BookmarkTagProvider>().fetchBookMarks(context: context);
           
          },
                child: ref.bookMarks.isEmpty &&
                        !ref.isLoadingBookmark &&
                        ref.hasLoadedBookmark
                    ? const ExpandableScrollableWidget(
                      physics: AlwaysScrollableScrollPhysics(),
                      child:  Center(
                          child: Text("No Item in Bookmark"),
                        ),
                    )
                    : Skeletonizer(
                        enabled: ref.isLoadingBookmark && ref.bookMarks.isEmpty,
                        child: ListView.builder(
                            itemCount:
                                ref.isLoadingBookmark && ref.bookMarks.isEmpty
                                    ? 1
                                    : ref.bookMarks.length,
                            itemBuilder: (context, index) =>
                                ref.isLoadingBookmark && ref.bookMarks.isEmpty
                                    ? const CourseContentHolder(
                                        value: 1,
                                      )
                                    : CourseContentHolder(
                                        video:
                                            ref.bookMarks[index].courseListing(),
                                      )),
                      ),
              ),
              RefreshIndicator(
                onRefresh: ()async{
            await context.read<BookmarkTagProvider>().fetchTags(context);
          },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child:
                      ref.tags.isEmpty && !ref.isLoadingTags && ref.hasLoadedTags
                          ? const ExpandableScrollableWidget(
                            physics: AlwaysScrollableScrollPhysics(),
                            child:  Center(
                                child: Text("No Item in Tags"),
                              ),
                          )
                          : Skeletonizer(
                              enabled: ref.isLoadingTags && ref.tags.isEmpty,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 24,
                                  childAspectRatio: 1,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 24,
                                ),
                                itemCount: ref.tags.length,
                                itemBuilder: (context, index) =>
                                    _buildTags(context, tag: ref.tags[index]),
                              ),
                            ),
                ),
              )
            ])),
          ],
        );
      },
    );
  }
}

Widget _buildTags(BuildContext context, {required Tags tag}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: ShapeDecoration(
                color: AppColors.accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: GridView.custom(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: [
                  const QuiltedGridTile(2, 2),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(2, 2),
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                childCount: tag.tagContent.length,
                (context, index) => FutureBuilder(
                    future: tag.tagContent[index].video.getThumbnail(null),
                    builder: (context, snapshot) => snapshot.data != null
                        ? Image.memory(snapshot.data!,fit: BoxFit.cover,)
                        : SvgPicture.asset(
                            "assets/icons/logo.svg",
                            colorFilter: const ColorFilter.mode(
                                Colors.black, BlendMode.srcIn),
                          )),
              ),
            ),
          ),
        ),
        const Gap(10),
        Text(
          tag.tag,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
