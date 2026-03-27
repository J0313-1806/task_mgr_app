import 'package:flutter/material.dart';

class FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  const FilterHeaderDelegate();

  static final Map<String, Color> buttonDetails = {
    'All': Colors.blue,
    'Completed': Colors.green,
    'Pending': Colors.orange,
    'Blocked': Colors.redAccent,
  };

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.grey.shade200,
      child: ListView.builder(
        // padding: const EdgeInsets.all( 8.0),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: buttonDetails.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
          child: filterButton(
            onPressed: () {},
            bgColor: buttonDetails.values.toList()[index],
            buttonName: buttonDetails.keys.toList()[index],
          ),
        ),
      ),
    );
  }

  ElevatedButton filterButton({
    required VoidCallback? onPressed,
    required Color? bgColor,
    required String buttonName,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: bgColor),
      child: Text(buttonName, style: TextStyle(color: Colors.white)),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50.0;

  @override
  // TODO: implement minExtent
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
