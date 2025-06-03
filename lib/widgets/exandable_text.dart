import 'package:flutter/material.dart';
import 'package:frontendtn1/widgets/small_text.dart';

import '../utils/color.dart';
import '../utils/dimensions.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;
  final int textLimit = 100; // Adjust this for the character limit

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textLimit) {
      firstHalf = widget.text.substring(0, textLimit);
      secondHalf = widget.text.substring(textLimit);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallText(
          size: Dimensions.font16,
          color: AppColors.paraColor,
          text: hiddenText
              ? "$firstHalf${secondHalf.isNotEmpty ? '...' : ''}"
              : firstHalf + secondHalf,
        ),
        if (secondHalf.isNotEmpty)
          InkWell(
            onTap: () {
              setState(() {
                hiddenText = !hiddenText;
              });
            },
            child: Row(
              children: [
                SmallText(
                  size: Dimensions.font16,

                  text: hiddenText ? "Show more" : "Show less",
                  color: AppColors.mainColor,
                ),
                Icon(
                  hiddenText
                      ? Icons.arrow_drop_down
                      : Icons.arrow_drop_up,
                  color: AppColors.mainColor,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
