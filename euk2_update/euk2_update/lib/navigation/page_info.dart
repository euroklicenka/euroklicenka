
import 'package:flutter/material.dart';

/// Contains all changeable page parts.
class PageInfo {
  final PreferredSizeWidget? _appBar;
  final Widget _body;

  PageInfo(this._appBar, this._body);

  PreferredSizeWidget? get appBar => _appBar;
  Widget get body => _body;
}
