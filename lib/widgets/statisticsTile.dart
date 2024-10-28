import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:findara/config/config.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// // ignore: depend_on_referenced_packages
import 'package:percent_indicator/linear_percent_indicator.dart';

Widget statisticsTile({
  required String title,
  required Icon icon,
  required String value,
  required Color progressColor,
  required double progressPercent,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color.fromRGBO(205, 213, 223, 1)),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(76, 85, 102, 1),
              ),
            ),
            icon,
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            RotatedBox(
              quarterTurns: -1,
              child: LinearPercentIndicator(
                width: 60,
                animation: true,
                lineHeight: 6,
                animationDuration: 2500,
                percent: progressPercent,
                barRadius: Radius.circular(3),
                progressColor: progressColor,
                padding: EdgeInsets.zero,
                backgroundColor: progressColor.withOpacity(0.2),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: Color.fromRGBO(76, 85, 102, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget notificationTile({
  required String title,
  required Icon icon,
  required String message,
  required String time,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color.fromRGBO(205, 213, 223, 1)),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(76, 85, 102, 1),
                  ),
                ),
              ],
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(163, 174, 190, 1),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(76, 85, 102, 1),
          ),
        ),
      ],
    ),
  );
}
