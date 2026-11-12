import 'package:flutter/foundation.dart';

import 'package:w3_lms/core/mascot/fox_mascot.dart';

/// What Kit says and how Kit feels at a given moment. Each feature keeps its
/// own "script" function that turns its state into a FoxLine.
@immutable
class FoxLine {
  const FoxLine(this.mood, this.text);

  final FoxMood mood;
  final String text;
}
