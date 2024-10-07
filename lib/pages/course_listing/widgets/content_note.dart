import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/utils/app_colors.dart';


Future showContentNotes(BuildContext context) async {
  await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isDismissible: true,
      builder: (_) => const ContentOptions());
}

class ContentOptions extends StatelessWidget {
  const ContentOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24.0, 0, 24.0, MediaQuery.paddingOf(context).bottom + 20),
      child:Column(
        children: [
          const Gap(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Badge.count(
                    backgroundColor:AppColors.secondaryColor,
                    count: 1,
                    // smallSize: 25,
                    // largeSize: 22,
                    
                    // textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 10),
                    child: SvgPicture.asset("assets/icons/filled_note.svg",),),
                    const Gap(8),
                    Text("Notes",style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 14),)
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                decoration: const ShapeDecoration(shape: StadiumBorder(),color: Color(0xffE2E2E2)),
                child: Row(
                  children: [
                    const Icon(Icons.add,weight: 800,),
                    const Gap(10),
                    Text("Add Note",style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 12),)
                  ],
                ),
              )
            ],
          ),
          const Gap(24),
          const Divider(),
          const Gap(24),
          const Expanded(
            child: SingleChildScrollView(
              child: Text("""Hardness is a measure of how resistant a material is to being scratched, dented, or deformed.
           Materials like diamonds are extremely hard, making them useful for cutting tools and drills. 
          Softer materials, such as rubber, deform easily under pressure. Different tests, like the Mohs scale, measure hardness by comparing materials' ability to scratch each other. Understanding the hardness of materials helps engineers choose the right material for various applications, from construction to manufacturing"""),
            ),
          )
        ],
      )
    );
  }
}
