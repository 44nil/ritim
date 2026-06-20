import 'package:flutter/material.dart';

/// Ritim uygulamasının standart AppBar'ı.
/// Özelleştirilebilir başlık, opsiyonel geri butonu ve aksiyon alanı.
class RitimAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RitimAppBar({
    super.key,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.bottom,
  });

  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      automaticallyImplyLeading: showBackButton,
      actions: actions,
      bottom: bottom,
    );
  }
}
