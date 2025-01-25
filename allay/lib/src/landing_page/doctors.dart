import 'package:allay/src/widgets/feedback.dart';
import 'package:allay/src/widgets/allay_containers.dart';
import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Doctors extends StatelessWidget {
  const Doctors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePageSection(
      SectionContainer(label: 'Our Doctors', child: DoctorsCarousel())
    );
  }
}

class DoctorsCarousel extends StatelessWidget {
  const DoctorsCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        _DoctorsWidget(),
        _DoctorsWidget(),
        _DoctorsWidget(),
        _DoctorsWidget(),
      ],
      options: CarouselOptions(
        autoPlay: false,
        aspectRatio: 1.6,
        viewportFraction: 0.95
      ),
    );
  }
}

class _DoctorsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              DocProfile(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Divider(color: subTextColor, height: 0.1, indent: 0.3, thickness: 0.1,),
              ),
              DocBookingDetails(),
              ActionButtons()
            ],
          ),
        ),
      ),
    );
  }
}

class DocProfile extends StatelessWidget {
  const DocProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row (
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: const [
        DocProfilePic(),
        Flexible(child: DocDetails()),
      ],
    );
  }
  
}

class DocProfilePic extends StatelessWidget {
  const DocProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0,0,16,0),
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration (
        borderRadius: BorderRadius.circular(10.0),
        image: const DecorationImage (
          image: NetworkImage('https://szcdn.ragalahari.com/mar2022/hd/pragya-jaiswal-akhanda-kruthagnatha-sabha/pragya-jaiswal-akhanda-kruthagnatha-sabhathumb.jpg'),
          fit: BoxFit.cover,
        )
      ),
    );
  }
}

class DocDetails extends StatelessWidget {
  const DocDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Label('Dr.Pragya Jaiswal'),
                LabelSmall('Neurologist', color: secondaryBlue),
                AllayFeedback(rating: 3.89, feedbackCount: 18),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
            child: LabelIconSmall12('Hyderabad', Icons.location_on, color: subTextColor,),
          ),
        ],
      ),
    );
  }
}

class DocBookingDetails extends StatelessWidget {
  const DocBookingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row (
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Icon(Icons.payments, size: 16, color: subTextColor),
            ),
            LabelWithPrefix('800', prefix: '\u{20B9}', color: subTextColor)
          ],
        ),
        const LabelWithPrefix('2.5 yrs', prefix: 'Exp: ', color: subTextColor),
        const LabelIconSmall12('10:00AM-5:00PM', Icons.access_time_filled, color: subTextColor,),
      ],
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const LabelSmall('View Profile', color: secondaryBlue),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(color: secondaryBlue)
              ),
              elevation: 0,
              primary: Colors.white
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const LabelSmall('Book Appointment', color: Colors.white),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            primary: secondaryBlue,
            elevation: 0,
          ),
        )
      ],
    );
  }
}