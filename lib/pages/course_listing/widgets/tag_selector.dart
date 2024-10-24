import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/pages/auth/auth_page.dart';
import 'package:instudy/provider/bookmark_tag_provider.dart';
import 'package:instudy/usables/custom_btn.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:instudy/utils/feedback_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

Future chooseTag(
  BuildContext context,
  String feedID,
) async {
  await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom+10),
        child: IntrinsicHeight(
              child: TagSelector(
                feedID: feedID,
              ),
            ),
      ));
}

class TagSelector extends StatefulWidget {
  final String feedID;
  const TagSelector({super.key, required this.feedID});

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  TextEditingController _tagController = TextEditingController();
  bool isLoading = false;
  String selectedTag = "";

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => context.read<BookmarkTagProvider>().fetchTags);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkTagProvider>(
      builder: (_, ref, __) {
        return Padding(
            padding: EdgeInsets.fromLTRB(
                24.0, 0, 24.0, MediaQuery.paddingOf(context).bottom + 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close)),
                ),
                const Gap(10),
                Text(
                  "Tags",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Gap(10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _tagController,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 15),
                      margin:
                          const EdgeInsets.only(right: 0, top: 10, bottom: 10),
                      // decoration: BoxDecoration(
                      //     border: Border(
                      //         right: BorderSide(
                      //             width: 1.4, color: AppColors.dividerColor))),
                      child: SvgPicture.string(
                        """<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="black" fill-rule="evenodd" d="M2.123 12.816c.287 1.003 1.06 1.775 2.605 3.32l1.83 1.83C9.248 20.657 10.592 22 12.262 22c1.671 0 3.015-1.344 5.704-4.033c2.69-2.69 4.034-4.034 4.034-5.705c0-1.67-1.344-3.015-4.033-5.704l-1.83-1.83c-1.546-1.545-2.318-2.318-3.321-2.605c-1.003-.288-2.068-.042-4.197.45l-1.228.283c-1.792.413-2.688.62-3.302 1.233S3.27 5.6 2.856 7.391l-.284 1.228c-.491 2.13-.737 3.194-.45 4.197m8-5.545a2.017 2.017 0 1 1-2.852 2.852a2.017 2.017 0 0 1 2.852-2.852m8.928 4.78l-6.979 6.98a.75.75 0 0 1-1.06-1.061l6.978-6.98a.75.75 0 0 1 1.061 1.061" clip-rule="evenodd"/></svg>""",
                        colorFilter: ColorFilter.mode(
                            AppColors.textColorDark2, BlendMode.srcIn),
                      ),
                    ),
                    suffixIcon: InkWell(
                      onTap: () async{
                        await ref
                            .addTag(context,
                                feedID: widget.feedID, tag: _tagController.text.trim())
                            .then((value) {
                          
                          if (value) {
                            Navigator.pop(context);
                            showFeedbackSnackbar(context,
                                message: "video add to ${_tagController.text.trim()}");
                          }
                        });
                      },
                      child: Container(
                        // height: 30,
                        width: 55,
                        padding: EdgeInsets.symmetric(
                            vertical: isLoading ? 15 : 0, horizontal: 16),
                        
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor,
                            border: Border(
                                right: BorderSide(
                                    width: 1.4,
                                    color: AppColors.dividerColor))),
                        child: isLoading
                            ? ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 20),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : SvgPicture.string(
                                """<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none"><path fill="white" d="M4.565 12.407a.75.75 0 1 0-1.13.986zM7.143 16.5l-.565.493a.75.75 0 0 0 1.13 0zm8.422-8.507a.75.75 0 1 0-1.13-.986zm-5.059 3.514a.75.75 0 0 0 1.13.986zm-.834 3.236a.75.75 0 1 0-1.13-.986zm-6.237-1.35l3.143 3.6l1.13-.986l-3.143-3.6zm4.273 3.6l1.964-2.25l-1.13-.986l-1.964 2.25zm3.928-4.5l1.965-2.25l-1.13-.986l-1.965 2.25zm1.965-2.25l1.964-2.25l-1.13-.986l-1.964 2.25z"/><path stroke="white" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="m20 7.563l-4.286 4.5M11 16l.429.563l2.143-2.25"/></g></svg>""",
                              ),
                      ),
                    ),
                    hintText: "Add new tag",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(
                            fontSize: 13, color: AppColors.textColorDark2),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    border: CustomInputBorders.border,
                    focusedBorder: CustomInputBorders.focusedBorder,
                    errorBorder: CustomInputBorders.errorBorder,
                    enabledBorder: CustomInputBorders.border,
                    focusedErrorBorder: CustomInputBorders.errorBorder,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 13),
                ),
                const Gap(20),
                Skeletonizer(
                    enabled: false,
                    child: Builder(builder: (context) {
                      List<String> tags = ["Favorite", "Study", "So on"];
                      //  ref.tags.map((e) => e.tag).toList();
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(3,
                            // tags.length,
                            (index) {
                          bool selected = selectedTag == tags[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedTag = tags[index];
                              });
                            },
                            child: IntrinsicWidth(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.primaryColor
                                        : AppColors.accentColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Row(
                                  children: [
                                    SvgPicture.string(
                                      """"<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="-5 -5 24 24"><path fill="black" d="M6 6v2h2V6zm0-2h2V1a1 1 0 1 1 2 0v3h3a1 1 0 0 1 0 2h-3v2h3a1 1 0 0 1 0 2h-3v3a1 1 0 0 1-2 0v-3H6v3a1 1 0 0 1-2 0v-3H1a1 1 0 1 1 0-2h3V6H1a1 1 0 1 1 0-2h3V1a1 1 0 1 1 2 0z"/></svg>""",
                                      colorFilter: ColorFilter.mode(
                                          selected
                                              ? Colors.white
                                              : AppColors.textColorDark,
                                          BlendMode.srcIn),
                                    ),
                                    Text(
                                      tags[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontSize: 13,
                                              color: selected
                                                  ? Colors.white
                                                  : AppColors.textColorDark),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    })),
                const Gap(10),
                CustomButton(
                    isDisactivated: selectedTag.isEmpty || isLoading,
                    text: "Add to Tag",
                    onTap: () async {
                      ref
                          .addTag(context,
                              feedID: widget.feedID, tag: selectedTag)
                          .then((value) {
                        if (value) {
                          Navigator.pop(context);
                          showFeedbackSnackbar(context,
                              message: "video add to $selectedTag");
                        }
                      });
                    })
              ],
            ));
      },
    );
  }
}
