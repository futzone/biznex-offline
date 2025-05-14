import 'dart:async';
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

  OverlayEntry? _logoOverlayEntry;

  void _resetInactivityTimer() {
    _hideInactivityOverlay(); // Har qanday holatda overlayni yashirish

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
            'assets/icons/biznex-logo.svg', // Yo'lni tekshiring
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    // Context hali ham mavjudligini tekshirish
    if (mounted && Overlay.of(context) != null) {
      Overlay.of(context)!.insert(_logoOverlayEntry!);
    }
  }

  void _hideInactivityOverlay() {
    _logoOverlayEntry?.remove();
    _logoOverlayEntry = null;
  }

  // Foydalanuvchining har qanday pointer harakati (touch, sichqoncha siljishi va h.k.)
  void _onUserInteraction(PointerEvent event) {
    _resetInactivityTimer();
  }

  // Klaviatura bosilganda
  void _onKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      _resetInactivityTimer();
    }
  }

  // Sichqoncha widget hududiga kirganda
  void _onMouseEnter(PointerEnterEvent event) {
    // Agar logo ko'rsatilayotgan bo'lsa va sichqoncha hududga kirsa,
    // darhol logoni yashirib, taymerni qayta ishga tushiramiz.
    // _resetInactivityTimer() funksiyasi o'zi _hideInactivityOverlay() ni chaqiradi.
    _resetInactivityTimer();
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _onKeyEvent,
      autofocus: true,
      child: MouseRegion( // Sichqoncha hodisalarini tinglash uchun
        onEnter: _onMouseEnter, // Sichqoncha kirganda chaqiriladi
        // onExit: (event) {
        //   // Agar sichqoncha chiqqanda biror amal bajarish kerak bo'lsa
        //   // Masalan, agar sichqoncha hududdan chiqsa taymerni darhol ishga tushirish (lekin bu g'alati bo'lishi mumkin)
        // },
        child: Listener(
          onPointerDown: _onUserInteraction,
          onPointerMove: _onUserInteraction,
          onPointerHover: _onUserInteraction, // Sichqoncha siljishini ham hisobga oladi
          child: widget.child,
        ),
      ),
    );
  }
}