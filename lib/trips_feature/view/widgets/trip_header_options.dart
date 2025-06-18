import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';

class TripHeaderOptions extends StatelessWidget {
  final Map<String, dynamic> tripData;
  const TripHeaderOptions({
    super.key,
    required this.tripData,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> bus = tripData['bus'] ?? {};
    final Map<String, dynamic> booking = tripData['booking'] ?? {};
    final int numberOfSeats = bus['numberOfSeats'] ?? 0;
    final int male = booking['male'] ?? 0;
    final int female = booking['female'] ?? 0;
    final String busId = bus['id']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Seats
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مقاعد',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Icon(Icons.chair_alt_rounded, color: AppColors.primaryColor),
              const SizedBox(height: 2),
              Text(
                '$numberOfSeats',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          // Passengers
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'الركاب',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.male, color: Colors.blue),
                  Text('$male', style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Icon(Icons.female, color: Colors.pink),
                  Text('$female', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
          // Bus
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'الحافلة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Icon(Icons.bus_alert, color: AppColors.primaryColor),
              const SizedBox(height: 2),
              Text(
                busId,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}