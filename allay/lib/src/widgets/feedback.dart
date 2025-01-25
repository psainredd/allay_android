import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/ratings.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';

class AllayFeedback extends StatelessWidget {
  final double rating;
  final int feedbackCount;

  const AllayFeedback({Key? key, required this.rating, required this.feedbackCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Ratings(rating: rating, editable: false),
        LabelSmall12('($feedbackCount)', color: subTextColor,)
      ],
    );
  }

}