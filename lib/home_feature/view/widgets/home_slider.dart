// File: lib/home_feature/view/widgets/home_carousel_slider.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeSlider extends StatelessWidget {
  const HomeSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 130,
        viewportFraction: 1.0,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: [1, 2, 3].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Slide $i',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}