# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.1] - 2026-03-28

### Fixed
- Shortened `pubspec.yaml` description to meet pub.dev line length rules.
- Removed custom documentation URL to ensure pub points correctly identify documentation.
- Updated the package logo in `README.md`.

---

## [1.0.0] - 2026-03-28

### Added

- Initial release of `flare_toast` — a premium Flutter toast notification package.
- Global `FlareToast.show()` static API: call from anywhere without a `BuildContext`.
- Fluid elastic/spring physics entrance animation via `ElasticOutCurve`.
- Smooth fade-out with upward-slide exit animation.
- SafeArea-aware top-center positioning with configurable vertical offset.
- Full customization surface:
  - `message` — toast body text.
  - `icon` — optional left-aligned widget (any `Widget`).
  - `backgroundColor` — custom background color.
  - `textColor` — custom text color.
  - `borderRadius` — corner radius for the pill shape.
  - `duration` — how long the toast is visible before dismissing.
  - `animationDuration` — entrance animation length.
  - `textStyle` — full `TextStyle` override.
- `FlareToastWrapper` navigator observer / overlay host widget for zero-boilerplate setup.
- `FlareToastController` for advanced manual show / dismiss control.
- Zero third-party dependencies — pure Flutter SDK.
- Complete DartDoc API documentation.
- `flutter_lints ^3.0.0` compliance — zero analyzer warnings.
