import 'package:flutter/material.dart';
import 'gradient_background.dart';

/// Shared app scaffold with mystical gradient background
class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final bool showBackButton;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.bottomNavigationBar,
    this.showBackButton = false,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: title != null || showBackButton
          ? AppBar(
              title: title != null ? Text(title!) : null,
              leading:
                  showBackButton ? const BackButton() : null,
              actions: actions,
            )
          : null,
      body: GradientBackground(
        child: SafeArea(
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
