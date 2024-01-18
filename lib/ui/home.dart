
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joistic_assignment/bloc/home/home_bloc.dart';
import 'package:joistic_assignment/component/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/colors.dart';
import '../helper/config.dart';
import '../helper/reuse_widget.dart';
import '../model/list_model.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListData> listData = [];
  List<ListData> filteredList = [];
  TextEditingController searchController = TextEditingController();
  bool searchShow = false;
  late Map<String, bool> appliedStatusMap;
  bool isApplied = false;

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    appliedStatusMap = {};
    loadAppliedStatuses();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadAppliedStatuses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      appliedStatusMap = Map<String, bool>.from(prefs.getKeys().fold(
        {},
            (previousValue, key) {
          final dynamic storedValue = prefs.get(key);
          if (storedValue is bool) {
            return {...previousValue, key: storedValue};
          } else {
            return previousValue;
          }
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is FetchHomeSuccess) {
          setState(() {
            listData = state.listData;
            filteredList = listData;
          });
        }
      },
      builder: (context, state) {
        if (state is HomeLoading) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: PreferredSize(
                preferredSize:
                Size(SizeConfig.screenWidth, SizeConfig.blockHeight * 8),
                child: Container(
                  color: COLORS.white,
                  padding: EdgeInsets.only(
                      top: SizeConfig.blockHeight * 7,
                      right: SizeConfig.blockWidth * 7,
                      bottom: SizeConfig.blockHeight * 1,
                      left: SizeConfig.blockWidth * 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: SizeConfig.blockWidth * 15,
                          child: const Icon(
                            Icons.menu,
                          ),
                        ),
                      ),

                    ],
                  ),
                )),
            drawer: drawerHelper(context: context),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: SizeConfig.screenWidth,
                  margin: EdgeInsets.only(top: SizeConfig.blockHeight * 2),
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockWidth * 2,
                      horizontal: SizeConfig.blockHeight * 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Find your Dream \nJob today",
                        style: TextStyle(
                          color: COLORS.blackdark,
                          fontSize: SizeConfig.blockWidth * 8.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockHeight * 1.5,
                      ),
                      Column(
                        children: List.generate(8, (index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight*2),
                            child: shimmerCard(
                              height: SizeConfig.blockHeight * 12,
                              width: SizeConfig.blockWidth * 100,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        else if(state is FetchHomeSuccess){
          return RefreshIndicator(
            child: GestureDetector(
              onTap: (){
                FocusScopeNode currentFocus = FocusScope.of(context);
                if(!currentFocus.hasPrimaryFocus){
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
                key: _scaffoldKey,
                appBar: PreferredSize(
                    preferredSize:
                    Size(SizeConfig.screenWidth, SizeConfig.blockHeight * 8),
                    child: Container(
                      color: COLORS.white,
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockHeight * 7,
                          right: SizeConfig.blockWidth * 7,
                          bottom: SizeConfig.blockHeight * 1,
                          left: SizeConfig.blockWidth * 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              _scaffoldKey.currentState!.openDrawer();
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: SizeConfig.blockWidth * 15,
                              child: const Icon(
                                Icons.menu,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: searchShow,
                            child: SizedBox(
                              width: SizeConfig.blockWidth * 50,
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {
                                    filteredList = listData
                                        .where((data) =>
                                        data.title!.contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Search by title',
                                ),
                              ),
                            ),
                          ),
                          searchShow == false
                              ? InkWell(
                            onTap: () {
                              setState(() {
                                searchShow = true;
                              });
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                              : InkWell(
                            onTap: () {
                              setState(() {
                                searchShow = false;
                                searchController.clear();
                                filteredList = listData;
                              });
                            },
                            child: const Icon(
                              Icons.clear,
                            ),
                          )
                        ],
                      ),
                    )),
                drawer: drawerHelper(context: context),
                body: SafeArea(
                  child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Container(
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.only(top: SizeConfig.blockHeight * 2),
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockWidth * 2,
                          horizontal: SizeConfig.blockHeight * 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Find your Dream \nJob today",
                            style: TextStyle(
                              color: COLORS.blackdark,
                              fontSize: SizeConfig.blockWidth * 8.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockHeight * 1.5,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                bool isApplied =
                                    appliedStatusMap[filteredList[index].id] ?? false;
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: SizeConfig.blockHeight * 2,
                                  ),
                                  child: Material(
                                    elevation: 0.1, // Adjust the elevation as needed
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.blockWidth * 3),
                                    child: Container(
                                      width: SizeConfig.screenWidth,
                                      padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.blockHeight * 2,
                                        horizontal: SizeConfig.blockWidth * 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: COLORS.white,
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.blockWidth * 3),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _showBottomSheet(context,
                                              filteredList[index], isApplied);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      color: COLORS.whiteDark,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        width: 0.5,
                                                        color: COLORS.whiteDark,
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.all(
                                                        SizeConfig.blockWidth * 5),
                                                    child:                                               Image.network(
                                                      filteredList![index].thumbnailUrl!,
                                                      width: SizeConfig.blockWidth * 8,
                                                      fit: BoxFit.fill,
                                                      errorBuilder: (context, error, stackTrace) => Container(
                                                          clipBehavior: Clip.antiAlias,
                                                          decoration: BoxDecoration(
                                                            color: COLORS.whiteDark,
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              width: 0.5,
                                                              color: COLORS.whiteDark,
                                                            ),
                                                          ),
                                                          child: shimmerCardRounded()),
                                                    ),
            
                                                ),
                                                SizedBox(
                                                  width: SizeConfig.blockWidth * 3,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    _showBottomSheet(
                                                        context,
                                                        filteredList[index],
                                                        isApplied);
                                                  },
                                                  child: SizedBox(
                                                    width: SizeConfig.blockWidth * 38,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          getFirstTwoWords(
                                                              filteredList![index]
                                                                  .title!),
                                                          maxLines: 1,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: COLORS.blackdark,
                                                            fontSize: SizeConfig
                                                                .blockWidth *
                                                                4.5,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontFamily: "Poppins",
                                                          ),
                                                        ),
                                                        Text(
                                                          filteredList![index].title!,
                                                          maxLines: 1,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: COLORS.blackMedium,
                                                            fontSize: SizeConfig
                                                                .blockWidth *
                                                                3.8,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            fontFamily: "Poppins",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  color: COLORS.blueExtraDark,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      SizeConfig.blockWidth * 3),
                                                  child: Icon(
                                                    Icons.home,
                                                    color: COLORS.white,
                                                    size: SizeConfig.blockWidth * 5,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
              onRefresh: (){
                return Future.delayed(
                    const Duration(milliseconds: 200),
                        (){
                          homeBloc.add(const FetchListEvent());
                    }
                );
              }
          );
        }
        else if (state is FetchHomeFailed) {
          return errorWidget(onPressed: (){
            homeBloc.add(const FetchListEvent());
          });
        }
        return Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenWidth,
          color: COLORS.white,
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, ListData item, bool applied) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        isApplied = applied;
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockHeight * 3,
                    horizontal: SizeConfig.blockWidth * 13),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.only(bottom: SizeConfig.blockHeight * 2),
                        decoration: BoxDecoration(
                          color: COLORS.whiteDark,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 0.5,
                            color: COLORS.whiteDark,
                          ),
                        ),
                        padding: EdgeInsets.all(SizeConfig.blockWidth * 5),
                        child: Image.network(
                         item.thumbnailUrl!,
                          width: SizeConfig.blockWidth * 8,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) => Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: COLORS.whiteDark,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 0.5,
                                  color: COLORS.whiteDark,
                                ),
                              ),
                              child: shimmerCardRounded()),
                        ),

                    ),
                    Text(
                      getFirstTwoWords(item.title!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: COLORS.blackdark,
                        fontSize: SizeConfig.blockWidth * 6.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockHeight * 1.8,
                    ),
                    Text(
                      'Silicon Valley, CA',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: COLORS.blackMedium,
                        fontSize: SizeConfig.blockWidth * 3.6,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockHeight * 2.1,
                    ),
                    Text(
                      item.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: COLORS.blackMedium,
                        fontSize: SizeConfig.blockWidth * 4,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockHeight * 7.5,
                    ),
                    Text(
                      "Description",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: COLORS.blackMedium,
                        fontSize: SizeConfig.blockWidth * 3,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockHeight * 1.5,
                    ),
                    Text(
                      "Senior UI/UX Designer",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: COLORS.black,
                        fontSize: SizeConfig.blockWidth * 4.6,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockHeight * 4.5,
                    ),
                    Text(
                      "Details",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: COLORS.blackMedium,
                        fontSize: SizeConfig.blockWidth * 3,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockHeight * 1.5,
                    ),

                    Column(
                      children: List.generate(8, (index) {
                        return Text(
                          item.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: COLORS.black,
                            fontSize: SizeConfig.blockWidth * 3.8,
                            height: SizeConfig.blockHeight*0.4,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              alignment: Alignment.center,
              height: SizeConfig.blockHeight * 14,
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockWidth * 9,
                  vertical: SizeConfig.blockHeight * 3),
              child: InkWell(
                onTap: () {
                  if (isApplied == false) {
                    setState(() {
                      appliedStatusMap[item.id!] = true;
                      isApplied = true;
                    });
                    updateAppliedStatuses();
                    final snackBar = SnackBar(
                        content: Container(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: COLORS.green,
                                ),
                                SizedBox(
                                  width: SizeConfig.blockWidth * 1,
                                ),
                                Text(
                                  "Job Applied Successfully",
                                  style: TextStyle(
                                    color: COLORS.white,
                                    fontSize: SizeConfig.blockWidth * 4.2,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ],
                            )));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(SizeConfig.blockWidth * 2.5),
                      border: Border.all(
                          color: COLORS.whiteBorder,
                          width: SizeConfig.blockWidth * 1.3),
                      color: COLORS.blue),
                  child: Text(
                    isApplied == true ? "APPLIED" : "APPLY NOW",
                    style: TextStyle(
                      color: COLORS.white,
                      fontSize: SizeConfig.blockWidth * 4,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> updateAppliedStatuses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appliedStatusMap.forEach((key, value) {
      prefs.setBool(key, value);
    });
  }
}

// class MyClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, size.height);
//     path.quadraticBezierTo(
//       size.width / 2,
//       size.height + 20.0, // Adjust the curve depth as needed
//       size.width,
//       size.height,
//     );
//     path.lineTo(size.width, 0);
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
