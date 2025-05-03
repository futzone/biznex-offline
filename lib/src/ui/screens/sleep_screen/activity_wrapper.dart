import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // onPointerHover uchun kerak bo'lishi mumkin
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityWrapper extends StatefulWidget {
  final Widget child;

  const ActivityWrapper({super.key, required this.child});

  @override
  State<ActivityWrapper> createState() => _ActivityWrapperState();
}

class _ActivityWrapperState extends State<ActivityWrapper> {
  bool _showLogo = false;
  Timer? _inactivityTimer;
  late final FocusNode _focusNode;
  final Duration _inactivityTimeout = const Duration(seconds: 30);

  void _resetTimer() {
    if (_inactivityTimer?.isActive ?? false) {
      _inactivityTimer!.cancel();
    }
    if (_showLogo) {
      setState(() => _showLogo = false);
    }
    _inactivityTimer = Timer(_inactivityTimeout, () {
      if (mounted) {
        setState(() => _showLogo = true);
      }
    });
  }

  void _onUserInteraction(PointerEvent event) {
    _resetTimer();
  }

  void _onKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      _resetTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
    _resetTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _onKeyEvent,
      autofocus: true,
      child: Listener(
        onPointerDown: _onUserInteraction,
        onPointerMove: _onUserInteraction,
        onPointerHover: _onUserInteraction,
        child: Stack(
          children: [
            widget.child,
            if (_showLogo)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _resetTimer(),
                  onPanDown: (_) => _resetTimer(),
                  onTapDown: (_) => _resetTimer(),
                  child: SvgPicture.asset(
                    'assets/icons/biznex-logo.svg',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
