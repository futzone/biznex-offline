import 'dart:async';
import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/core/release/auto_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // onPointerHover va PointerEnterEvent uchun kerak
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityWrapper extends StatefulWidget {
  final Widget child;

  const ActivityWrapper({super.key, required this.child});

  @override
  State<ActivityWrapper> createState() => _ActivityWrapperState();
}

class _ActivityWrapperState extends State<ActivityWrapper> {
  Timer? _inactivityTimer;
  late final FocusNode _focusNode;
  final Duration _inactivityTimeout = const Duration(seconds: 3000);
  final ValueNotifier<AppUpdate> updateNotifier = ValueNotifier(AppUpdate(text: AppLocales.chekingForUpdates.tr()));

  OverlayEntry? _logoOverlayEntry;

  void _resetInactivityTimer() {
    _hideInactivityOverlay();

    if (_inactivityTimer?.isActive ?? false) {
      _inactivityTimer!.cancel();
    }
    _inactivityTimer = Timer(_inactivityTimeout, () {
      if (mounted) {
        _showInactivityOverlay();
      }
    });
  }

  void _showInactivityOverlay() {
    if (_logoOverlayEntry != null) return;

    _logoOverlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _resetInactivityTimer(),
          onPanDown: (_) => _resetInactivityTimer(),
          onTapDown: (_) => _resetInactivityTimer(),
          child: SvgPicture.asset(
            'assets/icons/biznex-logo.svg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    if (mounted) {
      Overlay.of(context).insert(_logoOverlayEntry!);
    }
  }

  void _hideInactivityOverlay() {
    _logoOverlayEntry?.remove();
    _logoOverlayEntry = null;
  }

  void _onUserInteraction(PointerEvent event) {
    _resetInactivityTimer();
  }

  void _onKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      _resetInactivityTimer();
    }
  }

  void _onMouseEnter(PointerEnterEvent event) {
    _resetInactivityTimer();
  }

  void _autoUpdateCall() async => await checkAndUpdate(updateNotifier);

  @override
  void initState() {
    super.initState();
    _autoUpdateCall();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
        _resetInactivityTimer();
      }
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _hideInactivityOverlay();
    _focusNode.dispose();
    super.dispose();
  }

  final theme = AppColors(isDark: false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: updateNotifier,
      builder: (context, AppUpdate value, child) {
        if (value.haveUpdate) {
          return Scaffold(
            body: Center(
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.text.tr(),
                    style: TextStyle(
                      fontSize: context.s(40),
                      fontFamily: boldFamily,
                    ),
                  ),

                  if (value.step != AppUpdate.updatingStep)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: LinearProgressIndicator(
                        color: theme.mainColor,
                        backgroundColor: theme.white,
                        minHeight: 8,
                      ),
                    ),
                  // if(value.step == AppUpdate.updatingStep)

                  if (value.step == AppUpdate.updatingStep)
                    SizedBox(
                      width: context.s(100),
                      height: context.s(100),
                      child: CircularProgressIndicator(
                        color: theme.mainColor,
                        backgroundColor: theme.white,
                        strokeWidth: 8,
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        return RawKeyboardListener(
          focusNode: _focusNode,
          onKey: _onKeyEvent,
          autofocus: true,
          child: MouseRegion(
            onEnter: _onMouseEnter,
            child: Listener(
              onPointerDown: _onUserInteraction,
              onPointerMove: _onUserInteraction,
              onPointerHover: _onUserInteraction,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
