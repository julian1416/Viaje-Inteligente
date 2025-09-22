// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- Importa tus modelos ---
import 'package:viajes_ai/api/models/destination_model.dart';
import 'package:viajes_ai/api/models/booking_model.dart';
import 'package:viajes_ai/api/models/profile_model.dart';

// --- Importa tus servicios y otras pantallas/widgets ---
import 'package:viajes_ai/api/supabase_service.dart';
import 'package:viajes_ai/auth/auth_screen.dart';
import 'package:viajes_ai/common/constants.dart';
import 'package:viajes_ai/common/widgets/loading_shimmer.dart';
import 'package:viajes_ai/features/ai_planning/ai_planning_screen.dart';
import 'package:viajes_ai/features/destinations/destination_detail_screen.dart';
import 'package:viajes_ai/features/home/widgets/destination_card.dart';
import 'package:viajes_ai/features/home/widgets/booking_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final _supabaseClient = supabase;

  // --- Listas de datos para manejar el estado de la UI ---
  List<Destination> _allDestinations = [];
  List<Destination> _filteredDestinations = [];
  List<Booking> _userBookings = [];

  bool _isLoading = true;
  String _searchQuery = '';
  String _userDisplayName = 'Viajero';

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // Carga todos los datos necesarios para la pantalla principal
  Future<void> _loadAllData() async {
    if (mounted) setState(() => _isLoading = true);
    await Future.wait([
      _fetchUserData(),
      _fetchDestinations(),
      _fetchUserBookings(),
    ]);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _fetchUserData() async {
    final user = _supabaseClient.auth.currentUser;
    if (user != null) {
      try {
        final profile = await _supabaseService.getProfile(user.id);
        if (mounted) {
          setState(() {
            _userDisplayName = profile?.username ?? user.email ?? 'Viajero';
          });
        }
      } catch (e) {
        debugPrint('Error al cargar perfil de usuario: $e');
        if (mounted) setState(() => _userDisplayName = user.email ?? 'Viajero');
      }
    }
  }

  Future<void> _fetchDestinations() async {
    try {
      final destinations = await _supabaseService.getDestinations();
      if (mounted) {
        setState(() {
          _allDestinations = destinations;
          _filteredDestinations = destinations;
        });
      }
    } catch (e) {
      debugPrint('Error al cargar destinos: $e');
    }
  }

  Future<void> _fetchUserBookings() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user != null) {
        final bookings = await _supabaseService.getUserBookings(user.id);
        if (mounted) {
          setState(() {
            _userBookings = bookings;
          });
        }
      }
    } catch (e) {
      debugPrint('Error al cargar las reservas del usuario: $e');
    }
  }

  void _filterDestinations(String query) {
    final filtered = _allDestinations.where((destination) {
      final nameLower = destination.name.toLowerCase();
      final countryLower = destination.country.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower) || countryLower.contains(searchLower);
    }).toList();

    if (mounted) {
      setState(() {
        _searchQuery = query;
        _filteredDestinations = filtered;
      });
    }
  }

  Future<void> _signOut() async {
    await _supabaseClient.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('ViajaInteligente', style: textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: _signOut,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllData,
        color: theme.primaryColor,
        backgroundColor: theme.colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100.0),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hola,', style: textTheme.headlineMedium),
                  Text(_userDisplayName, style: textTheme.headlineMedium?.copyWith(color: theme.primaryColor)),
                  const SizedBox(height: 8),
                  Text('¿A dónde te llevará tu próxima aventura?', style: textTheme.titleLarge?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.8))),
                  const SizedBox(height: 24),
                  TextField(
                    onChanged: _filterDestinations,
                    decoration: const InputDecoration(
                      hintText: 'Busca por destino o país...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            _buildSection(
              context,
              title: 'Explorar Destinos',
              content: _isLoading
                  // --- CÓDIGO CORREGIDO ---
                  ? const LoadingShimmer(height: 280, count: 2)
                  : _buildDestinationsList(),
            ),
            _buildSection(
              context,
              title: 'Mis Próximas Aventuras',
              content: _isLoading
                  // --- CÓDIGO CORREGIDO ---
                  ? const LoadingShimmer(height: 150, count: 1)
                  : _buildMyBookingsList(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AiPlanningScreen()));
        },
        label: const Text('Planificar con IA'),
        icon: const Icon(Icons.auto_awesome),
      ),
    );
  }

  // --- Widgets Auxiliares ---

  Widget _buildSection(BuildContext context, {required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 16),
        content,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDestinationsList() {
    if (_filteredDestinations.isEmpty) {
      return _buildEmptyState('No se encontraron destinos.');
    }
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filteredDestinations.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemBuilder: (context, index) {
          final destination = _filteredDestinations[index];
          return DestinationCard(
            destination: destination,
            onTap: () async {
              final bool? bookingMade = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (context) => DestinationDetailScreen(destinationId: destination.id)),
              );
              if (bookingMade == true) {
                _fetchUserBookings();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildMyBookingsList() {
    if (_userBookings.isEmpty) {
      return _buildEmptyState('No tienes viajes planificados.');
    }
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _userBookings.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemBuilder: (context, index) {
          final booking = _userBookings[index];
          return HomeBookingCard(
            booking: booking,
            activityName: 'Actividad Reservada', // Placeholder
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      height: 150,
      alignment: Alignment.center,
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}