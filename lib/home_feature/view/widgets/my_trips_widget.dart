import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyTripsWidget extends StatelessWidget {
  final Map<String, dynamic> trip;

  const MyTripsWidget({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const SizedBox(width: 5),
          SvgPicture.asset('assets/icons/bus.svg'),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الحافلة ${trip['busId']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevents text overflow
                ),
            Row(
                  children: [
                    Text(
                      _truncateText("${trip['firstTripRoute']?['stationName']}", 8),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // Prevents text overflow
                    ),
                    const SizedBox(width: 5),
                    SvgPicture.asset('assets/icons/arrow-right-circle.svg'),
                    const SizedBox(width: 5),
                    Text(
                      _truncateText("${trip['lastTripRoute']?['stationName']}", 8),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // Prevents text overflow
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${trip['firstTripRoute']?['expectedTime'] ?? '--:--'} - ${trip['lastTripRoute']?['expectedTime'] ?? '--:--'}',
                overflow: TextOverflow.ellipsis, // Prevents text overflow
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
  String _truncateText(String text, int maxLength) {
    return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
  }
}