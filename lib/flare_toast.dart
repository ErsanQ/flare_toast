/// {@template flare_toast}
/// # flare_toast
///
/// A premium Flutter toast notification package with fluid elastic animations,
/// Dynamic Island-inspired design, and full customization — zero dependencies.
///
/// ## Quick start
///
/// 1. Wrap your app with [FlareToastWrapper].
/// 2. Call `FlareToast.show(context, message: 'Hello!')` from anywhere.
///
/// ```dart
/// FlareToastWrapper(
///   child: MaterialApp(home: MyHomePage()),
/// )
/// ```
/// {@endtemplate}
library flare_toast;

import 'dart:async';

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Public API surface
// ─────────────────────────────────────────────────────────────────────────────

/// The position at which a [FlareToast] appears on screen.
///
/// Currently only [top] is fully implemented; [bottom] is reserved for a
/// future release.
enum FlareToastPosition {
  /// The toast appears near the top of the screen, inside the [SafeArea].
  top,

  /// The toast appears near the bottom of the screen. *(Coming in v1.1.0)*
  bottom,
}

// ─────────────────────────────────────────────────────────────────────────────
// FlareToastController
// ─────────────────────────────────────────────────────────────────────────────

/// A controller that allows programmatic dismissal of a [FlareToast].
///
/// Pass an instance to [FlareToast.showWithController] and call [dismiss]
/// whenever you want to hide the toast before its [duration] expires.
///
/// ```dart
/// final controller = FlareToastController();
/// FlareToast.showWithController(context, message: 'Loading…', controller: controller);
/// // … later …
/// controller.dismiss();
/// ```
class FlareToastController {
  _FlareToastEntryState? _state;

  /// Dismiss the currently active toast associated with this controller.
  ///
  /// If the toast has already been dismissed or was never shown, this is a
  /// no-op.
  void dismiss() => _state?._dismiss();

  void _attach(_FlareToastEntryState state) => _state = state;
  void _detach() => _state = null;
}

// ─────────────────────────────────────────────────────────────────────────────
// FlareToastWrapper
// ─────────────────────────────────────────────────────────────────────────────

/// A wrapper widget that provides the [Overlay] required by [FlareToast].
///
/// Place this widget **inside** `MaterialApp.builder` so that [Directionality]
/// and [MediaQuery] are already in the tree when the [Overlay] is created.
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => FlareToastWrapper(child: child!),
///   home: MyHomePage(),
/// )
/// ```
///
/// > **⚠️ Do not** wrap `MaterialApp` itself with `FlareToastWrapper`.
/// > The `Overlay` needs `Directionality` to be present above it, which is
/// > provided by `MaterialApp`. Using `builder` guarantees correct order.
class FlareToastWrapper extends StatelessWidget {
  /// Creates a [FlareToastWrapper].
  const FlareToastWrapper({super.key, required this.child});

  /// The widget subtree that FlareToast will overlay.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(builder: (_) => child),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FlareToast — main API
// ─────────────────────────────────────────────────────────────────────────────

/// The primary entry-point for displaying toast notifications.
///
/// Call [FlareToast.show] from any part of your widget tree to display a
/// beautiful, animated toast notification at the top of the screen.
///
/// ### Basic example
/// ```dart
/// FlareToast.show(context, message: 'Saved!');
/// ```
///
/// ### With icon and custom colors
/// ```dart
/// FlareToast.show(
///   context,
///   message: 'File deleted',
///   icon: Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
///   backgroundColor: Color(0xFF2C2C2E),
///   textColor: Colors.white,
/// );
/// ```
abstract final class FlareToast {
  /// Displays a [FlareToast] notification.
  ///
  /// The toast appears at the **top center** of the screen inside the
  /// [SafeArea] and auto-dismisses after [duration].
  ///
  /// - [context]           — A valid [BuildContext] inside the widget tree.
  /// - [message]           — The text displayed inside the toast.
  /// - [icon]              — Optional widget rendered to the left of [message].
  /// - [backgroundColor]   — Toast background. Defaults to `Color(0xFF1C1C1E)`.
  /// - [textColor]         — Message text color. Defaults to [Colors.white].
  /// - [borderRadius]      — Corner radius. `50` produces a pill shape.
  /// - [duration]          — Visible duration. Pass [Duration.zero] to disable
  ///                        auto-dismiss (use a [FlareToastController] instead).
  /// - [animationDuration] — Length of the entrance spring animation.
  /// - [textStyle]         — Fully overrides the default text style when set.
  static void show(
    BuildContext context, {
    required String message,
    Widget? icon,
    Color? backgroundColor,
    Color? textColor,
    double borderRadius = 50,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 600),
    TextStyle? textStyle,
  }) {
    _insert(
      context,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: borderRadius,
      duration: duration,
      animationDuration: animationDuration,
      textStyle: textStyle,
    );
  }

  /// Displays a [FlareToast] and attaches a [FlareToastController] for manual
  /// dismissal.
  ///
  /// All parameters are identical to [show]. Additionally:
  ///
  /// - [controller] — A [FlareToastController] whose [FlareToastController.dismiss]
  ///   method will hide the toast on demand.
  ///
  /// Pass `duration: Duration.zero` to prevent auto-dismiss and rely solely on
  /// [FlareToastController.dismiss].
  static void showWithController(
    BuildContext context, {
    required String message,
    required FlareToastController controller,
    Widget? icon,
    Color? backgroundColor,
    Color? textColor,
    double borderRadius = 50,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 600),
    TextStyle? textStyle,
  }) {
    _insert(
      context,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: borderRadius,
      duration: duration,
      animationDuration: animationDuration,
      textStyle: textStyle,
      controller: controller,
    );
  }

  /// Internal helper that creates and inserts an [OverlayEntry].
  static void _insert(
    BuildContext context, {
    required String message,
    Widget? icon,
    Color? backgroundColor,
    Color? textColor,
    double borderRadius = 50,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 600),
    TextStyle? textStyle,
    FlareToastController? controller,
  }) {
    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _FlareToastEntry(
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        textColor: textColor,
        borderRadius: borderRadius,
        duration: duration,
        animationDuration: animationDuration,
        textStyle: textStyle,
        controller: controller,
        onDismissed: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );

    overlay.insert(entry);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FlareToastEntry — internal stateful overlay widget
// ─────────────────────────────────────────────────────────────────────────────

/// Internal widget that renders a single toast and manages its animation
/// lifecycle.
class _FlareToastEntry extends StatefulWidget {
  const _FlareToastEntry({
    required this.message,
    required this.duration,
    required this.animationDuration,
    required this.borderRadius,
    required this.onDismissed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.controller,
  });

  final String message;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final Duration duration;
  final Duration animationDuration;
  final TextStyle? textStyle;
  final FlareToastController? controller;
  final VoidCallback onDismissed;

  @override
  State<_FlareToastEntry> createState() => _FlareToastEntryState();
}

class _FlareToastEntryState extends State<_FlareToastEntry>
    with SingleTickerProviderStateMixin {
  // ── Animation controllers ──────────────────────────────────────────────────

  late final AnimationController _controller;

  /// Vertical offset for the entrance slide (spring bounce).
  late final Animation<double> _slideAnimation;

  /// Opacity for the exit fade.
  late final Animation<double> _opacityAnimation;

  // ── State ──────────────────────────────────────────────────────────────────

  bool _dismissing = false;
  Timer? _autoDismissTimer;

  // ── Constants ──────────────────────────────────────────────────────────────

  static const _exitDuration = Duration(milliseconds: 350);
  static const _defaultBg = Color(0xFF1C1C1E);
  static const _verticalOffset = 16.0;

  @override
  void initState() {
    super.initState();

    widget.controller?._attach(this);

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Entrance: slides in from above with elastic bounce.
    _slideAnimation = Tween<double>(begin: -80, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const ElasticOutCurve(0.8),
      ),
    );

    // Opacity is always 1 during entrance; controlled separately during exit.
    _opacityAnimation = const AlwaysStoppedAnimation(1.0);

    _controller.forward();

    // Schedule auto-dismiss (only if duration > 0).
    if (widget.duration > Duration.zero) {
      _autoDismissTimer = Timer(widget.duration, _dismiss);
    }
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    widget.controller?._detach();
    _controller.dispose();
    super.dispose();
  }

  // ── Dismiss ────────────────────────────────────────────────────────────────

  Future<void> _dismiss() async {
    if (_dismissing || !mounted) return;
    _dismissing = true;
    _autoDismissTimer?.cancel();

    // Run a short fade-out + upward slide exit animation.
    await _controller.animateTo(
      0,
      duration: _exitDuration,
      curve: Curves.easeInOut,
    );

    if (mounted) widget.onDismissed();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top + _verticalOffset;

    final bg = widget.backgroundColor ?? _defaultBg;
    final fg = widget.textColor ?? Colors.white;

    final resolvedTextStyle = (widget.textStyle ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              height: 1.3,
            ))
        .copyWith(color: fg);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // During exit, _controller goes from its current value back to 0;
        // use the controller value itself for opacity.
        final opacity = _dismissing
            ? _controller.value.clamp(0.0, 1.0)
            : _opacityAnimation.value;

        return Positioned(
          top: topPadding + _slideAnimation.value,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: opacity,
            child: child!,
          ),
        );
      },
      child: _ToastPill(
        message: widget.message,
        icon: widget.icon,
        backgroundColor: bg,
        textStyle: resolvedTextStyle,
        borderRadius: widget.borderRadius,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ToastPill — pure visual widget
// ─────────────────────────────────────────────────────────────────────────────

/// Internal pill-shaped toast visual.
///
/// Stateless and purely driven by its parameters — makes it easy to test in
/// isolation.
class _ToastPill extends StatelessWidget {
  const _ToastPill({
    required this.message,
    required this.backgroundColor,
    required this.textStyle,
    required this.borderRadius,
    this.icon,
  });

  final String message;
  final Widget? icon;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  message,
                  style: textStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
