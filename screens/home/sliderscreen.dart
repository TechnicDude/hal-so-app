import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/model/bannermodel.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

final List<String> imgList = [
  "assets/images/meat.png",
  'https://www.surfsidepoke.be/wp-content/uploads/2022/07/HomePageBannerPC_ENG_Smaller.jpg',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
];

class SliderScreen extends StatelessWidget {
  final List<BannerData>? bannerdata;
  const SliderScreen({Key? key, this.bannerdata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(bannerdata!.length);

    return CarouselSlider.builder(
      itemCount: bannerdata!.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        return InkWell(
          onTap: () {},
          child: CachedNetworkImage(
            imageUrl: APIURL.imageurl + bannerdata![itemIndex].image!,
            width: 100.w,
            fit: BoxFit.cover,
            placeholder: (context, url) => LoaderScreen(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      },
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
    );
  }
}
