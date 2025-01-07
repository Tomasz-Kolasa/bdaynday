// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart' as native;
import 'package:flutter/material.dart';
import 'package:urodziny_imieniny/services/menu_item_handlers/app_theme_handler.dart';
import 'package:urodziny_imieniny/views/common_widgets/app_view_widget.dart';
import 'package:urodziny_imieniny/views/nav_bar_views/menu_widgets/menu_item.dart';
import 'package:urodziny_imieniny/services/menu_item_handlers/backup_handler.dart';

class MenuWidget extends StatelessWidget implements AppViewWidget{
  const MenuWidget({
    super.key,
  });

  @override
  final String title = 'menu';

  @override
  IconData get icon => Icons.menu;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          MenuItem(
            icon: Icons.install_mobile,
            text: 'utwórz kopię zapasową',
            handler: BackupHandler.write(context),
            ),

          MenuItem(
            icon: Icons.settings_backup_restore,
            text: 'wczytaj kopię zapasową',
            handler: BackupHandler.read(context),
            ),

          MenuItem(
            icon: Icons.palette,
            text: 'motyw aplikacji',
            handler: AppThemeHandler(context),
            ),
          
        ],
      ),
    );
  }
}

