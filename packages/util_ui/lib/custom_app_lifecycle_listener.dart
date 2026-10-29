import 'dart:ui';

import 'package:flutter/material.dart';

/// A widget that listens to the lifecycle of the app.
/// Surround the widget you want to listen to with [CustomAppLifecycleListener].
class CustomAppLifecycleListener extends StatefulWidget {
  const new({
    required this._child,
    this._onResume,
    this._onInactive,
    this._onHide,
    this._onShow,
    this._onPause,
    this._onRestart,
    this._onDetach,
    this._onExitRequested,
    this._onStateChange,
    super.key,
  });

  final Widget _child;
  final VoidCallback? _onResume;
  final VoidCallback? _onInactive;
  final VoidCallback? _onHide;
  final VoidCallback? _onShow;
  final VoidCallback? _onPause;
  final VoidCallback? _onRestart;
  final VoidCallback? _onDetach;
  final Future<AppExitResponse> Function()? _onExitRequested;
  final void Function(AppLifecycleState state)? _onStateChange;

  @override
  State<CustomAppLifecycleListener> createState() =>
      _CustomAppLifecycleListenerState();
}

class _CustomAppLifecycleListenerState
    extends State<CustomAppLifecycleListener> {
  late final AppLifecycleListener _appLifecycleListener;

  @override
  void initState() {
    _appLifecycleListener = AppLifecycleListener(
      onResume: widget._onResume,
      onInactive: widget._onInactive,
      onHide: widget._onHide,
      onShow: widget._onShow,
      onPause: widget._onPause,
      onRestart: widget._onRestart,
      onDetach: widget._onDetach,
      onExitRequested: widget._onExitRequested,
      onStateChange: widget._onStateChange,
    );
    super.initState();
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget._child;
  }
}
