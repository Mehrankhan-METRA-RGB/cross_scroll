import 'package:cross_scroll/cross_scroll.dart';
import 'package:flutter/material.dart';

class CrossTrack extends StatefulWidget {
  const CrossTrack(
      {required this.onTrackClick,
      required this.axis,
      this.padding = 1,
      this.color,
      this.width,
      this.height,
      this.border,
      required this.behaviour,
      required this.appearance,
      super.key});
  final void Function(TapDownDetails tapDownDetails) onTrackClick;
  final Axis axis;
  final double padding;
  final Color? color;
  final double? width;
  final double? height;
  final BoxBorder? border;
  final TrackAppearance appearance;
  final ScrollTrackBehaviour behaviour;

  @override
  State<CrossTrack> createState() => _CrossTrackState();
}

class _CrossTrackState extends State<CrossTrack> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isHorizontal = widget.axis == Axis.horizontal;

    return Positioned(
      top: (isHorizontal &&
              (widget.appearance == TrackAppearance.TOP_RIGHT ||
                  widget.appearance == TrackAppearance.TOP_LEFT))
          ? 1
          : null,
      bottom: (isHorizontal &&
              (widget.appearance == TrackAppearance.BOTTOM_RIGHT ||
                  widget.appearance == TrackAppearance.BOTTOM_LEFT))
          ? 1
          : null,
      left: (!isHorizontal &&
              (widget.appearance == TrackAppearance.BOTTOM_LEFT ||
                  widget.appearance == TrackAppearance.TOP_LEFT))
          ? 1
          : null,
      right: (!isHorizontal &&
              (widget.appearance == TrackAppearance.BOTTOM_RIGHT ||
                  widget.appearance == TrackAppearance.TOP_RIGHT))
          ? 1
          : null,
      child: GestureDetector(
        onDoubleTapDown: widget.onTrackClick,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: isHorizontal ? widget.padding : 0,
              horizontal: !isHorizontal ? widget.padding : 0),
          decoration: BoxDecoration(color: widget.color, border: widget.border),
          key: widget.key,
          width: widget.width,
          height: widget.height,
        ),
      ),
    );
  }

//   Color _trackColor(Widget child){
//     /// orientation switch
//     switch (widget.axis) {
//       case Axis.vertical:
//
//       ///track bar switch
//         switch (widget.behaviour) {
//           case ScrollTrackBehaviour.onHover:
//             return _trackWidget(
//               color: _onHoverVerticalTrack ? _trackColor : _noColor,
//               borderColor: _onHoverVerticalTrack ? _borderColor : _noColor,
//             );
//
//           case ScrollTrackBehaviour.show:
//             return _trackWidget(
//               color: _trackColor,
//               borderColor: _borderColor,
//             );
//           case ScrollTrackBehaviour.hidden:
//             return _trackWidget(
//               color: _noColor,
//               borderColor: _noColor,
//             );
//         }
//
//       case Axis.horizontal:
//         switch (bar.track) {
//           case ScrollTrackBehaviour.onHover:
//             return _trackWidget(
//               color: _onHoverHorizontalTrack ? _trackColor : _noColor,
//               borderColor: _onHoverHorizontalTrack ? _borderColor : _noColor,
//             );
//
//           case ScrollTrackBehaviour.show:
//             return _trackWidget(
//               color: _trackColor,
//               borderColor: _borderColor,
//             );
//           case ScrollTrackBehaviour.hidden:
//             return _trackWidget(
//               color: _noColor,
//               borderColor: _noColor,
//             );
//         }
//   }
// }
}
