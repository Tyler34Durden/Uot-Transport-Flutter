import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:uot_transport/core/network_config.dart';
import 'package:uot_transport/features/home_feature/presentation/pages/ad_details_screen.dart';
import 'package:uot_transport/features/home_feature/domain/entities/advertising_entity.dart';

class HomeSlider extends StatelessWidget {
  final List<AdvertisingEntity> advertisings;

  const HomeSlider({super.key, required this.advertisings});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const radius = 10.0;

    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        viewportFraction: 1.0,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: advertisings.map((ad) {
        var photoUrl = ad.photo;
        if (!photoUrl.startsWith('http')) {
          photoUrl = NetworkConfig.baseUrl + photoUrl;
        }

        return Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdDetailsScreen(
                      imageUrl: photoUrl,
                      title: ad.title,
                      description: ad.description,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Container(
                  width: width,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      ad.title,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
