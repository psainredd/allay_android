import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Ratings extends StatefulWidget {
  final double rating;
  final bool editable;
  const Ratings({Key? key, this.rating=0, this.editable=false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  double _rating = 0;
  bool _editable = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.rating;
    _editable = widget.editable;
  }

  void _onRatingSelected(int index) {
    if (!_editable) {
      return;
    }

    if (index>=5) {
      throw Exception("Illegal argument in index - $index");
    }
    setState(() {
      _rating = index.toDouble() + 1 ;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Star> stars = [];
    for (int i=0; i<5; i++) {
      double value = i <= _rating ? _rating - i: 0;
      stars.add(Star(i, isEditable: _editable, value: value, onPressedCallback: _onRatingSelected));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: stars,
      mainAxisSize: MainAxisSize.min,
    );
  }
}

class Star extends StatelessWidget {
  final double value;
  final bool isEditable;
  final int index;
  final Function(int) onPressedCallback;
  final Color _iconColor = Colors.amber;
  final double _size = 18.0;
  static defaultOnPressed(int index) {}

  const Star(this.index, {Key? key, this.value = 0.0, this.isEditable = false,
    this.onPressedCallback = defaultOnPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector (
      child: _getIcon(),
      onTap: _onPressed,
    );
  }

  void _onPressed () {
    onPressedCallback(index);
  }

  Icon _getIcon() {
    if (value == 0) {
      return Icon(
        Icons.star_border_rounded,
        color: _iconColor,
        size: _size,
      );
    }
    if (value >= 1) {
      return Icon(
        Icons.star_rate_rounded,
        color: _iconColor,
        size: _size,
      );
    }
    return Icon(
        Icons.star_half_rounded,
        color: _iconColor,
        size: _size
    );
  }
}