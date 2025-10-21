import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isPassenger = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF2C3E50)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'CampusRide',
          style: TextStyle(
            color: Color(0xFF6366F1),
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                print('Foto de perfil tocada');
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
                ),
              ),
            ),
          ),
        ],
      ),
      body: _getSelectedScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4F46E5),
          unselectedItemColor: const Color(0xFF95A5A6),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
            BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Viajes'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Billetera'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración'),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const Center(child: Text('Buscar', style: TextStyle(fontSize: 24)));
      case 2:
        return const Center(child: Text('Viajes', style: TextStyle(fontSize: 24)));
      case 3:
        return const Center(child: Text('Billetera', style: TextStyle(fontSize: 24)));
      case 4:
        return const Center(child: Text('Configuración', style: TextStyle(fontSize: 24)));
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isPassenger) ...[
                  const Text('¡Encuentra', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                  const Text('tu viaje!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                  const SizedBox(height: 8),
                  const Text('Conecta con\nestudiantes conductores', style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D), height: 1.5)),
                ] else ...[
                  const Text('Tus rutas', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                  const Text('publicadas', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                  const SizedBox(height: 8),
                  const Text('Gestiona tus viajes\ncomo conductor', style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D), height: 1.5)),
                ],
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isPassenger = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: _isPassenger ? const Color(0xFF4F46E5) : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person, size: 18, color: _isPassenger ? Colors.white : const Color(0xFF7F8C8D)),
                              const SizedBox(width: 6),
                              Text('Pasajero', style: TextStyle(color: _isPassenger ? Colors.white : const Color(0xFF7F8C8D), fontWeight: FontWeight.w600, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isPassenger = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isPassenger ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: !_isPassenger ? Border.all(color: const Color(0xFFE0E0E0)) : null,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.directions_car, size: 18, color: !_isPassenger ? const Color(0xFF2C3E50) : const Color(0xFF7F8C8D)),
                              const SizedBox(width: 6),
                              Text('Conductor', style: TextStyle(color: !_isPassenger ? const Color(0xFF2C3E50) : const Color(0xFF7F8C8D), fontWeight: FontWeight.w600, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_isPassenger) _buildPassengerContent() else _buildDriverContent(),
        ],
      ),
    );
  }

  Widget _buildPassengerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.location_on, color: Color(0xFF2196F3), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text('Universidad Central', style: TextStyle(fontSize: 15, color: Color(0xFF2C3E50), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.location_on, color: Color(0xFF4CAF50), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text('¿A dónde vas?', style: TextStyle(fontSize: 15, color: Color(0xFFBDC3C7), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Buscar viajes disponibles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Viajes disponibles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
        ),
        const SizedBox(height: 16),
        _buildTripCard(name: 'María González', rating: '4.8', vehicle: 'Toyota Corolla 2020', origin: 'Universidad Central', destination: 'Centro Comercial Plaza', time: '14:30', date: '15 Ene', seats: '3 asientos'),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildDriverContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 22),
                  SizedBox(width: 8),
                  Text('Publicar nueva ruta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Mis rutas activas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
        ),
        const SizedBox(height: 16),
        _buildDriverTripCard(name: 'María González', rating: '4.8', vehicle: 'Toyota Corolla 2020', origin: 'Universidad Central', destination: 'Centro Comercial Plaza', time: '14:30', date: '15 Ene', seats: '3 asientos', price: '\$3.500', offers: '2 ofertas'),
        const SizedBox(height: 16),
        _buildDriverTripCard(name: 'Carlos Rodríguez', rating: '4.9', vehicle: 'Chevrolet Spark 2019', origin: 'Universidad Central', destination: 'Centro Comercial Plaza', time: '14:30', date: '15 Ene', seats: '3 asientos', price: '\$3.500', offers: '2 ofertas'),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildTripCard({required String name, required String rating, required String vehicle, required String origin, required String destination, required String time, required String date, required String seats}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 24, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100')),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Color(0xFFFFA726)),
                          const SizedBox(width: 4),
                          Text(rating, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
                          const SizedBox(width: 8),
                          Text('· $vehicle', style: const TextStyle(fontSize: 13, color: Color(0xFF7F8C8D))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF2196F3), shape: BoxShape.circle)),
                    Container(width: 2, height: 40, color: const Color(0xFFE0E0E0)),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(origin, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2C3E50))),
                      const SizedBox(height: 32),
                      Text(destination, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2C3E50))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Color(0xFF7F8C8D)),
                const SizedBox(width: 6),
                Text(time, style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D))),
                const SizedBox(width: 20),
                const Icon(Icons.calendar_today, size: 18, color: Color(0xFF7F8C8D)),
                const SizedBox(width: 6),
                Text(date, style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D))),
                const SizedBox(width: 20),
                const Icon(Icons.group, size: 18, color: Color(0xFF7F8C8D)),
                const SizedBox(width: 6),
                Text(seats, style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverTripCard({required String name, required String rating, required String vehicle, required String origin, required String destination, required String time, required String date, required String seats, required String price, required String offers}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 24, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100')),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Color(0xFFFFA726)),
                          const SizedBox(width: 4),
                          Text(rating, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
                          const SizedBox(width: 8),
                          Text('· $vehicle', style: const TextStyle(fontSize: 13, color: Color(0xFF7F8C8D))),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(20)),
                  child: Text(offers, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFF57C00))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF2196F3), shape: BoxShape.circle)),
                    Container(width: 2, height: 40, color: const Color(0xFFE0E0E0)),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(origin, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2C3E50))),
                      const SizedBox(height: 32),
                      Text(destination, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2C3E50))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Color(0xFF7F8C8D)),
                const SizedBox(width: 6),
                Text(time, style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D))),
                const SizedBox(width: 20),
                const Icon(Icons.calendar_today, size: 18, color: Color(0xFF7F8C8D)),
                const SizedBox(width: 6),
                Text(date, style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D))),
                const SizedBox(width: 20),
                const Icon(Icons.group, size: 18, color: Color(0xFF7F8C8D)),
                const SizedBox(width: 6),
                Text(seats, style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                      const TextSpan(text: ' COP', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF7F8C8D))),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Gestionar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF4F46E5), Color(0xFF6366F1)])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CircleAvatar(radius: 35, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100')),
                  SizedBox(height: 12),
                  Text('María González', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('maria.gonzalez@universidad.edu', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            ListTile(leading: const Icon(Icons.person, color: Color(0xFF2C3E50)), title: const Text('Mi perfil'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.directions_car, color: Color(0xFF2C3E50)), title: const Text('Mis viajes'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.star, color: Color(0xFF2C3E50)), title: const Text('Calificaciones'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.payment, color: Color(0xFF2C3E50)), title: const Text('Métodos de pago'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.history, color: Color(0xFF2C3E50)), title: const Text('Historial'), onTap: () => Navigator.pop(context)),
            const Divider(),
            ListTile(leading: const Icon(Icons.settings, color: Color(0xFF2C3E50)), title: const Text('Configuración'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.help, color: Color(0xFF2C3E50)), title: const Text('Ayuda y soporte'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.logout, color: Color(0xFFE74C3C)), title: const Text('Cerrar sesión', style: TextStyle(color: Color(0xFFE74C3C))), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}