import 'package:allay/src/util/error.dart';
import 'package:allay/src/util/geo_location.dart';
import 'package:allay/src/util/network.dart';
import 'package:allay/src/util/specialities.dart';
import 'package:allay/src/widgets/allay_search_delegate.dart';
import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

const currentLocationLabel = "Current Location";

class Location extends ConsumerStatefulWidget {
  final Color? color;
  const Location({Key? key, this.color}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationState();
}

class _LocationState extends ConsumerState<Location> {
  late final Color? color;
  Icon _locationIcon() => Icon(Icons.location_on, color: color??subTextColor, size: 18.0,);
  Widget _getLocationLabel(label) => LabelSmall(label, color: color??subTextColor);

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  void _onPressed() async {
    ref.read(availableLocationsProvider.future).
      then((locations) {
        var suggestions = List<SearchItem>.from(locations)..insert(0,
            const SearchItem(label: currentLocationLabel, icon: Icon(Icons.my_location)));
        showSearch(
          context: context,
          delegate: LocationSearchDelegate(
            context: context,
            suggestions: suggestions,
            ref: ref
          )
        );
      }).onError((error, stackTrace) {
        showErrorSnackBar("Unable to fetch locations", context);
        showSearch(
          context: context,
          delegate: LocationSearchDelegate(
            context: context,
            suggestions: [],
            ref: ref
          )
        );
      });
  }

  Widget _getLocationWidget(label) =>
      TextButton.icon(
        onPressed: _onPressed,
        icon: _locationIcon(),
        label: _getLocationLabel(label)
      );

  @override
  Widget build(BuildContext context) {
    AsyncValue<String> currentLocation = ref.watch(selectedLocationProvider);
    return currentLocation.when(
      data: (label) => _getLocationWidget(label),
      error: (error, _) {
        showErrorSnackBar('Unable to locate you', context);
        return _getLocationWidget('Bangalore, Karnataka');
      },
      loading: () {
        return _getLocationLabel('Locating you...');
      }
    );
  }
}

class LocationWidget extends PreferredSize {
  const LocationWidget({Key? key, Widget? child, required Size preferredSize}) :
        super(key: key, child: child??const Location(), preferredSize: preferredSize);
}

class LocationSearchDelegate extends AllaySearchDelegate {
  final WidgetRef ref;
  LocationSearchDelegate({
    required BuildContext context,
    required List<SearchItem> suggestions,
    required this.ref
  }) :
        super(
          context: context,
          suggestions: suggestions,
          searchLabel: "Enter location...");

  @override
  Widget getListItemWidget(SearchItem item) {
    return GestureDetector(
      onTap: () => onSearchItemPressed(item),
      child: LabelIcon(
        item.label,
        item.icon?.icon??Icons.location_on,
        iconSize: 18,
        spacing: 4,
        color: secondaryTextColor,
      ),
    );
  }

  @override
  void onSearchItemPressed(SearchItem item) async {
    String label;
    if (item.label == currentLocationLabel) {
      label = await ref.read(geoLocationProvider.future);
    } else {
      label = item.label;
    }
    ref.read(selectedLocationProvider.notifier).state = AsyncValue.data(label);
    Navigator.of(context).pop();
  }

  @override
  Widget getSearchResults(SearchItem queryItem) {
    bool isEnteredLocationAvailable = suggestions.any(
      (e) => e.label.toLowerCase().startsWith(query.toLowerCase()) ||
        (e.tags??[]).any((tag) => tag.toLowerCase().startsWith(query.toLowerCase()))
    );
    if (isEnteredLocationAvailable) {
      return getListItemWidget(queryItem);
    }
    return LabelSmall12(
        "We are not currently available in '" + queryItem.label + "'",
        color: subTextColor
    );
  }
}