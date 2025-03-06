// File: lib/home_feature/view/widgets/my_trips_widget.dart
          import 'package:flutter/material.dart';
          import 'package:flutter_svg/svg.dart';

          class MyTripsWidget extends StatelessWidget {
            const MyTripsWidget({super.key});

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
                          const Text('اسم الحافلة'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text('من'),
                              SvgPicture.asset('assets/icons/arrow-right-circle.svg'),
                              const Text('الى'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(), // replaces SizedBox(width: 140)
                    const Text("12:00 - 13:00"),
                    SizedBox(width: 20,)
                  ],
                ),
              );
            }
          }