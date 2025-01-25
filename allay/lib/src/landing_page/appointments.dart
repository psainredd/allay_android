import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../widgets/allay_containers.dart';
import 'doctors.dart';

class Appointments extends ConsumerWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref.watch(provider)
    return const HomePageSection(
      SectionContainer(label: 'Appointments', child: DoctorAppointment())
    );
  }
}

class DoctorAppointment extends ConsumerWidget {
  const DoctorAppointment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            DocProfile(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Divider(color: subTextColor, height: 0.1, indent: 0.3, thickness: 0.1,),
            ),
            BookingDetails()
          ],
        ),
      )
    );
  }
}

class BookingDetails extends StatelessWidget {
  const BookingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM, d - hh:mm a').format(DateTime.now().add(const Duration(days: 12)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LabelIconSmall(formattedDate, Icons.access_time_filled),
        TextButton(
          onPressed: () {},
          child: const LabelSmall('Set Reminder', color: secondaryBlue),
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        )
      ],
    );
  }
}
