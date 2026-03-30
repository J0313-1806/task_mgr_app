import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef DragCallback = void Function(int index);
typedef DropCallback = void Function(int oldIndex, int newIndex);

class AnimatedDraggableGridView extends StatefulWidget {
  final List<Widget> children;
  final SliverGridDelegate gridDelegate;
  final DragCallback? onDrag;
  final DropCallback? onDrop;

  const AnimatedDraggableGridView({
    Key? key,
    required this.children,
    required this.gridDelegate,
    this.onDrag,
    this.onDrop,
  }) : super(key: key);

  @override
  State<AnimatedDraggableGridView> createState() =>
      _AnimatedDraggableGridViewState();
}

class _AnimatedDraggableGridViewState extends State<AnimatedDraggableGridView>
    with SingleTickerProviderStateMixin {
  late List<Widget> _items;
  int? _draggingIndex;
  final ScrollController _scrollController = ScrollController();
  Offset? _lastDragPosition;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.children);

    // Properly initialize the ticker here
    _ticker = createTicker((_) {
      if (_lastDragPosition == null) return;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;
      final local = box.globalToLocal(_lastDragPosition!);

      const edgeThreshold = 80.0;
      const scrollSpeed = 8.0;

      if (local.dy < edgeThreshold) {
        _scrollController.jumpTo(
          (_scrollController.offset - scrollSpeed).clamp(
            _scrollController.position.minScrollExtent,
            _scrollController.position.maxScrollExtent,
          ),
        );
      } else if (local.dy > box.size.height - edgeThreshold) {
        _scrollController.jumpTo(
          (_scrollController.offset + scrollSpeed).clamp(
            _scrollController.position.minScrollExtent,
            _scrollController.position.maxScrollExtent,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      controller: _scrollController,
      gridDelegate: widget.gridDelegate,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final child = _items[index];

        return LongPressDraggable<int>(
          data: index,
          feedback: Material(
            elevation: 6,
            child: SizedBox(width: 150, height: 200, child: child),
          ),
          childWhenDragging: const SizedBox.shrink(),
          onDragStarted: () {
            setState(() => _draggingIndex = index);
            widget.onDrag?.call(index);
            _ticker.start(); // safe to start now
          },
          onDragUpdate: (details) {
            _lastDragPosition = details.globalPosition;
          },
          onDragEnd: (_) {
            setState(() => _draggingIndex = null);
            _lastDragPosition = null;
            _ticker.stop();
          },
          child: DragTarget<int>(
            onWillAccept: (oldIndex) => true,
            onAccept: (oldIndex) {
              setState(() {
                final item = _items.removeAt(oldIndex);
                _items.insert(index, item);
                _draggingIndex = null;
              });
              widget.onDrop?.call(oldIndex, index);
            },
            builder: (context, candidateData, rejectedData) {
              final isTargeted = candidateData.isNotEmpty;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: isTargeted
                    ? const EdgeInsets.all(12.0)
                    : const EdgeInsets.all(4.0),
                child: AnimatedScale(
                  scale: _draggingIndex == index ? 0.9 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
