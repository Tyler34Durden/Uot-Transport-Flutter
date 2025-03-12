import 'package:flutter/material.dart';

class TripSqureTile extends StatelessWidget {
  const TripSqureTile({
    super.key,
    required this.label,
    required this.onTap,
    required this.icon,
    this.iconColor,
  });

  final String label;
  final void Function() onTap;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Icon(icon, size: 30, color: iconColor),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
