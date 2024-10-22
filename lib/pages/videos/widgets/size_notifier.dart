import 'package:flutter/material.dart';

class ChildSizeNotifier extends StatelessWidget {
  final ValueNotifier<
      ({
        Size size,
        Offset offset
      })> notifier = ValueNotifier(( size: const Size(0, 0),offset: Offset.zero));
  final Widget Function(BuildContext context, 
      ({
        Size size,
        Offset offset
      }) size, Widget? child) builder;
  final Widget? child;
  ChildSizeNotifier({super.key, required this.builder, this.child});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        RenderBox box = (context.findRenderObject() as RenderBox);
        Offset offset = box.globalToLocal(Offset.zero);
        notifier.value = (size:box.size,offset: offset);
      },
    );
    return ValueListenableBuilder<
      ({
        Size size,
        Offset offset
      })>(
      valueListenable: notifier,
      builder: builder,
      child: child,
    );
  }
}
