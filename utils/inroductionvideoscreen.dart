import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/model/healthschoolmodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/videoprovider.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IntroductionVideoScreenActivity extends StatefulWidget {
  const IntroductionVideoScreenActivity({super.key});

  @override
  State<IntroductionVideoScreenActivity> createState() =>
      _IntroductionVideoScreenActivityState();
}

class _IntroductionVideoScreenActivityState
    extends State<IntroductionVideoScreenActivity> {
  VideoProvider _videoProvider = VideoProvider();

  @override
  void initState() {
    // TODO: implement initState
    _videoProvider = Provider.of<VideoProvider>(context, listen: false);
    fetchdata();
    super.initState();
  }

  fetchdata() async {
    await _videoProvider.introductionvideolist();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(builder: (context, videoProvider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBarScreens(
              text: "Introduktions video",
            )),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 2.h,
                right: 2.h,
              ),
              // child: GridView.builder(
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       mainAxisSpacing: 18,
              //       crossAxisSpacing: 35,
              //       crossAxisCount: 2,
              //       childAspectRatio: MediaQuery.of(context).size.width /
              //           (MediaQuery.of(context).size.height / 4),
              //     ),
              //     itemCount: healthschoolProvider.healthschoolList.length,
              //     shrinkWrap: true,
              //     physics: BouncingScrollPhysics(),
              //     // scrollDirection: Axis.vertical,
              //     itemBuilder: (context, index)

              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.w,
                runSpacing: 2.h,
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.spaceBetween,
                children: videoProvider.getvideolist.map((item) {
                  return GestureDetector(
                    onTap: () {
                      HealthschoolData healthschooldata = HealthschoolData(
                        title: item.title,
                        videoUrl: item.videoUrl,
                      );
                      Navigator.pushNamed(context, Routes.healthSchoolVideoPlay,
                          arguments: {
                            StringFile.healthschool: healthschooldata
                          }).then(
                        (value) {
                          setState(() {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                          });
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height: 34.h,

                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Stack(children: <Widget>[
                                Opacity(
                                  opacity: .8,
                                  child: Container(
                                    height: 30.w,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(2.w),
                                            topRight: Radius.circular(2.w)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              APIURL.imageurl +
                                                  (item.videoImage!),
                                            ),
                                            fit: BoxFit.cover)),
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.white70.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(50.h),
                                        ),
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // if (healthschoolProvider
                                //     .healthschoolList.isNotEmpty)
                                //   Padding(
                                //     padding: const EdgeInsets.only(
                                //         top: 8.0, left: 8, right: 2),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.start,
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.center,
                                //       children: [
                                //         InkWell(
                                //           onTap: () {
                                //             _isPressedLike(
                                //                 item.userLike!,
                                //                 item.id!.toString(),
                                //                 healthschoolProvider
                                //                     .healthschoolList
                                //                     .indexOf(item),
                                //                 item.userLike != null
                                //                     ? item.userLike!
                                //                         .toString()
                                //                     : '0');
                                //           },
                                //           child: Icon(
                                //             item.userLike != null
                                //                 ? item.userLike! == "1"
                                //                     ? Icons.thumb_up_alt
                                //                     : Icons
                                //                         .thumb_up_alt_outlined
                                //                 : Icons.thumb_up_alt_outlined,
                                //             size: 5.w,
                                //             color: item.userLike! == "1"
                                //                 ? Colors.blue
                                //                 : Colors.black,
                                //           ),
                                //         ),
                                //         SizedBox(
                                //           width: 1.w,
                                //         ),
                                //         Text(
                                //           item.totalLike.toString(),
                                //           // title[index].toString(),
                                //           style: Style_File.title
                                //               .copyWith(color: colorBlack),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                              ]),
                              Padding(
                                padding: EdgeInsets.all(1.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: SizedBox(
                                        width: 50.w,
                                        height: 2.h,
                                        child: Text(
                                          item.title.toString(),
                                          // title[index].toString(),
                                          style: Style_File.title
                                              .copyWith(color: colorBlack),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    FittedBox(
                                      child: SizedBox(
                                        width: 50.w,
                                        height: 3.5.h,
                                        child: Text(
                                          item.description.toString(),
                                          //"sub Title",
                                          // subtitletitle[index].toString(),
                                          style: Style_File.subtitle
                                              .copyWith(color: colorBlack),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FittedBox(
                                          child: SizedBox(
                                              width: 20.w,
                                              child: Text(
                                                DateFormat("dd-MM-yyyy")
                                                    .format(DateTime.parse(
                                                        item.createdAt!))
                                                    .toString(),
                                                style: Style_File.subtitle
                                                    .copyWith(color: colorGrey),
                                              )),
                                        ),
                                        Column(
                                          children: [
                                            // InkWell(
                                            //   onTap: () {
                                            //     _isPressedLike(
                                            //         item.userLike!,
                                            //         item.id!.toString(),
                                            //         healthschoolProvider
                                            //             .healthschoolList
                                            //             .indexOf(item),
                                            //         item.userLike != null
                                            //             ? item.userLike!
                                            //                 .toString()
                                            //             : '0');
                                            //   },
                                            //   child: Icon(
                                            //     item.userLike != null
                                            //         ? item.userLike! == "1"
                                            //             ? Icons.favorite_rounded
                                            //             : Icons
                                            //                 .favorite_border_rounded
                                            //         : Icons
                                            //             .favorite_border_outlined,
                                            //     size: 5.w,
                                            //     color: item.userLike! == "1"
                                            //         ? Colors.red
                                            //         : Colors.black,
                                            //   ),
                                            // ),
                                            SizedBox(
                                              height: 0.1.h,
                                            ),
                                            // Text(
                                            //   item.totalLike.toString(),
                                            //   // title[index].toString(),
                                            //   style: Style_File.subtitle
                                            //       .copyWith(color: colorBlack),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
