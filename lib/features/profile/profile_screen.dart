// lib/features/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:viajes_ai/api/models/itinerary_model.dart';
import 'package:viajes_ai/api/models/profile_model.dart';
import 'package:viajes_ai/api/supabase_service.dart';
import 'package:viajes_ai/common/constants.dart';
import 'package:viajes_ai/common/widgets/loading_indicator.dart';
import 'package:viajes_ai/features/itineraries/itinerary_detail_screen.dart';
import 'package:viajes_ai/features/profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabaseService = SupabaseService();
  late Future<List<dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      // Usamos Future.wait para cargar perfil e itinerarios en paralelo
      _dataFuture = Future.wait([
        _supabaseService.getProfile(user.id),
        _supabaseService.getItinerariesForUser(user.id),
      ]);
    } else {
      _dataFuture = Future.error('No hay un usuario autenticado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil y Viajes'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadProfileData();
          });
        },
        child: FutureBuilder<List<dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator();
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.length < 2) {
              return const Center(child: Text('No se pudo cargar la información.'));
            }

            final profile = snapshot.data![0] as Profile;
            final itineraries = snapshot.data![1] as List<Itinerary>;

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildProfileHeader(context, profile),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  child: Text(
                    'Mis Itinerarios',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                _buildItinerariesList(itineraries),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Profile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              profile.username?.isNotEmpty == true
                  ? profile.username!.substring(0, 1).toUpperCase()
                  : 'U',
              style: TextStyle(
                fontSize: 32,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.username ?? 'Usuario',
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  profile.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar perfil',
            onPressed: () async {
              // Navegamos a la pantalla de edición y esperamos el resultado.
              // Si el usuario edita, recargamos los datos al volver.
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(profile: profile),
                ),
              );
              setState(() {
                _loadProfileData();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItinerariesList(List<Itinerary> itineraries) {
    if (itineraries.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Aún no has creado ningún itinerario.\n¡Empieza a planificar tu próxima aventura!',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itineraries.length,
      itemBuilder: (context, index) {
        final itinerary = itineraries[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.map_outlined),
            title: Text(itinerary.name),
            subtitle: Text('Generado por IA'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItineraryDetailScreen(itinerary: itinerary),
                ),
              );
            },
          ),
        );
      },
    );
  }
}