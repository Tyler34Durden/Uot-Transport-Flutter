import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uot_transport/core/app_colors.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;

  final List<String> _imagePaths = const [
    'assets/images/OnBoarding_1.svg',
    'assets/images/OnBoarding_2.svg',
  ];

  final List<Map<String, String>> _imageTexts = const [
    {
      'title': 'مرحبا بك في تطبيق\n نقل جامعة طرابلس!',
      'description': 'طريقتك السهلة والموثوقة لإدارة رحلات\nالنقل الجامعي. كن متصلا, ووفر وقتك',
    },
    {
      'title': 'تجربة نقل سلسة',
      'description': 'اكتشف جداول الرحلات بسهولة، احجز مكانك،\n  مباشرة من التطبيق',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: screenHeight / 1.8,
            autoPlay: true,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
            clipBehavior: Clip.hardEdge,
          ),
          items: _imagePaths.map((imagePath) {
            final int index = _imagePaths.indexOf(imagePath);
            final bool isSecondImage = imagePath.contains('OnBoarding_2');

            return Builder(
              builder: (BuildContext context) {
                return Column(
                  children: [
                    Text(
                      _imageTexts[index]['title']!,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _imageTexts[index]['description']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: screenWidth,
                      height: screenHeight / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(isSecondImage ? 20 : 10),
                      ),
                      child: SvgPicture.asset(
                        imagePath,
                        fit: isSecondImage ? BoxFit.fitWidth : BoxFit.none,
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _imagePaths.asMap().entries.map((entry) {
              final int index = entry.key;
              return Container(
                width: 10.0,
                height: 10.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? AppColors.primaryColor
                      : Colors.black.withValues(alpha: 0.3),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
