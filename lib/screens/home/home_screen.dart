import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/trip.dart';
import '../../shared/widgets/trip_card.dart';
import '../../shared/widgets/driver_trip_card.dart';
import '../../utils/constants.dart';
import 'widgets/home_header.dart';
import 'widgets/user_type_toggle.dart';
import 'widgets/passenger_search_section.dart';
import 'widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isPassenger = true;

  // Datos de ejemplo
  late List<Trip> _passengerTrips;
  late List<Trip> _driverTrips;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _passengerTrips = [
      Trip(
        id: '1',
        driverId: 'driver1',
        driverName: 'María González',
        driverRating: 4.8,
        driverImage: AppConstants.defaultAvatarUrl,
        vehicleInfo: 'Toyota Corolla 2020',
        origin: 'Universidad Central',
        destination: 'Centro Comercial Plaza',
        departureTime: '14:30',
        departureDate: '15 Ene',
        availableSeats: 3,
        price: 3500,
        offers: 0,
      ),
    ];

    _driverTrips = [
      Trip(
        id: '1',
        driverId: 'driver1',
        driverName: 'María González',
        driverRating: 4.8,
        driverImage: AppConstants.defaultAvatarUrl,
        vehicleInfo: 'Toyota Corolla 2020',
        origin: 'Universidad Central',
        destination: 'Centro Comercial Plaza',
        departureTime: '14:30',
        departureDate: '15 Ene',
        availableSeats: 3,
        price: 3500,
        offers: 2,
      ),
      Trip(
        id: '2',
        driverId: 'driver2',
        driverName: 'Carlos Rodríguez',
        driverRating: 4.9,
        driverImage: AppConstants.defaultAvatarUrl,
        vehicleInfo: 'Chevrolet Spark 2019',
        origin: 'Universidad Central',
        destination: 'Centro Comercial Plaza',
        departureTime: '14:30',
        departureDate: '15 Ene',
        availableSeats: 3,
        price: 3500,
        offers: 2,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textDark),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          AppConstants.appName,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppConstants.paddingM),
            child: GestureDetector(
              onTap: () {
                // TODO: Navegar a perfil
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage:
                    NetworkImage(AppConstants.defaultAvatarUrl),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const Center(
          child: Text('Buscar', style: TextStyle(fontSize: 24)),
        );
      case 2:
        return const Center(
          child: Text('Viajes', style: TextStyle(fontSize: 24)),
        );
      case 3:
        return const Center(
          child: Text('Billetera', style: TextStyle(fontSize: 24)),
        );
      case 4:
        return const Center(
          child: Text('Configuración', style: TextStyle(fontSize: 24)),
        );
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeader(isPassenger: _isPassenger),
          const SizedBox(height: AppConstants.paddingM),
          UserTypeToggle(
            isPassenger: _isPassenger,
            onToggle: (isPassenger) {
              setState(() => _isPassenger = isPassenger);
            },
          ),
          const SizedBox(height: AppConstants.paddingL),
          if (_isPassenger) _buildPassengerContent() else _buildDriverContent(),
        ],
      ),
    );
  }

  Widget _buildPassengerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PassengerSearchSection(),
        const SizedBox(height: AppConstants.paddingL),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
          child: Text(
            'Viajes disponibles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _passengerTrips.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppConstants.paddingM),
          itemBuilder: (context, index) {
            final trip = _passengerTrips[index];
            return TripCard(
              driverName: trip.driverName,
              driverRating: trip.driverRating,
              vehicleInfo: trip.vehicleInfo,
              origin: trip.origin,
              destination: trip.destination,
              departureTime: trip.departureTime,
              departureDate: trip.departureDate,
              availableSeats: trip.availableSeats,
              driverImage: trip.driverImage,
              onTap: () {
                // TODO: Navegar a detalle del viaje
              },
            );
          },
        ),
        const SizedBox(height: AppConstants.paddingXL),
      ],
    );
  }

  Widget _buildDriverContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Navegar a crear ruta
              },
              icon: const Icon(Icons.add, size: 22),
              label: const Text(
                'Publicar nueva ruta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.paddingL),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
          child: Text(
            'Mis rutas activas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _driverTrips.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppConstants.paddingM),
          itemBuilder: (context, index) {
            final trip = _driverTrips[index];
            return DriverTripCard(
              driverName: trip.driverName,
              driverRating: trip.driverRating,
              vehicleInfo: trip.vehicleInfo,
              origin: trip.origin,
              destination: trip.destination,
              departureTime: trip.departureTime,
              departureDate: trip.departureDate,
              availableSeats: trip.availableSeats,
              price: trip.price,
              offers: trip.offers,
              driverImage: trip.driverImage,
              onManageTap: () {
                // TODO: Gestionar ruta
              },
              onCardTap: () {
                // TODO: Ver detalles de la ruta
              },
            );
          },
        ),
        const SizedBox(height: AppConstants.paddingXL),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
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
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF95A5A6),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Viajes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Billetera',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración'),
        ],
      ),
    );
  }
}
