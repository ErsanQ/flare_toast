import 'package:flare_toast/flare_toast.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

// ─────────────────────────────────────────────────────────────────────────────
// App root
// ─────────────────────────────────────────────────────────────────────────────

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlareToast Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      // FlareToastWrapper must sit below MaterialApp so that Directionality,
      // MediaQuery and Overlay infrastructure are already in the tree.
      builder: (context, child) => FlareToastWrapper(child: child!),
      home: const DemoPage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Demo page
// ─────────────────────────────────────────────────────────────────────────────

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  // Controller for the persistent toast demo.
  FlareToastController? _persistentController;
  bool _persistentActive = false;

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _showSuccess() {
    FlareToast.show(
      context,
      message: 'Action completed successfully!',
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Color(0xFF34C759),
        size: 20,
      ),
    );
  }

  void _showError() {
    FlareToast.show(
      context,
      message: 'Something went wrong. Please retry.',
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Color(0xFFFF453A),
        size: 20,
      ),
      backgroundColor: const Color(0xFF2C2C2E),
      duration: const Duration(seconds: 3),
    );
  }

  void _showWarning() {
    FlareToast.show(
      context,
      message: 'Your session expires in 5 minutes.',
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: Color(0xFFFF9F0A),
        size: 20,
      ),
      backgroundColor: const Color(0xFF2C1F00),
      textColor: const Color(0xFFFFD60A),
      borderRadius: 16,
    );
  }

  void _showInfo() {
    FlareToast.show(
      context,
      message: 'FlareToast v1.0.0 is now available.',
      icon: const Icon(
        Icons.info_outline_rounded,
        color: Color(0xFF6C63FF),
        size: 20,
      ),
      backgroundColor: const Color(0xFF1A1A2E),
      textColor: Colors.white,
      duration: const Duration(seconds: 3),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 13.5,
        letterSpacing: 0.1,
      ),
    );
  }

  void _showCustom() {
    FlareToast.show(
      context,
      message: '🔥 Welcome to the Flare ecosystem!',
      backgroundColor: const Color(0xFF6C63FF),
      textColor: Colors.white,
      borderRadius: 18,
      animationDuration: const Duration(milliseconds: 800),
      duration: const Duration(seconds: 3),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        letterSpacing: 0.3,
      ),
    );
  }

  void _togglePersistent() {
    if (_persistentActive) {
      _persistentController?.dismiss();
      setState(() {
        _persistentActive = false;
        _persistentController = null;
      });
    } else {
      final ctrl = FlareToastController();
      setState(() {
        _persistentController = ctrl;
        _persistentActive = true;
      });
      FlareToast.showWithController(
        context,
        message: 'Uploading… tap dismiss to hide.',
        icon: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        controller: ctrl,
        duration: Duration.zero, // will not auto-dismiss
        backgroundColor: const Color(0xFF1C1C1E),
      );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SectionLabel(label: 'Preset Styles'),
                const SizedBox(height: 16),
                _ToastButton(
                  id: 'btn_success',
                  label: 'Success Toast',
                  subtitle: 'Green icon · 2 s duration',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A6335), Color(0xFF34C759)],
                  ),
                  icon: Icons.check_circle_rounded,
                  iconColor: const Color(0xFF34C759),
                  onTap: _showSuccess,
                ),
                const SizedBox(height: 12),
                _ToastButton(
                  id: 'btn_error',
                  label: 'Error Toast',
                  subtitle: 'Red icon · 3 s duration',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5C1A1A), Color(0xFFFF453A)],
                  ),
                  icon: Icons.error_outline_rounded,
                  iconColor: const Color(0xFFFF453A),
                  onTap: _showError,
                ),
                const SizedBox(height: 12),
                _ToastButton(
                  id: 'btn_warning',
                  label: 'Warning Toast',
                  subtitle: 'Custom bg · amber text',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5C3A00), Color(0xFFFF9F0A)],
                  ),
                  icon: Icons.warning_amber_rounded,
                  iconColor: const Color(0xFFFF9F0A),
                  onTap: _showWarning,
                ),
                const SizedBox(height: 12),
                _ToastButton(
                  id: 'btn_info',
                  label: 'Info Toast',
                  subtitle: 'Custom text style · 3 s',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A1A2E), Color(0xFF6C63FF)],
                  ),
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFF6C63FF),
                  onTap: _showInfo,
                ),
                const SizedBox(height: 32),
                const _SectionLabel(label: 'Advanced'),
                const SizedBox(height: 16),
                _ToastButton(
                  id: 'btn_custom',
                  label: 'Custom Flare Toast',
                  subtitle: 'Purple bg · slower spring animation',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A0F8C), Color(0xFF6C63FF)],
                  ),
                  icon: Icons.auto_awesome_rounded,
                  iconColor: Colors.white,
                  onTap: _showCustom,
                ),
                const SizedBox(height: 12),
                _PersistentButton(
                  id: 'btn_persistent',
                  active: _persistentActive,
                  onTap: _togglePersistent,
                ),
                const SizedBox(height: 40),
                const _FeatureChipRow(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFF0A0A0F),
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        title: const Text(
          'FlareToast',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF1A0A3E), Color(0xFF0A0A0F)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFFBB86FC)],
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.notifications_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Dynamic Island-style toasts',
                  style: TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 13,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF8E8E93),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _ToastButton extends StatelessWidget {
  const _ToastButton({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String id;
  final String label;
  final String subtitle;
  final Gradient gradient;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2C2C2E)),
        ),
        child: Material(
          key: Key(id),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: iconColor.withValues(alpha: 0.08),
            highlightColor: iconColor.withValues(alpha: 0.04),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF48484A),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PersistentButton extends StatelessWidget {
  const _PersistentButton({
    required this.id,
    required this.active,
    required this.onTap,
  });

  final String id;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF2A2A35)
              : const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active
                ? const Color(0xFF6C63FF)
                : const Color(0xFF2C2C2E),
          ),
        ),
        child: Material(
          key: Key(id),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFF6C63FF)
                          : const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      active
                          ? Icons.stop_circle_outlined
                          : Icons.timelapse_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          active ? 'Dismiss Persistent Toast' : 'Persistent Toast',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          active
                              ? 'Tap to dismiss via controller'
                              : 'duration: zero · manual dismiss',
                          style: const TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      active
                          ? Icons.radio_button_checked_rounded
                          : Icons.chevron_right_rounded,
                      key: ValueKey(active),
                      color: active
                          ? const Color(0xFF6C63FF)
                          : const Color(0xFF48484A),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureChipRow extends StatelessWidget {
  const _FeatureChipRow();

  final _features = const [
    ('🌊', 'Elastic Spring'),
    ('💨', 'Smooth Fade'),
    ('🏝', 'Dynamic Island'),
    ('🎨', 'Fully Custom'),
    ('🔌', 'Zero Deps'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _features
          .map(
            (f) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: const Color(0xFF2C2C2E)),
              ),
              child: Text(
                '${f.$1} ${f.$2}',
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
