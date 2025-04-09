import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/app_dropdown.dart';
import 'package:uot_transport/core/main_screen.dart';
import 'package:uot_transport/trips_feature/view/screens/trip_details_screen.dart';

class ActiveTripsWidget extends StatelessWidget {
  final String tripName;

  const ActiveTripsWidget({super.key, required this.tripName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(tripName: tripName),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 5),
            SvgPicture.asset('assets/icons/bus.svg'),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('اسم الحافلة'),
                  const Text("12:00 - 13:00"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('من'),
                      const SizedBox(width: 5),
                      SvgPicture.asset('assets/icons/arrow-right-circle.svg'),
                      const SizedBox(width: 5),
                      const Text('الى'),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                const SizedBox(height: 15),
                AppButton(
                  lbl: "حجز",
                  onPressed: () {
                    _showStationDialog(context);
                  },
                  color: AppColors.secondaryColor,
                  textColor: AppColors.primaryColor,
                  width: 92,
                  height: 36,
                ),
              ],
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  void _showStationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? selectedValue1;
        String? selectedValue2;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Align(
                alignment: Alignment.centerRight,
                child: Text('اختر المحطات')),
            content: Container(
              width: 800, // Set the desired width
              height: 260, // Set the desired height
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: AppText(
                      lbl: 'من',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  AppDropdown(
                    items: ['Option 1', 'Option 2', 'Option 3'],
                    hintText: 'Select Option 1',
                    value: selectedValue1,
                    onChanged: (String? newValue) {
                      selectedValue1 = newValue;
                    },
                  ),
                  const SizedBox(height: 10,),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: AppText(
                      lbl: 'الى',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  AppDropdown(
                    items: ['Option 1', 'Option 2', 'Option 3'],
                    hintText: 'Select Option 2',
                    value: selectedValue2,
                    onChanged: (String? newValue) {
                      selectedValue2 = newValue;
                    },
                  ),
                  const SizedBox(height: 10,),
                  AppButton(
                    lbl: "تأكيد الحجز",
                    onPressed: () {
                      _showBookingDialog(context);
                    },
                    color: AppColors.primaryColor,
                    textColor: AppColors.backgroundColor,
                    width: 265,
                    height: 45,
                  ),
                  const SizedBox(height:10),
                  AppButton(
                    lbl: "إلغاء",
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    color: AppColors.secondaryColor,
                    textColor: AppColors.primaryColor,
                    width: 265,
                    height: 45,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Align(
                alignment: Alignment.centerRight,
                child: Text('هل انت متأكد من حجز الحافلة #')),
            content: Container(
              width: 500, // Set the desired width
              height: 150, // Set the desired height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("سوف تقوم بحجز الحافلة من كلية الى الفرناج"),
                  const SizedBox(height: 20,),
                  AppButton(
                    lbl: "تأكيد الحجز",
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                    color: AppColors.primaryColor,
                    textColor: AppColors.backgroundColor,
                    width: 265,
                    height: 45,
                  ),
                  const SizedBox(height:10),
                  AppButton(
                    lbl: "إلغاء",
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    color: AppColors.secondaryColor,
                    textColor: AppColors.primaryColor,
                    width: 265,
                    height: 45,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SvgPicture.asset("assets/icons/check.svg"),
          content: Container(
            width: 800, // Set the desired width
            height: 150, // Set the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('تم تأكيد الحجز بنجاح'),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                    );
                  },
                  child: const Text('الذهاب إلى الصفحة الرئيسية'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}