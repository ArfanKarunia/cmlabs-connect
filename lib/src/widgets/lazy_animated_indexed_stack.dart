import 'package:flutter/material.dart';

/// A function that builds a widget for a custom animation transition.
///
/// [child] is the widget to be animated.
/// [isActive] is a boolean indicating if the child is the currently active one.
/// [animation] is an [Animation<double>] that can be used to drive the transition.
typedef LazyAnimatedIndexedStackTransitionBuilder = Widget Function(
  Widget child,
  bool isActive,
);

/// A widget that combines the features of with lazy loading
/// and animated transitions.
///
/// This widget displays a single child from a list of [children] at a time,
/// determined by the [index]. It preserves the state of all children that have
/// been displayed at least once.
///
/// Children are built lazily: a child is not built until its index is
/// selected for the first time.
///
/// Transitions between children are animated. The default transition is a
/// cross-fade, but a custom transition can be provided via the
///.
class LazyAnimatedIndexedStack extends StatefulWidget {
  const LazyAnimatedIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.animationBuilder,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
  });

  /// The index of the child to show.
  final int index;

  /// The list of children to display.
  final List<Widget> children;

  /// An optional builder for custom transitions.
  /// If null, a default fade transition is used.
  final LazyAnimatedIndexedStackTransitionBuilder? animationBuilder;

  /// The duration of the transition animation.
  final Duration duration;

  /// The curve to use for the transition animation.
  final Curve curve;

  /// The alignment of the children within the stack.
  final AlignmentGeometry alignment;

  /// The text direction for the stack.
  final TextDirection? textDirection;

  /// How to size the non-positioned children in the stack.
  final StackFit sizing;

  @override
  State<LazyAnimatedIndexedStack> createState() => _LazyAnimatedIndexedStackState();
}

class _LazyAnimatedIndexedStackState extends State<LazyAnimatedIndexedStack> {
  late List<bool> _activated;
  // ignore: unused_field
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.index;
    _activated = List<bool>.filled(widget.children.length, false);
    if (widget.index >= 0 && widget.index < _activated.length) {
      _activated[widget.index] = true;
    }
  }

  @override
  void didUpdateWidget(LazyAnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.children.length != oldWidget.children.length) {
      // If the children list changes, re-initialize the activation list.
      _activated = List<bool>.filled(widget.children.length, false);
      if (widget.index >= 0 && widget.index < _activated.length) {
        _activated[widget.index] = true;
      }
    } else if (widget.index != oldWidget.index) {
      // When index changes, update the previous index and activate the new one.
      _previousIndex = oldWidget.index;
      if (widget.index >= 0 && widget.index < _activated.length) {
        _activated[widget.index] = true;
      }
    }
  }

  Widget _defaultTransitionBuilder(Widget child, bool isActive) {
    return AnimatedCrossFade(
      firstChild: child,
      secondChild: const SizedBox.shrink(),
      crossFadeState: isActive ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: widget.duration,
      firstCurve: widget.curve,
      secondCurve: widget.curve,
      sizeCurve: widget.curve,
      layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(key: bottomChildKey, child: bottomChild),
            Positioned(key: topChildKey, child: topChild),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      fit: widget.sizing,
      children: List.generate(widget.children.length, (i) {
        final bool isActive = i == widget.index;
        final bool hasBeenActivated = _activated[i];

        // The Offstage widget ensures that the child is not painted and does not
        // receive hit tests when it is not the active index, but it remains in
        // the widget tree, preserving its state.
        return Offstage(
          offstage: !isActive,
          child: TickerMode(
            enabled: isActive,
            child: Builder(
              builder: (BuildContext context) {
                // We only build the real child if it has been activated.
                final child = hasBeenActivated ? widget.children[i] : const SizedBox.shrink();

                // Use the custom builder if provided, otherwise the default.
                final transitionBuilder = widget.animationBuilder ?? _defaultTransitionBuilder;

                return transitionBuilder(child, isActive);
              },
            ),
          ),
        );
      }),
    );
  }
}
