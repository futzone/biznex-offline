import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityWrapper extends StatefulWidget {
  final Widget child;

  const ActivityWrapper({super.key, required this.child});

  @override
  State<ActivityWrapper> createState() => _InactivityWrapperState();
}

class _InactivityWrapperState extends State<ActivityWrapper> {
  bool _showLogo = false;
  Timer? _inactivityTimer;
  late final FocusNode _focusNode;

  void _resetTimer() {
    _inactivityTimer?.cancel();
    setState(() => _showLogo = false);
    _inactivityTimer = Timer(const Duration(seconds: 30), () {
      setState(() => _showLogo = true);
    });
  }

  void _onUserInteraction() {
    _resetTimer();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
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
      onKey: (_) => _onUserInteraction(),
      child: Listener(
        onPointerDown: (_) => _onUserInteraction(),
        child: Stack(
          children: [
            widget.child,
            if (_showLogo)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _onUserInteraction,
                  onPanDown: (_) => _onUserInteraction(),
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
