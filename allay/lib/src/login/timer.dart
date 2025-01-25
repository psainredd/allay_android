import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../widgets/colors.dart';
import '../widgets/text_widgets.dart';

String _durationString(int durationInSec) {
  var minutes = ((durationInSec / 60) % 60).floor().toString().padLeft(2, '0');
  var seconds = (durationInSec % 60).floor().toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class TimerWidget extends StatefulWidget {
  final int durationInSeconds;
  const TimerWidget(this.durationInSeconds, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late  Stream stream;

  @override
  void initState() {
    var init = widget.durationInSeconds;
    stream = Stream.periodic(const Duration(seconds: 1), (t) => init--).
                      take(init).
                      map((val) => _durationString(val));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return TextButton(
            onPressed: () {},
            child: const LabelSmall12('Resend OTP', color: primaryBlue),
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
        }
        if(snapshot.hasError) {
          return const Text("");
        }
        return LabelWithSuffix("Resend OTP in ", suffix: snapshot.data?.toString()??"");
      },
    );
  }
}