// lib/features/bookings/widgets/booking_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:viajes_ai/api/models/activity_model.dart';
import 'package:viajes_ai/api/models/booking_model.dart';
import 'package:viajes_ai/api/supabase_service.dart';

class BookingBottomSheet extends StatefulWidget {
  final Activity activity;
  // --- ¡NUEVO PARÁMETRO! ---
  // Esta es una función que se llamará cuando la reserva sea exitosa.
  final VoidCallback onBookingConfirmed;

  const BookingBottomSheet({
    super.key,
    required this.activity,
    required this.onBookingConfirmed, // <-- Ahora es un parámetro requerido
  });

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final SupabaseService _supabaseService = SupabaseService();
  DateTime? _selectedDate;
  int _numberOfTravelers = 1;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _confirmBooking() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una fecha.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final newBooking = Booking(
        userId: userId,
        activityId: widget.activity.id,
        bookingDate: DateTime.now(),
        activityStartDate: _selectedDate!,
        numTravelers: _numberOfTravelers,
        totalPrice: widget.activity.price * _numberOfTravelers,
      );

      await _supabaseService.createBooking(newBooking);

      if (mounted) {
        // --- ¡LLAMAMOS A LA FUNCIÓN DE CALLBACK! ---
        widget.onBookingConfirmed();
        
        Navigator.of(context).pop(); // Cierra el bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Reserva confirmada con éxito!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear la reserva: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.activity.price * _numberOfTravelers;

    return Padding(
      padding: const EdgeInsets.all(20.0).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reservar "${widget.activity.name}"', style: Theme.of(context).textTheme.headlineSmall),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(_selectedDate == null
                ? 'Seleccionar fecha'
                : 'Fecha: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text('Viajeros: $_numberOfTravelers'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _numberOfTravelers > 1 ? () => setState(() => _numberOfTravelers--) : null,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _numberOfTravelers++),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF673AB7),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Confirmar por ${widget.activity.currency} ${totalPrice.toStringAsFixed(2)}',
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}