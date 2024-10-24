import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:instudy/provider/profile_provider.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileProvider>().fetchProfile(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (_, ref, __) {
        return RefreshIndicator(
          onRefresh: ()=>ref.fetchProfile(context),
          child: ListView(
            children: [
              const Gap(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                    ),
                    const Gap(15),
                    Expanded(
                      child: Skeletonizer(
                        enabled: ref.profile ==null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ref.profile?.username?? "Sam Oyeley",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const Gap(10),
                            Text(
                              ref.profile?.email??"METALLURGICAL ENGINEERING",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: 10,
                                      color: AppColors.textColorDark2),
                            ),
                            const Gap(10),
                            Text(
                              "Year 2",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: 10,
                                      color: AppColors.textColorDark2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Personal Information",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textColorDark2)),
              ),
              const Gap(10),
              const Divider(),
              const Gap(12),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: const Color(0xffFAFAFA)),
                child: Wrap(children: [
                  _buildActions(context, text: "Name"),
                  _buildActions(context, text: "Username"),
                  _buildActions(context, text: "Profile Picture"),
                  _buildActions(context, text: "Matric Number"),
                ]),
              ),
              const Gap(34),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Registered Courses",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textColorDark2)),
              ),
              const Gap(10),
              const Divider(),
              const Gap(12),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: const Color(0xffFAFAFA)),
                child: Wrap(children: [
                  _buildActions(context, text: "MET 101"),
                  _buildActions(context, text: "GST 112"),
                ]),
              )
            ],
          ),
        );
      },
    );
  }
}

Widget _buildActions(BuildContext context,
        {required String text, Function()? onTap}) =>
    InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(fontSize: 12),
              ),
            ),
            const Icon(Icons.keyboard_arrow_right_rounded)
          ],
        ),
      ),
    );
