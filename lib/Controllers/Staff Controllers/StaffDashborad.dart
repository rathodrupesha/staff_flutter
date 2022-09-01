import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hamrostay/Controllers/Staff%20Controllers/Notifications.dart';
import 'package:hamrostay/Controllers/Staff%20Controllers/Settings.dart';
import 'package:hamrostay/Controllers/Staff%20Controllers/ComplaintsList.dart';
import 'package:hamrostay/Controllers/Staff%20Controllers/StaffDetails.dart';
import 'package:hamrostay/Models/AssignServiceResponseModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/MyPrefs.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/localization/localization.dart';
import 'Complaints.dart';
import 'Login.dart';
import 'Profile.dart';

class StaffDashboard extends StatefulWidget {
  StaffDashboard({Key? key}) : super(key: key);

  @override
  _StaffDashboardState createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard>
    implements OnResponseCallback {
  int _currentIndex = 0;
  var userModel = UserData();
  var _isShowLoader = false;
  List<AssignServiceData> _objAssignServicesRowModel = [];
  var _searchController = TextEditingController();
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    wsAssignService();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: <Widget>[
            Scaffold(
              bottomNavigationBar: _bottomBar(),
              backgroundColor: Constants.appLightBackgroundColor,
              appBar: _customNavigationView(_currentIndex),
              body: _changeTabs(_currentIndex),
            ),
            _currentIndex == 0 ? _searchBarView() : Container()
          ],
        ),
      ),
    onWillPop: onWillPop,);
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: Translations.of(context).strPressBackToExit,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Constants.appBlueColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 25,
      selectedItemColor: Constants.appGreenForBottomBarColor,
      unselectedItemColor: Colors.white,
      currentIndex: _currentIndex,
      onTap: _onBottomBarItemTapped,
      backgroundColor: Constants.blueColor,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/img_bar_home.png'),
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/img_bar_room.png'),
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/img_bar_notification.png'),
            ),
            label: ""),
      ],
    );
  }

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _changeTabs(int index) {
    switch (index) {
      case 0:
        return _getBodyView();
      case 1:
        return Complaints();
      case 2:
        return Notifications();
      default:
        return Container();
    }
  }

  AppBar _customNavigationView(int index) {
    switch (index) {
      case 0:
        return WidgetUtils().customAppBar(
            context,
            Translations.of(context).strDashboard,
            'assets/images/img_menu.png',
            Colors.white,
            () {
              WidgetUtils().presentView(context, () => Settings());
            },
            imgColor: Colors.white,
            isRightControl: true,
            rightImgName: userModel.profileImage ?? "",
            barHeight: 50,
            onRightBtnPress: () {
              WidgetUtils().push(context, () => Profile(strTitle: Translations.of(context).strEditProfile));
            });
      case 1:
        return WidgetUtils().customAppBar(
            context,
            Translations.of(context).strComplaints,
            'assets/images/img_menu.png',
            Colors.white,
            () {
              WidgetUtils().presentView(context, () => Settings());
            },
            imgColor: Colors.white,
            isRightControl: true,
            rightImgName: userModel.profileImage ?? "",
            onRightBtnPress: () {
              WidgetUtils().push(context, () => Profile(strTitle: Translations.of(context).strEditProfile));
            });
      case 2:
        return WidgetUtils().customAppBar(
            context,
            Translations.of(context).strNotification,
            'assets/images/img_menu.png',
            Colors.white,
            () {
              WidgetUtils().presentView(context, () => Settings());
            },
            imgColor: Colors.white,
            isRightControl: true,
            rightImgName: userModel.profileImage ?? "",
            onRightBtnPress: () {
              WidgetUtils().push(context, () => Profile(strTitle: Translations.of(context).strEditProfile));
            });
      default:
        return WidgetUtils().customAppBar(
          context,
          '',
          'assets/images/img_menu.png',
          Colors.white,
          () {
            WidgetUtils().presentView(context, () => Settings());
          },
          imgColor: Colors.white,
        );
    }
  }

  Widget _searchBarView() {
    return Positioned(
      child: Container(
        height: 50,
        child: Material(
          elevation: 5,
          borderRadius: new BorderRadius.all(new Radius.circular(10)),
          child: TextField(
            controller: _searchController,
            cursorColor: Constants.appDarkBlueTextColor,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20,right: 5),
                hintText: Translations.of(context).strSearchHere,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                suffixIcon: IconButton(
                  iconSize: 25,
                  icon: Icon(
                    Icons.search,
                  ),
                  color: Constants.appDarkGreenColor,
                  onPressed: () {
                    wsAssignService();
                  },
                )),
            style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.normal,
                color: Constants.appDarkBlueTextColor,
                fontSize: getProportionalScreenWidth(16)),
          ),
        ),
      ),
      left: 10,
      top: SizeConfig.topHeight + kToolbarHeight + 25,
      right: 10,
    );
  }

  Widget _getBodyView() {
    return (_objAssignServicesRowModel.isEmpty)
        ? Container(
            height: SizeConfig.screenHeight * 0.75,
            child: WidgetUtils().noDataFoundText(_isShowLoader, Translations.of(context).strNoDataFound, 150, 150))
        : RefreshIndicator(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40,bottom: 16,left: 16,right: 16),
                  child: _ourServicesView(),
                ),
                Visibility(
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      backgroundColor: Constants.appSepratorColor,
                      color: Constants.appAquaTextColor,
                    )),
                    visible: _isShowLoader)
              ],
            ),
            onRefresh: _pullRefresh);
  }

  Future<void> _pullRefresh() async {
    wsAssignService();
  }

  Widget _ourServicesView() {

    return GridView.builder(
      itemCount: _objAssignServicesRowModel.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 10,
          childAspectRatio: (((SizeConfig.screenWidth - 60) * 0.5) /
              ((SizeConfig.screenWidth - 60) * 0.5))),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
            child: new Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                height: 24,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CachedNetworkImage(
                      width: ((SizeConfig.screenWidth - 60) * 0.5),
                      height: ((SizeConfig.screenWidth - 60) * 0.32),
                      fit: BoxFit.fill,
                      imageUrl: _objAssignServicesRowModel[index].image ?? "",
                      placeholder: (context, url) => Container(
                        color: Constants.appAquaPlaceholderColor,
                        child: Image.asset(
                          'assets/images/img_placeholder_logo.png',
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Constants.appAquaPlaceholderColor,
                        child: Image.asset(
                          'assets/images/img_placeholder_logo.png',
                        ),
                      ),
                    ),
                    WidgetUtils().sizeBoxHeight(10),
                    Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: WidgetUtils()
                                    .simpleTextViewWithGivenFontSize(
                                  '${_objAssignServicesRowModel[index].name}',
                                  getProportionalScreenWidth(14),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w500,
                                )),
                            // WidgetUtils().sizeBoxWidth(5.0),
                            Expanded(
                              flex: 0,
                              child: Container(
                                padding: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Constants.appBarBlueColor,
                                      width: 1.5),
                                ),
                                child: Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: WidgetUtils()
                                      .simpleTextViewWithGivenFontSize(
                                    _objAssignServicesRowModel[index]
                                        .count
                                        .toString(),
                                    getProportionalScreenWidth(14),
                                    Constants.appBarBlueColor,
                                    "Inter",
                                    FontWeight.w500,
                                  ),
                                )),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            onTap: () {
              WidgetUtils().push(context, () => StaffDetails(id:_objAssignServicesRowModel[index].id!,toolbarTitle:_objAssignServicesRowModel[index].name!,type: _objAssignServicesRowModel[index].type ?? "",));
            });
      },
    );
  }

  Future<void> wsAssignService() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    String strFullname =
        '${userModel.firstName!.replaceAll(" ", "")} ${userModel.lastName}';
    List<String> nameparts = strFullname.split(" ");

    String initials = nameparts[0].characters.first.toUpperCase() +
        nameparts[1].characters.first.toUpperCase();

    Constants.userInitials = initials;

    setState(() {
      _isShowLoader = true;
    });
    var map = Map();
    map["hotel_id"] = userModel.staffHotelId!.hotelId!;
    map["search_string"] = _searchController.text.toString();

    APICall(context).getAssignServiceApi(map, this);
  }

  @override
  void onResponseError(String message, int requestCode) {
    setState(() {
      _isShowLoader = false;
    });
    WidgetUtils().customToastMsg(message);
  }

  @override
  void onResponseReceived(response, int requestCode) {
    if (requestCode == API.requestAssignService && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var assignServiceResponse = AssignServiceResponseModel.fromJson(response);

      if (assignServiceResponse.code! == 200) {
        setState(() {
          _objAssignServicesRowModel = assignServiceResponse.data!;
        });
      } else if (assignServiceResponse.code! == 401) {
        MyPrefs.clearPref();
        Constants.token = null;

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false);
      } else {
        WidgetUtils().customToastMsg(assignServiceResponse.msg!);
      }
    }
  }
}
