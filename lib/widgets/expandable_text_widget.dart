import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/small_text.dart';

import '../utils/dimentions.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;
  double textHeight = Dimensions.screenHeight / 5.63;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(
        0,
        textHeight.toInt(),
      );
      secondHalf = widget.text.substring(
        textHeight.toInt() + 1,
        widget.text.length,
      );
    } else {
      firstHalf = widget.text;
      secondHalf = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? SmallText(
              text: firstHalf,
              size: Dimensions.fontSize16,
              color: AppColors.paraColor,
              height: 1.8,
            )
          : Column(
              children: [
                SmallText(
                  text: hiddenText
                      ? (firstHalf + '...')
                      : (firstHalf + secondHalf),
                  size: Dimensions.fontSize16,
                  color: AppColors.paraColor,
                  height: 1.8,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    children: [
                      SmallText(
                        text: 'Show more',
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
            ),
    );
  }
}
