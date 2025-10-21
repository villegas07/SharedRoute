import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: AppColors.headerGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      AppConstants.defaultAvatarUrl,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingS),
                  Text(
                    'María González',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'maria.gonzalez@universidad.edu',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerTile(
              icon: Icons.person,
              title: 'Mi perfil',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerTile(
              icon: Icons.directions_car,
              title: 'Mis viajes',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerTile(
              icon: Icons.star,
              title: 'Calificaciones',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerTile(
              icon: Icons.payment,
              title: 'Métodos de pago',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerTile(
              icon: Icons.history,
              title: 'Historial',
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            _buildDrawerTile(
              icon: Icons.settings,
              title: 'Configuración',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerTile(
              icon: Icons.help,
              title: 'Ayuda y soporte',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerTile(
              icon: Icons.logout,
              title: 'Cerrar sesión',
              onTap: () => Navigator.pop(context),
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? AppColors.error : AppColors.textDark,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? AppColors.error : AppColors.textDark,
        ),
      ),
      onTap: onTap,
    );
  }
}
