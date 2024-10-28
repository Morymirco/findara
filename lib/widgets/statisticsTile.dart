  import 'package:flutter/material.dart';
  // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  // import 'package:findara/config/config.dart';
  // import 'package:flutter_screenutil/flutter_screenutil.dart';
  // // ignore: depend_on_referenced_packages
  // import 'package:percent_indicator/linear_percent_indicator.dart';

  Widget statisticsTile({ Color ? progressColor, String ? title, Icon? icon, String ? value, double ? progressPercent, String ? unitName }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color:Color.fromRGBO(205, 213, 223, 1)),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: const TextStyle(
               
                    color: Color.fromRGBO(76, 85, 102, 1),
                    fontWeight: FontWeight.bold,

                    fontSize: 13
                  ),
                ),
                icon!,
              ],
            ),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  // child: LinearPercentIndicator(
                  //   width: 60. w,
                  //   animation: true,
                  //   lineHeight: 6,
                  //   animationDuration: 2500,
                  //   percent: progressPercent!,
                  //   barRadius: Radius.circular(3),
                  //   progressColor: progressColor!,
                  //   padding: EdgeInsets.zero,
                  //   backgroundColor: AppColors.colorTint400.withOpacity(0.4),
                  // ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value.toString(),
                      style: const TextStyle(
                        color:Color.fromRGBO(76, 85, 102, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      unitName ?? 'kcal',
                      style: const TextStyle(
                        color: Color.fromRGBO(116, 128, 148, 1),
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }