import 'package:cross_scroll/cross_scroll.dart';
import 'package:cross_scroll/src/Infinite/CrossScrollBar/cross_scroll_bar.dart';
import 'package:flutter/material.dart';

class CrossScrollThumb extends StatefulWidget {
  const CrossScrollThumb(
      {required this.axis,
      this.thumb = const CrossScrollTrack(),
      this.position,
      required this.onDrag,
      required this.thumbLength,
      this.dimColor,
      this.normalColor,
      this.hoverColor,
      required this.appearance,
      super.key});
  final CrossScrollTrack? thumb;
  final Axis axis;
  final double? position;
  final double thumbLength;
  final Color? normalColor;
  final Color? hoverColor;
  final Color? dimColor;
  final TrackAppearance appearance;
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

  _toggle(bool enter) {
    setState(() {
      _isHorizontal
          ? _onHoverHorizontalTrack = enter
          : _onHoverVerticalTrack = enter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _isHorizontal
          ? (widget.appearance == TrackAppearance.TOP_RIGHT ||
                  widget.appearance == TrackAppearance.TOP_LEFT)
              ? 1
              : null
          : widget.position,
      bottom: _isHorizontal
          ? (widget.appearance == TrackAppearance.BOTTOM_LEFT ||
                  widget.appearance == TrackAppearance.BOTTOM_RIGHT)
              ? 1
              : null
          : (widget.appearance == TrackAppearance.BOTTOM_LEFT ||
                  widget.appearance == TrackAppearance.BOTTOM_LEFT)
              ? 1
              : null,
      left: !_isHorizontal
          ? (widget.appearance == TrackAppearance.BOTTOM_LEFT ||
                  widget.appearance == TrackAppearance.TOP_LEFT)
              ? 1
              : null
          : widget.position,
      right: !_isHorizontal
          ? (widget.appearance == TrackAppearance.BOTTOM_RIGHT ||
                  widget.appearance == TrackAppearance.TOP_RIGHT)
              ? 1
              : null
          : null,
      child: SizedBox(
          height: _isHorizontal
              ? _thumbThickness()
              : widget.thumbLength < 55
                  ? 55
                  : widget.thumbLength,
          width: _isHorizontal
              ? widget.thumbLength < 55
                  ? 55
                  : widget.thumbLength
              : _thumbThickness(),
          child: MouseRegion(
            onEnter: (hover) => _toggle(true),
            onExit: (_) => _toggle(false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanUpdate: widget.onDrag,
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
      {required CrossScrollTrack bar,
      required bool hover,
      required Axis orientation}) {
    return BorderRadius.all(Radius.elliptical(
        bar.thumbRadius?.x ?? bar.thickness ?? 8,
        bar.thumbRadius?.y ?? bar.thickness ?? 8));
  }

  Color _thumbColor(
    BuildContext context, {
    required CrossScrollTrack bar,
    required bool hover,
    required Axis orientation,
  }) {
    ///called by Cross scroll constructor
    Color normalColor =
        widget.normalColor ?? const Color.fromARGB(228, 26, 26, 26);
    Color dimColor = widget.dimColor ?? const Color.fromARGB(159, 24, 24, 24);

    if (bar.thumb == ScrollThumb.hoverShow ||
        bar.track == ScrollTrackBehaviour.onHover) {
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
