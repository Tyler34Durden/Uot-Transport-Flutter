import 'package:flutter/material.dart';
                    import 'package:uot_transport/core/app_colors.dart';
                    import 'package:uot_transport/core/core_widgets/back_header.dart';

                    class AdDetailsScreen extends StatelessWidget {
                      final String imageUrl;
                      final String title;
                      final String description;

                      const AdDetailsScreen({
                        Key? key,
                        required this.imageUrl,
                        required this.title,
                        required this.description,
                      }) : super(key: key);

                      @override
                      Widget build(BuildContext context) {
                        final screenHeight = MediaQuery.of(context).size.height;

                        return Scaffold(
                          backgroundColor: AppColors.backgroundColor,
                          appBar: BackHeader(),
                          body: SingleChildScrollView(
                            child: Container(
                              color: AppColors.backgroundColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.6,
                                    width: double.infinity,
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: Text(
                                      title,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                        description,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black87,
                                          height: 1.6,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }