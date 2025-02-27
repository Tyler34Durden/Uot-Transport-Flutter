import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';

class BackHeader extends StatelessWidget {
  const BackHeader({this.showBackBtn = true, super.key, this.onBackbtn});

  final bool showBackBtn;
  final Function()? onBackbtn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            showBackBtn
                ? SquareButton(
                    onBackbtn: onBackbtn ?? () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final Widget child;
  final Function()? onBackbtn;

  const SquareButton({Key? key, required this.child, this.onBackbtn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onBackbtn,
      icon: child,
    );
  }
}