import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/provider/course_provider.dart';
import 'package:instudy/repo/auth_repo.dart';
import 'package:instudy/routing_page.dart';
import 'package:instudy/usables/custom_btn.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:instudy/utils/feedback_snackbar.dart';
import 'package:instudy/utils/validators.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final _semesterController = MultiSelectController<String>();
  final _coursesController = MultiSelectController<String>();
  bool showCourses = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _semesterController.addListener(() => setState(() {
            showCourses = _semesterController.selectedItems.isNotEmpty;
          }));
      context.read<CourseProvider>().fetchCourses(context: context);
    });
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() => setState(() {
          showCourses = _semesterController.selectedItems.isNotEmpty;
        }));
  }

  @override
  void dispose() {
    _semesterController.removeListener(() => setState(() {
          showCourses = _semesterController.selectedItems.isNotEmpty;
        }));
    _controller.removeListener(() => setState(() {
          showCourses = _semesterController.selectedItems.isNotEmpty;
        }));

    _semesterController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formState,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(MediaQuery.paddingOf(context).top + 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Hero(
                    tag: "logo",
                    child: SvgPicture.asset(
                      "assets/icons/logo.svg",
                      width: 50,
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    )),
                const Gap(5),
                Text(
                  "INSTUDY",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                )
              ],
            ),
            const Spacer(),
            Expanded(
              flex: 3,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.75),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Welcome",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "Welcome, Please enter your details below",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textColorDark2),
                        )
                      ],
                    ),
                    const Gap(15),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.all(2),
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: AppColors.accentColor),
                      child: TabBar(
                        controller: _controller,
                        padding: EdgeInsets.zero,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.white,
                        indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 12),
                        unselectedLabelStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                                color: AppColors.textColorDark2, fontSize: 12),
                        tabs: const [
                          Tab(text: "Sign in"),
                          Tab(text: "Signup"),
                        ],
                      ),
                    ),
                    const Gap(25),
                    Expanded(
                      child: TabBarView(controller: _controller, children: [
                        Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              validator: InputValidator.isEmail,
                              decoration: InputDecoration(
                                prefixIcon: Container(
                                  height: 30,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 15),
                                  margin: const EdgeInsets.only(
                                      right: 10, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1.4,
                                              color: AppColors.dividerColor))),
                                  child: SvgPicture.string(
                                      """<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="black" d="M22 8.608v8.142a3.25 3.25 0 0 1-3.066 3.245L18.75 20H5.25a3.25 3.25 0 0 1-3.245-3.066L2 16.75V8.608l9.652 5.056a.75.75 0 0 0 .696 0zM5.25 4h13.5a3.25 3.25 0 0 1 3.234 2.924L12 12.154l-9.984-5.23a3.25 3.25 0 0 1 3.048-2.919zh13.5z"/></svg>"""),
                                ),
                                hintText: "Email Address",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontSize: 13,
                                        color: AppColors.textColorDark2),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                border: CustomInputBorders.border,
                                focusedBorder: CustomInputBorders.focusedBorder,
                                errorBorder: CustomInputBorders.errorBorder,
                                enabledBorder: CustomInputBorders.border,
                                focusedErrorBorder:
                                    CustomInputBorders.errorBorder,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(fontSize: 13),
                            ),
                            const Gap(15),
                            CustomButton(
                              text: "Continue",
                              onTap: () async {
                                if (!_formState.currentState!.validate()) {
                                  return;
                                }
                                await AuthRepo().validateUser(
                                    email: emailController.text.trim());
                              },
                            )
                          ],
                        ),
                        Column(
                          children: [
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: InputValidator.isEmail,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: InputDecoration(
                                prefixIcon: Container(
                                  height: 30,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 15),
                                  margin: const EdgeInsets.only(
                                      right: 10, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1.4,
                                              color: AppColors.dividerColor))),
                                  child: SvgPicture.string(
                                      """<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="black" d="M22 8.608v8.142a3.25 3.25 0 0 1-3.066 3.245L18.75 20H5.25a3.25 3.25 0 0 1-3.245-3.066L2 16.75V8.608l9.652 5.056a.75.75 0 0 0 .696 0zM5.25 4h13.5a3.25 3.25 0 0 1 3.234 2.924L12 12.154l-9.984-5.23a3.25 3.25 0 0 1 3.048-2.919zh13.5z"/></svg>"""),
                                ),
                                hintText: "Email Address",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontSize: 13,
                                        color: AppColors.textColorDark2),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                border: CustomInputBorders.border,
                                focusedBorder: CustomInputBorders.focusedBorder,
                                errorBorder: CustomInputBorders.errorBorder,
                                enabledBorder: CustomInputBorders.border,
                                focusedErrorBorder:
                                    CustomInputBorders.errorBorder,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(fontSize: 13),
                            ),
                            const Gap(15),
                            MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  padding: MediaQuery.of(context)
                                      .padding
                                      .copyWith(top: 0, bottom: 0)),
                              child: MultiDropdown<String>.future(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _semesterController,
                                singleSelect: true,
                                validator: (selectedOptions) =>
                                    (selectedOptions ?? []).isEmpty
                                        ? "Choose a semester"
                                        : null,
                                future: () => context
                                    .read<CourseProvider>()
                                    .fetchCourses()
                                    .then((val) {
                                  return val.semester
                                      .map((e) =>
                                          DropdownItem(label: e, value: e))
                                      .toList();
                                }),
                                onSelectionChange: (val) {
                                  _coursesController.clearAll();
                          print(context.read<CourseProvider>()
                                      .courses
                                      .where((e) =>
                                          e.semesterType ==
                                          val.first.toLowerCase()));
                                  _coursesController.setItems(context
                                      .read<CourseProvider>()
                                      .courses
                                      .where((e) =>
                                          e.semesterType ==
                                          val.first.toLowerCase())
                                      .map((e) => DropdownItem(
                                          label: e.name, value: e.id))
                                      .toList());
                                },
                                dropdownDecoration: const DropdownDecoration(
                                    marginTop: 10,
                                    elevation: 2,
                                    maxHeight: 200),
                                fieldDecoration: FieldDecoration(
                                    border: CustomInputBorders.border,
                                    hintText: "Choose semester",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: 13,
                                            color: AppColors.textColorDark2),
                                    focusedBorder:
                                        CustomInputBorders.focusedBorder,
                                    errorBorder:
                                        CustomInputBorders.errorBorder),
                              ),
                            ),
                            const Gap(15),
                            if (showCourses) ...[
                              MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                    padding: MediaQuery.of(context)
                                        .padding
                                        .copyWith(top: 0, bottom: 0)),
                                child: MultiDropdown<String>(
                                  controller: _coursesController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (selectedOptions) =>
                                      (selectedOptions ?? []).isEmpty
                                          ? "Choose a your courses"
                                          : null,
                                  items: const [],
                                  dropdownDecoration: const DropdownDecoration(
                                      marginTop: 10,
                                      elevation: 2,
                                      maxHeight: 200),
                                  fieldDecoration: FieldDecoration(
                                      border: CustomInputBorders.border,
                                      hintText: "Select courses",
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                              fontSize: 13,
                                              color: AppColors.textColorDark2),
                                      focusedBorder:
                                          CustomInputBorders.focusedBorder,
                                      errorBorder:
                                          CustomInputBorders.errorBorder),
                                ),
                              ),
                              const Gap(15)
                            ],
                            // MultiDropdown.future(future: ),
                            CustomButton(
                              text: "Get Started",
                              onTap: () async {
                                if (!_formState.currentState!.validate()) {
                                  return;
                                }
                                await AuthRepo()
                                    .signUp(
                                        email: emailController.text.trim(),
                                        courses: _coursesController
                                            .selectedItems
                                            .map((e) => e.value)
                                            .toList())
                                    .then((e) {
                                  if (!e.status) {
                                    showFeedbackSnackbar(context,
                                        message: e.message);
                                    return;
                                  }
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      PageTransition(
                                          child: const RoutingPage(),
                                          type: PageTransitionType.leftToRight),
                                      (_) => false);
                                });
                              },
                            )
                          ],
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Stay connected to campus life with Instudy - your personalized portal to college lecture videos, transcripts, and community, empowering you to learn, grow, and thrive.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontSize: 10, color: AppColors.textColorDark2),
                )),
            Gap(MediaQuery.paddingOf(context).bottom + 20)
          ],
        ),
      ),
    );
  }
}

class CustomInputBorders {
  static InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(width: 1.3, color: AppColors.dividerColor));

  static InputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(width: 1.3, color: AppColors.textColorDark));
  static InputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(
          width: 1.3, color: const Color.fromARGB(255, 255, 57, 43)));
}
