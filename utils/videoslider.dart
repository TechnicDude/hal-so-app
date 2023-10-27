import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final List<String> imgList = [
  'https://img.freepik.com/premium-photo/set-chinese-dishes-table-space-text_92134-3366.jpg',
  'https://static.wixstatic.com/media/dc01c7_112f53bb191c44ad919968e1b77275f4~mv2_d_2000_1333_s_2.jpg/v1/fit/w_2500,h_1330,al_c/dc01c7_112f53bb191c44ad919968e1b77275f4~mv2_d_2000_1333_s_2.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-j_IKF4-6nQ6D-ZKJwcPPBCFfkQANsfBtT9jC5-isc_eqA-KavxZ3VsRrZISZvI0Q1hE&usqp=CAU',
  'https://media.istockphoto.com/id/1280048472/photo/classic-thanksgiving-turkey-dinner-top-down-view-frame-on-a-rustic-white-wood-background.jpg?b=1&s=170667a&w=0&k=20&c=C7enpNf-hoU9Hfa1tWVkbGNDQSO2YHiqPFFBUlaCw1c=',
  'https://media.istockphoto.com/id/1309105984/photo/hands-of-people-at-the-table-with-food-shrimp-with-wine.jpg?b=1&s=170667a&w=0&k=20&c=BW-_WG62CvGDg69oquuR7ODFEqw_CFSVyYH4MQfrp7w=',
  'https://thumbs.dreamstime.com/b/sharing-christmas-food-table-diet-organic-hands-celebration-homemade-drinks-tea-candle-dinning-eating-friends-sharing-food-132199402.jpg',
  'https://st2.depositphotos.com/3591429/10367/i/950/depositphotos_103671988-stock-photo-friends-eating-for-big-table.jpg',
  'https://media.istockphoto.com/id/545286388/photo/chinese-food-blank-background.jpg?b=1&s=170667a&w=0&k=20&c=ipMtvr-QmWrqBWleY3aVy7-uiyw9NYqTT6nm8vfuVRc=',
];

class VideoSlider extends StatelessWidget {
  const VideoSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CarouselSlider.builder(
      options: CarouselOptions(
        enlargeCenterPage: false,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
      ),
      itemCount: (imgList.length / 4).round(),
      itemBuilder: (context, index, realIdx) {
        final int first = index * 5;
        final int second = first + 1;
        return Row(
          children: [
            first,
          ].map((idx) {
            return Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 1,
                ),
                child: Image.network(imgList[idx], fit: BoxFit.cover),
              ),
            );
          }).toList(),
        );
      },
    ));
  }
}
