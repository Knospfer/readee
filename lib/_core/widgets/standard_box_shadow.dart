import 'package:flutter/material.dart';

class StandardBoxShadow extends BoxShadow {
  StandardBoxShadow()
      : super(
          offset: const Offset(1, 2),
          color: Colors.black.withOpacity(0.2),
          blurRadius: 5,
        );
}
