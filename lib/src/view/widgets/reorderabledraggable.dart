// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
// // import 'package:flutter_reorderable_grid_view/flutter_reorderable_grid_view.dart';

// /// Reusable draggable & reorderable GridView widget (updated for latest package API)
// @immutable
// class ReorderableDraggableGridView<T> extends StatefulWidget {
//   final List<T> items;
//   final Widget Function(BuildContext context, T item, int index) itemBuilder;
//   final void Function(int oldIndex, int newIndex, T movedItem) onReorder;

//   // Grid customization
//   final int crossAxisCount;
//   final double mainAxisSpacing;
//   final double crossAxisSpacing;
//   final double childAspectRatio;
//   final EdgeInsetsGeometry? padding;
//   final ScrollPhysics? physics;
//   final bool shrinkWrap;
//   final ScrollController? scrollController;

//   // Drag behavior
//   final bool enableLongPress;
//   final Duration longPressDelay;

//   const ReorderableDraggableGridView({
//     super.key,
//     required this.items,
//     required this.itemBuilder,
//     required this.onReorder,
//     this.crossAxisCount = 3,
//     this.mainAxisSpacing = 12,
//     this.crossAxisSpacing = 12,
//     this.childAspectRatio = 1.0,
//     this.padding,
//     this.physics,
//     this.shrinkWrap = false,
//     this.scrollController,
//     this.enableLongPress = true,
//     this.longPressDelay = const Duration(milliseconds: 300),
//   });

//   @override
//   State<ReorderableDraggableGridView<T>> createState() =>
//       _ReorderableDraggableGridViewState<T>();
// }

// class _ReorderableDraggableGridViewState<T>
//     extends State<ReorderableDraggableGridView<T>> {
//   late List<T> _items;

//   @override
//   void initState() {
//     super.initState();
//     _items = List.from(widget.items);
//   }

//   @override
//   void didUpdateWidget(covariant ReorderableDraggableGridView<T> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (!listEquals(oldWidget.items, widget.items)) {
//       _items = List.from(widget.items);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ReorderableBuilder.builder(
//       itemCount: _items.length,
//       enableLongPress: widget.enableLongPress,
//       longPressDelay: widget.longPressDelay,
//       enableDraggable: true,

//       // This is the key callback — it gives you the new ordered list
//       onReorder: (List<T> Function(List<T> items) reorderFunction) {
//         final oldItems = List<T>.from(_items);
//         final newItems = reorderFunction(_items);

//         // Find the moved item and its indices
//         int? oldIndex;
//         int? newIndex;
//         T? movedItem;

//         for (int i = 0; i < newItems.length; i++) {
//           if (i >= oldItems.length || !identical(oldItems[i], newItems[i])) {
//             movedItem = newItems[i];
//             oldIndex = oldItems.indexOf(movedItem!);
//             newIndex = i;
//             break;
//           }
//         }

//         if (oldIndex != null &&
//             newIndex != null &&
//             movedItem != null &&
//             oldIndex != newIndex) {
//           setState(() {
//             _items = newItems;
//           });
//           widget.onReorder(oldIndex, newIndex, movedItem);
//         }
//       },

//       // Builds each draggable item with a stable key
//       childBuilder: (int index) {
//         final item = _items[index];
//         return KeyedSubtree(
//           key: ValueKey(item), // Use item.id if your T has a unique ID
//           child: widget.itemBuilder(context, item, index),
//         );
//       },

//       // Wraps your GridView.builder
//       builder: (List<Widget> children) {
//         return GridView.builder(
//           controller: widget.scrollController,
//           physics: widget.physics,
//           shrinkWrap: widget.shrinkWrap,
//           padding: widget.padding ?? const EdgeInsets.all(16),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: widget.crossAxisCount,
//             mainAxisSpacing: widget.mainAxisSpacing,
//             crossAxisSpacing: widget.crossAxisSpacing,
//             childAspectRatio: widget.childAspectRatio,
//           ),
//           itemCount: children.length,
//           itemBuilder: (context, index) => children[index],
//         );
//       },
//     );
//   }
// }