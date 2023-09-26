import 'package:cross_scroll/cross_scroll.dart';
import 'package:flutter/material.dart';

class CrossScrollThumb extends StatefulWidget {
  const CrossScrollThumb(
      {required this.axis,
      this.thumb,
      this.verticalThumbCurrentPosition,
      this.horizontalThumbCurrentPosition,
      required this.hThumbWidth,
      required this.onDrag,
      required this.vThumbWidth,
      this.dimColor,
      this.normalColor,
      this.hoverColor,
      super.key});
  final CrossScrollBar? thumb;
  final Axis axis;
  final double? verticalThumbCurrentPosition;
  final double? horizontalThumbCurrentPosition;
  final double vThumbWidth;
  final double hThumbWidth;
  final Color? normalColor;
  final Color? hoverColor;
  final Color? dimColor;
  final void Function(DragUpdateDetails) onDrag;

  @override
  State<CrossScrollThumb> createState() => _CrossScrollThumbState();
}

class _CrossScrollThumbState extends State<CrossScrollThumb> {
  double? _thumbThickness() =>
      _trackHover ? widget.thumb!.hoverThickness : widget.thumb!.thickness;

  late bool _isHorizontal;

  late bool _trackHover;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isHorizontal = widget.axis == Axis.horizontal ? true : false;
    _trackHover =
        _isHorizontal ? _onHoverHorizontalTrack : _onHoverVerticalTrack;
  }

  @override
  Widget build(BuildContext context) {
    print("Positioned:${widget.verticalThumbCurrentPosition}");
    print("Positioned:${widget.horizontalThumbCurrentPosition}");
    return Positioned(
      top: _isHorizontal ? null : widget.verticalThumbCurrentPosition,
      bottom: _isHorizontal ? 1 : null,
      left: !_isHorizontal ? null : widget.horizontalThumbCurrentPosition,
      right: !_isHorizontal ? 1 : null,
      child: SizedBox(
          height: _isHorizontal
              ? _thumbThickness()
              : widget.vThumbWidth < 55
                  ? 55
                  : widget.vThumbWidth,
          width: !_isHorizontal
              ? _thumbThickness()
              : widget.hThumbWidth < 55
                  ? 55
                  : widget.hThumbWidth,
          child: GestureDetector(
            // onTapDown: (tip) =>fingerTip= tip.localPosition.dx,
            onPanUpdate: widget.onDrag,
            child: InkWell(
              onHover: (hover) {
                setState(() {
                  _isHorizontal
                      ? _onHoverHorizontalTrack = hover
                      : _onHoverVerticalTrack = hover;
                });
              },
              autofocus: true,
              enableFeedback: true,
              excludeFromSemantics: true,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: _thumbRadius(
                      bar: widget.thumb!,
                      hover: _isHorizontal
                          ? _onHoverHorizontalTrack
                          : _onHoverVerticalTrack,
                      orientation: widget.axis),
                  color: _thumbColor(context,
                      bar: widget.thumb!,
                      hover: _isHorizontal
                          ? _onHoverHorizontalTrack
                          : _onHoverVerticalTrack,
                      orientation: widget.axis),
                ),
              ),
            ),
          )),
    );
  }

  bool _onHoverHorizontalTrack = false;

  bool _onHoverVerticalTrack = false;

  BorderRadiusGeometry _thumbRadius(
      {required CrossScrollBar bar,
      required bool hover,
      required Axis orientation}) {
    return BorderRadius.all(Radius.elliptical(
        bar.thumbRadius?.x ?? bar.thickness ?? 8,
        bar.thumbRadius?.y ?? bar.thickness ?? 8));
  }

  Color _thumbColor(
    BuildContext context, {
    required CrossScrollBar bar,
    required bool hover,
    required Axis orientation,
  }) {
    ///called by Cross scroll constructor
    Color normalColor =
        widget.normalColor ?? const Color.fromARGB(228, 26, 26, 26);
    Color dimColor = widget.dimColor ?? const Color.fromARGB(159, 24, 24, 24);

    if (bar.thumb == ScrollThumb.hoverShow ||
        bar.track == ScrollTrack.onHover) {
      return hover ? widget.hoverColor ?? normalColor : dimColor;
    } else if (bar.thumb == ScrollThumb.alwaysDim) {
      return dimColor;
    } else if (bar.thumb == ScrollThumb.alwaysShow) {
      return normalColor;
    } else {
      return normalColor;
    }
  }
}
