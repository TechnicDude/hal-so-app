import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/likeapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/favoriterecipemodel.dart';
import 'package:halsogourmet/model/recipemodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/favoriterecipeprovider.dart';
import 'package:halsogourmet/provider/recipelikebyuserprovider.dart';
import 'package:halsogourmet/screens/dises/beaf/beafui.dart';
import 'package:halsogourmet/screens/splash.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/networkimageload.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FavoriteRecipeScreen extends StatefulWidget {
  final List<FovoriteData>? fovoritedata;
  final String type;

  const FavoriteRecipeScreen({
    Key? key,
    this.fovoritedata,
    required this.type,
  }) : super(key: key);

  @override
  State<FavoriteRecipeScreen> createState() => _FavoriteRecipeScreenState();
}

class _FavoriteRecipeScreenState extends State<FavoriteRecipeScreen> {
  FavoriterecipeProvider _favoriterecipeProvider = FavoriterecipeProvider();

  get i => null;

  @override
  void initState() {
    // TODO: implement initState
    _favoriterecipeProvider =
        Provider.of<FavoriterecipeProvider>(context, listen: false);
    _favoriterecipeProvider.foodcategorylist();

    super.initState();
  }

  bool isPressed = false;
  TextEditingController sercheditcontroler = TextEditingController();
  String searchString = '';
  bool searchshow = false;

  List<FovoriteData> bottomlist = [];
  bool datashow = false;

  Future fetchdata() async {
    bottomlist = [];
    for (int i = 0;
        i < _favoriterecipeProvider.fovoriterecipeList.length;
        i++) {
      if (_favoriterecipeProvider.fovoriterecipeList[i].recipes!.title!
          .toLowerCase()
          .contains(searchString.toLowerCase())) {
        bottomlist.add(_favoriterecipeProvider.fovoriterecipeList[i]);
      }
    }

    datashow = true;
    return bottomlist;
  }

  Future dislike(String recipeid) async {
    LikeApi _likeapi = new LikeApi();
    final response = await _likeapi.disfav(recipeid);
    await _favoriterecipeProvider.foodcategorylist();

    DialogHelper.showFlutterToast(
        strMsg: "Favoriter borttagning framgångsrikt");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchshow
            ? Container(
                width: double.infinity,
                height: 5.h,
                decoration: BoxDecoration(
                    color: colorWhite,
                    border: Border.all(color: colorGrey),
                    borderRadius: BorderRadius.circular(4.h)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: TextField(
                      controller: sercheditcontroler,
                      onChanged: ((value) {
                        setState(() {
                          searchString = sercheditcontroler.text;
                        });
                      }),
                      decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: colorGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                searchshow = false;
                                sercheditcontroler.clear();
                                searchString = '';
                              });
                            },
                          ),
                          hintText: 'Sök...',
                          hintStyle: Style_File.subtitle,
                          border: InputBorder.none),
                    ),
                  ),
                ),
              )
            : Text(" "),
        automaticallyImplyLeading: false,
        actions: [
          if (!searchshow)
            IconButton(
              onPressed: () {
                setState(() {
                  searchshow = true;
                });
              },
              icon: Icon(Icons.search, color: colorBlack),
            ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorWhite,
      ),
      backgroundColor: colorWhite,
      body: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? InternetNotAvailable()
          : Consumer<FavoriterecipeProvider>(
              builder: (context, favoriterecipeProvider, child) {
              return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Mitt Favoriter",
                            style: Style_File.title.copyWith(fontSize: 18.sp),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    if (!favoriterecipeProvider.datanotfound)
                      SizedBox(
                          height: 80.h, child: Center(child: LoaderScreen())),
                    if (favoriterecipeProvider.datanotfound)
                      if (favoriterecipeProvider.fovoriterecipeList.isEmpty)
                        NoDataFoundErrorScreens(),
                    if (favoriterecipeProvider.datanotfound)
                      if (favoriterecipeProvider.fovoriterecipeList.isNotEmpty)
                        FutureBuilder(
                            future: fetchdata(),
                            builder: (context, snapshot) {
                              print(datashow);
                              if (snapshot.hasData && datashow) {
                                if (bottomlist.isEmpty)
                                  return NoDataFoundErrorScreens();

                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: bottomlist.length,
                                    //  favoriterecipeProvider.fovoriterecipeList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                    
                                      return InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.foodDetails,
                                            arguments: {
                                              StringFile.foodtypeId:
                                                  favoriterecipeProvider
                                                      .fovoriterecipeList[index]
                                                      .recipes!
                                                      .id
                                                      .toString(),
                                              StringFile.foodtypeName:
                                                  favoriterecipeProvider
                                                          .fovoriterecipeList[
                                                              index]
                                                          .recipes!
                                                          .title ??
                                                      ''
                                            },
                                          ).then((value) {
                                            _favoriterecipeProvider
                                                .foodcategorylist();
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0,
                                              right: 25,
                                              top: 10,
                                              bottom: 10),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                height: 12.h,
                                                decoration: BoxDecoration(
                                                    color: index % 2 == 0
                                                        ? Colors.black
                                                        : Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black,
                                                        blurRadius: .5,
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8.w),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    8.w),
                                                            bottomRight:
                                                                Radius
                                                                    .circular(
                                                                        4.w),
                                                            topRight:
                                                                Radius.circular(
                                                                    4.w))),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 20.w,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 1.5.h,
                                                                  bottom: 0.2.h,
                                                                  left: 2.w,
                                                                  right: 0.2.h),
                                                          child: SizedBox(
                                                            width: 50.w,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  favoriterecipeProvider
                                                                      .fovoriterecipeList[
                                                                          index]
                                                                      .recipes!
                                                                      .title!,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: Style_File
                                                                      .title
                                                                      .copyWith(
                                                                    color: index %
                                                                                2 !=
                                                                            0
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 1.h,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        IconButton(
                                                          onPressed: () {
                                                            dislike(favoriterecipeProvider
                                                                .fovoriterecipeList[
                                                                    index]
                                                                .recipes!
                                                                .id
                                                                .toString());
                                                          },
                                                          icon: Icon(
                                                              Icons.favorite),
                                                          color: Colors.red,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 22.w,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Protein",
                                                              style: Style_File
                                                                  .title
                                                                  .copyWith(
                                                                      fontSize:
                                                                          13.sp,
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                            Text(
                                                              "${favoriterecipeProvider.fovoriterecipeList[index].recipes!.protein} gm",
                                                              style: Style_File.title.copyWith(
                                                                  fontSize:
                                                                      13.sp,
                                                                  color: index %
                                                                              2 ==
                                                                          0
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        Container(
                                                          height: 2.5.h,
                                                          width: .5.w,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Kolhydrater",
                                                              style: Style_File
                                                                  .title
                                                                  .copyWith(
                                                                      fontSize:
                                                                          13.sp,
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                            Text(
                                                              "${favoriterecipeProvider.fovoriterecipeList[index].recipes!.carbohydrate} gm",
                                                              style: Style_File.title.copyWith(
                                                                  fontSize:
                                                                      13.sp,
                                                                  color: index %
                                                                              2 ==
                                                                          0
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        Container(
                                                          height: 2.5.h,
                                                          width: .5.w,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Fett",
                                                              style: Style_File
                                                                  .title
                                                                  .copyWith(
                                                                      fontSize:
                                                                          13.sp,
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                            Text(
                                                              "${favoriterecipeProvider.fovoriterecipeList[index].recipes!.fat} gm",
                                                              //  "${((int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString()) + int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString())).toString())} min",
                                                              style: Style_File.title.copyWith(
                                                                  fontSize:
                                                                      13.sp,
                                                                  color: index %
                                                                              2 ==
                                                                          0
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                top: 1.h,
                                                left: -4.w,
                                                child: Container(
                                                  height: 10.h,
                                                  width: 10.h,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: colorGrey,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                            APIURL.imageurl +
                                                                (favoriterecipeProvider
                                                                    .fovoriterecipeList[
                                                                        index]
                                                                    .recipes!
                                                                    .recipeimage![
                                                                        0]
                                                                    .image!),
                                                          ) as ImageProvider,
                                                          fit: BoxFit.fill),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: colorGrey,
                                                          blurRadius: 5,
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                            
                              } else {
                                return NoDataFoundErrorScreens();
                              }
                            }),
                    SizedBox(
                      height: 4.h,
                    ),
                  ],
                ),
              );
            }),
    );
  }
}
