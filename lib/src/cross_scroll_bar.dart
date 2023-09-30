import 'package:flutter/material.dart';

class CrossScrollBar {
  const CrossScrollBar({
    ScrollTrack track = ScrollTrack.onHover,
    ScrollThumb thumb = ScrollThumb.alwaysDim,
    double hoverThickness = 8,
    double thickness = 8,
    Radius thumbRadius = const Radius.elliptical(8, 8),
  })  : assert(hoverThickness >= thickness),
        thumb = thumb,
        hoverThickness = hoverThickness,
        thickness = thickness,
        track = track,
        thumbRadius = thumbRadius;

  /// Controls the track visibility.
  ///
  ///Thumb color behaviour
  final ScrollThumb thumb;

  /// Controls the track visibility.
  ///
  ///Track color behaviour
  final ScrollTrack track;

  /// The thickness of the scrollbar when a hover state is active and
  /// [showTrackOnHover] is true.
  ///
  /// If this property is null, then [ScrollbarThemeData.thickness] of
  /// [ThemeData.scrollbarTheme] is used to resolve a thickness. If that is also
  /// null, the default value is 12.0 pixels.

  final double? hoverThickness;

  /// The thickness of the scrollbar in the cross axis of the scrollable.
  ///
  /// If null, the default value is platform dependent. On [TargetPlatform.android],
  /// the default thickness is 4.0 pixels. On [TargetPlatform.iOS],
  /// [CupertinoScrollbar.defaultThickness] is used. The remaining platforms have a
  /// default thickness of 8.0 pixels.
  final double? thickness;

  /// The [Radius] of the scrollbar thumb's rounded rectangle corners.
  ///
  /// If null, the default value is platform dependent. On [TargetPlatform.android],
  /// no radius is applied to the scrollbar thumb. On [TargetPlatform.iOS],
  /// [CupertinoScrollbar.defaultRadius] is used. The remaining platforms have a
  /// default [Radius.circular] of 8.0 pixels.
  final Radius? thumbRadius;
}

///[ScrollTrack.show] will keep the scroll track always visible.
///
/// [ScrollTrack.onHover] will show the track while on hover.
///
/// [ScrollTrack.hidden] will keep the scroll track hidden.
///
/// [ScrollTrack.none] no scroll track.
enum ScrollTrack { show, onHover, hidden, none }

enum ScrollThumb { hoverShow, alwaysShow, alwaysDim }
