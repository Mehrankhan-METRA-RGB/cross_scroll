import 'package:cross_scroll/cross_scroll.dart';
import 'package:cross_scroll/src/Interactive/controller.dart';
import 'package:flutter/material.dart';

class CrossTrack extends StatefulWidget {
  const CrossTrack(
      {super.key,
      required this.bar,
      required this.orientation,
      this.trackColor,
      this.noColor,
      this.borderColor,
      required this.controller});
  final CrossDiagnolController controller;
  final CrossScrollTrack bar;
  final Axis orientation;
  final Color? trackColor;
  final Color? noColor;
  final Color? borderColor;

  @override
  State<CrossTrack> createState() => _CrossTrackState();
}

class _CrossTrackState extends State<CrossTrack> {
  bool? isHorizontal;
  late Color _borderColor, _noColor, _trackColor;
  bool _onHoverHorizontalTrack = false;
  bool _onHoverVerticalTrack = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isHorizontal = Axis.horizontal == widget.orientation ? true : false;

    _trackColor = widget.trackColor ?? Colors.black.withOpacity(0.03);
    _noColor = widget.noColor ?? Colors.transparent;
    _borderColor = widget.borderColor ?? Colors.black.withOpacity(0.0851);
  }

  @override
  Widget build(BuildContext context) {
    /// orientation switch
    switch (widget.orientation) {
      case Axis.vertical:

        ///track bar switch
        switch (widget.bar.track) {
          case ScrollTrackBehaviour.onHover:
            return _trackWidget(
              color: _trackColor,
              borderColor: _borderColor,
            );

          case ScrollTrackBehaviour.show:
            return _trackWidget(
              color: _trackColor,
              borderColor: _borderColor,
            );
          case ScrollTrackBehaviour.hidden:
            return _trackWidget(
              color: _noColor,
              borderColor: _noColor,
            );
        }
      case Axis.horizontal:
        switch (widget.bar.track) {
          case ScrollTrackBehaviour.onHover:
            return _trackWidget(
              color: _trackColor,
              borderColor: _borderColor,
            );

          case ScrollTrackBehaviour.show:
            return _trackWidget(
              color: _trackColor,
              borderColor: _borderColor,
            );
          case ScrollTrackBehaviour.hidden:
            return _trackWidget(
              color: _noColor,
              borderColor: _noColor,
            );
        }
    }
  }

  Widget _trackWidget({
    bool isOnTapScroll = true,
    required Color color,
    required Color borderColor,
    double padding = 2,
  }) =>
      GestureDetector(
          onTapDown: (tapDown) => isOnTapScroll
              ? widget.controller
                  .onTrackClick(tapDown, orientation: widget.orientation)
              : null,
          child: MouseRegion(
            onEnter: _toggle(true),
            onExit: _toggle(false),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: isHorizontal! ? padding : 0,
                  horizontal: !isHorizontal! ? padding : 0),
              decoration: BoxDecoration(
                  color: color,
                  border: Border(
                      left: !isHorizontal!
                          ? BorderSide(width: 0.8, color: borderColor)
                          : BorderSide(width: 0, color: Colors.transparent),
                      top: isHorizontal!
                          ? BorderSide(width: 0.8, color: borderColor)
                          : BorderSide(width: 0, color: Colors.transparent))),
              // key: isHorizontal! ? _horizontalTrackKey : _verticalTrackKey,
              width: !isHorizontal!
                  ? _onHoverVerticalTrack
                      ? widget.bar.hoverThickness! + padding * 1.4
                      : widget.bar.thickness! + padding * 1.4
                  : null,
              height: isHorizontal!
                  ? _onHoverHorizontalTrack
                      ? widget.bar.hoverThickness! + padding * 1.4
                      : widget.bar.thickness! + padding * 1.4
                  : null,
            ),
          ));

  _toggle(bool enter) {
    setState(() {
      isHorizontal!
          ? _onHoverHorizontalTrack = enter
          : _onHoverVerticalTrack = enter;
    });
  }
}
