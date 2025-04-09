import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeSlider extends StatelessWidget {
  final List<Map<String, dynamic>> advertisings;

  const HomeSlider({Key? key, required this.advertisings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 130,
        viewportFraction: 1.0,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: advertisings.map((ad) {
        print(ad['photo']);
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage("https://uottransportserver-28f59bae71b7.herokuapp.com/public/advertising_photos"+ad['photo']), // Access photo dynamically
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  ad['title'], // Access title dynamically
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}