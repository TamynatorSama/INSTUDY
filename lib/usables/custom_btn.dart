import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/utils/app_colors.dart';

class CustomButton extends StatefulWidget {
  final Function()? onTap;
  final String text;
  final String? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final bool showLoader;
  final Border? customBorder;
  final bool isDisactivated;
  final double? iconSpacing;
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.iconSpacing,
    this.customBorder,
    this.icon,
    this.showLoader = true,
    this.width,
    this.isDisactivated = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool tapped = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.isDisactivated || isLoading) return;
        FocusScope.of(context).unfocus();
        tapped = false;
        isLoading = true;
        setState(() {});

        await widget.onTap?.call();
        isLoading = false;
        setState(() {});
      },
      onTapDown: (details) {
        tapped = true;
        setState(() {});
      },
      onTapCancel: () {
        tapped = false;
        setState(() {});
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      child: AnimatedScale(
        scale: tapped ? 0.98 : 1,
        duration: const Duration(milliseconds: 300),
        child: IntrinsicWidth(
          child: Container(
            clipBehavior: Clip.hardEdge,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            height: 49,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                color: widget.isDisactivated
                    ? AppColors.textColorDark2
                    : widget.backgroundColor ?? AppColors.primaryColor),
            child: isLoading && widget.showLoader
                ? SpinKitThreeBounce(
                    size: 20,
                    itemBuilder: (context, index) => const CircleAvatar(
                      radius: 1,
                      backgroundColor: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.text,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  fontSize: 12,
                                  color: widget.textColor ?? Colors.white)),
                      if (widget.icon != null) ...[
                        Gap(widget.iconSpacing ?? 5),
                        SvgPicture.asset(
                          widget.icon!,
                          colorFilter: ColorFilter.mode(
                              widget.textColor ?? Colors.white,
                              BlendMode.srcIn),
                          width: 17,
                        )
                      ]
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
