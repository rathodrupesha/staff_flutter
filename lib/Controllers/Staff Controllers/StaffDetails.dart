import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/Staff%20Controllers/StaffOrderDetails.dart';
import 'package:hamrostay/Models/BaseResponseModel.dart';
import 'package:hamrostay/Models/MyOrderListModel.dart';
import 'package:hamrostay/Models/RequestListModel.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/app_date_format.dart';
import 'package:hamrostay/Utils/date_utils.dart';
import 'package:hamrostay/Utils/pull_to_refresh_list_view.dart';
import 'package:hamrostay/localization/localization.dart';

import '../../Models/BookingListModel.dart';
import '../../Models/UserModel.dart';
import '../../Utils/API.dart';
import '../../Utils/APICall.dart';
import '../../Utils/MyPrefs.dart';

class StaffDetails extends StatefulWidget {
  StaffDetails(
      {Key? key, required this.id, required this.toolbarTitle, this.type})
      : super(key: key);

  int id;
  String toolbarTitle;
  String? type;

  @override
  _StaffDetailsState createState() => _StaffDetailsState();
}

class _StaffDetailsState extends State<StaffDetails>
    implements OnResponseCallback {
  bool isSelectedCompleted = false;
  var userModel = UserData();
  var _isShowLoader = false;
  var _isShowLoaderAcceptDecline = false;
  List<OrderListRows> _objOrderDataRowModel = [];
  List<BookingListRows> _objBookingDataRowModel = [];
  List<RequestListRows> _objRequestDataRowModel = [];
  var _reasonController = TextEditingController();
  var _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 5),() async {
      userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;
    });


    if (widget.type == Constants.typeOrder) {
      wsGetOrderList();
    } else if (widget.type == Constants.typeBooking) {
      wsGetBookingList();
    } else if (widget.type == Constants.typeRequest) {
      wsGetServiceList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: [
          Scaffold(
              backgroundColor: Constants.appLightBackgroundColor,
              appBar: WidgetUtils().customAppBar(
                context,
                widget.toolbarTitle,
                'assets/images/btn_back.png',
                Colors.white,
                () {
                  Navigator.of(context).pop();
                },
                barHeight: (_objOrderDataRowModel.isEmpty &&
                        _objBookingDataRowModel.isEmpty &&
                        _objRequestDataRowModel.isEmpty)
                    ? 0
                    : 50,
                imgColor: Colors.white,
              ),
              body: Material(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  left: false,
                  child: _getBodyView(),
                ),
              )),
          _searchBarView()
        ],
      ),
    );
  }

  Widget _getBodyView() {
    return Stack(
      children: [
        Container(
            margin: (_objOrderDataRowModel.isEmpty &&
                    _objBookingDataRowModel.isEmpty &&
                    _objRequestDataRowModel.isEmpty)
                ? EdgeInsets.only(top: getProportionalScreenHeight(0))
                : EdgeInsets.only(top: getProportionalScreenHeight(30)),
            child: _allItemsView()),
        Visibility(
            child: Center(
                child: CircularProgressIndicator(
              strokeWidth: 5.0,
              backgroundColor: Constants.appSepratorColor,
              color: Constants.appAquaTextColor,
            )),
            visible: _isShowLoaderAcceptDecline)
      ],
    );
  }

  Widget _searchBarView() {
    return (_objOrderDataRowModel.isEmpty &&
            _objBookingDataRowModel.isEmpty &&
            _objRequestDataRowModel.isEmpty)
        ? Container()
        : Positioned(
            child: Container(
              height: 50,
              child: Material(
                elevation: 5,
                borderRadius: new BorderRadius.all(new Radius.circular(10)),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: searchOrder,
                  autofocus: false,
                  onSubmitted: (value) {},
                  cursorColor: Constants.appDarkBlueTextColor,
                  decoration: InputDecoration(
                      hintText: Translations.of(context).strSearchHere,
                      contentPadding: EdgeInsets.only(left: 20, right: 10),
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
                          if (widget.type == Constants.typeOrder) {
                            wsGetOrderList();
                          } else if (widget.type == Constants.typeBooking) {
                            wsGetBookingList();
                          } else if (widget.type == Constants.typeRequest) {
                            wsGetServiceList();
                          }
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

  void searchOrder(String value) {
    if (value.isNotEmpty) {
      if (widget.type == Constants.typeOrder) {
        wsGetOrderList();
      } else if (widget.type == Constants.typeBooking) {
        wsGetBookingList();
      } else if (widget.type == Constants.typeRequest) {
        wsGetServiceList();
      }
    } else {
      setState(() {});
    }
  }

  Widget _allItemsView() {
    List<String> _servicesList = [Translations.of(context).strActive, Translations.of(context).strComplete];

    return DefaultTabController(
        length: _servicesList.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.screenWidth,
              height: 50,
              color: Colors.white,
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    _searchController.text = "";
                    isSelectedCompleted = index == 0 ? false : true;

                    _objOrderDataRowModel = [];
                    _objBookingDataRowModel = [];
                    _objRequestDataRowModel = [];

                    if (widget.type == Constants.typeOrder) {
                      wsGetOrderList();
                    } else if (widget.type == Constants.typeBooking) {
                      wsGetBookingList();
                    } else if (widget.type == Constants.typeRequest) {
                      wsGetServiceList();
                    }
                  });
                },
                isScrollable: true,
                unselectedLabelColor: Constants.appLightBlueTextColor,
                labelColor: Constants.appDarkBlueTextColor,
                indicatorColor: Constants.appAquaTextColor,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                  width: 3.0,
                  color: Constants.appAquaTextColor,
                )),
                tabs: [
                  Container(
                    width: (SizeConfig.screenWidth - 70) / 2,
                    child: WidgetUtils().simpleTextViewWithGivenFontSize(
                        Translations.of(context).strActive,
                        getProportionalScreenWidth(16),
                        Constants.blueColor,
                        "Inter",
                        FontWeight.w500,
                        txtAlign: TextAlign.center),
                  ),
                  Container(
                    width: (SizeConfig.screenWidth - 70) / 2,
                    child: WidgetUtils().simpleTextViewWithGivenFontSize(
                        Translations.of(context).strComplete,
                        getProportionalScreenWidth(16),
                        Constants.blueColor,
                        "Inter",
                        FontWeight.w500,
                        txtAlign: TextAlign.center),
                  )
                ],
              ),
            ),
            (widget.type == Constants.typeOrder)
                ? Expanded(child: orderView())
                : (widget.type == Constants.typeBooking)
                    ? Expanded(child: serviceView())
                    : Expanded(child: requestView()),
          ],
        ));
  }

  Widget orderView() {
    return (_objOrderDataRowModel.isEmpty)
        ? Container(
            height: SizeConfig.screenHeight * 0.75,
            child: WidgetUtils()
                .noDataFoundText(_isShowLoader, Translations.of(context).strNoDataFound, 150, 150))
        : Container(
            color: Constants.appLightBackgroundColor,
            child: RefreshIndicator(
              onRefresh: () => wsGetOrderList(),
              child: ListView.separated(
                //shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    top: 18.0, left: 20.0, right: 20.0, bottom: 20.0),
                itemCount: _objOrderDataRowModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      WidgetUtils().push(
                          context,
                          () => StaffOrderDetails(_objOrderDataRowModel[index],
                              null, null, widget.type ?? ""));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetUtils().simpleTextViewWithGivenFontSize(
                                      _objOrderDataRowModel[index].roomNumber ??
                                          "",
                                      getProportionalScreenWidth(18),
                                      Constants.appDarkBlueTextColor,
                                      "Inter",
                                      FontWeight.w700,
                                      txtAlign: TextAlign.left),
                                  WidgetUtils().simpleTextViewWithGivenFontSize(
                                      userModel.staffHotelId!.currentHotel!.currencySymbol! +  _objOrderDataRowModel[index].totalAmount.toString() ??
                                          "",
                                      getProportionalScreenWidth(18),
                                      Constants.appCobaltBlueTextColor,
                                      "Inter",
                                      FontWeight.w700,
                                      txtAlign: TextAlign.left),
                                ],
                              ),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objOrderDataRowModel[index]
                                          .orderOwner!
                                          .firstName! +
                                      " " +
                                      _objOrderDataRowModel[index]
                                          .orderOwner!
                                          .lastName!,
                                  getProportionalScreenWidth(14),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(15),
                              Container(
                                height: 1.0,
                                color: Constants.appSepratorColor,
                              ),
                              WidgetUtils().sizeBoxHeight(18),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strOrderNumber,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  '#' + _objOrderDataRowModel[index].orderId!,
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(15),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strItems,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objOrderDataRowModel[index].orderItemString,
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),

                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strOrderedOn,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  DateUtilss.dateToString(
                                      DateUtilss.stringToDate(
                                          _objOrderDataRowModel[index]
                                              .createdAt!,
                                          format: AppDateFormat
                                              .serverDateTimeFormat1,
                                          isUTCTime: true)!,
                                      format: AppDateFormat
                                          .notificationFullDateTimeFormat),
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(15),

                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strAdditionalDetail,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objOrderDataRowModel[index].comment ?? "-",
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),

                              !isSelectedCompleted
                                  ? WidgetUtils().sizeBoxHeight(20)
                                  : Container(),
                              !isSelectedCompleted
                                  ? Container(
                                      height: 1.0,
                                      color: Constants.appSepratorColor,
                                    )
                                  : Container(),

                              WidgetUtils().sizeBoxHeight(18),

                              //Estimate Time
                              Visibility(
                                visible: !isSelectedCompleted,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/img_clock.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    WidgetUtils().sizeBoxWidth(5),
                                    WidgetUtils()
                                        .simpleTextViewWithGivenFontSize(
                                        Translations.of(context).strEstTime,
                                            getProportionalScreenWidth(14),
                                            Constants.appLightBlueTextColor,
                                            "Inter",
                                            FontWeight.w400,
                                            txtAlign: TextAlign.left),
                                    WidgetUtils().sizeBoxWidth(5),
                                    WidgetUtils()
                                        .simpleTextViewWithGivenFontSize(
                                            _objOrderDataRowModel[index]
                                                    .expectedTime +
                                                " " +
                                                _objOrderDataRowModel[index]
                                                    .expectedUnit,
                                            getProportionalScreenWidth(14),
                                            Constants.appCobaltBlueTextColor,
                                            "Inter",
                                            FontWeight.w600,
                                            txtAlign: TextAlign.left),
                                  ],
                                ),
                              ),

                              Visibility(
                                child: WidgetUtils().sizeBoxHeight(18),
                                visible: !isSelectedCompleted,
                              ),
                              !isSelectedCompleted
                                  ? Visibility(
                                      child: _buttonsAcceptReject(index),
                                      visible:
                                          _objOrderDataRowModel[index].status ==
                                              Constants.serviceStatusPending)
                                  : Container() //_viewDelivered(index),
                              //WidgetUtils().sizeBoxHeight(10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 15,
                  );
                },
              ),
            ),
          );
  }

  Widget serviceView() {
    return (_objBookingDataRowModel.isEmpty)
        ? Container(
            height: SizeConfig.screenHeight * 0.75,
            child: WidgetUtils()
                .noDataFoundText(_isShowLoader, Translations.of(context).strNoDataFound, 150, 150))
        : Container(
            color: Constants.appLightBackgroundColor,
            child: RefreshIndicator(
              onRefresh: () => wsGetBookingList(),
              child: ListView.separated(
                //shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    top: 18.0, left: 20.0, right: 20.0, bottom: 20.0),
                itemCount: _objBookingDataRowModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      WidgetUtils().push(
                          context,
                          () => StaffOrderDetails(
                              null,
                              _objBookingDataRowModel[index],
                              null,
                              widget.type ?? ""));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetUtils().simpleTextViewWithGivenFontSize(
                                      _objBookingDataRowModel[index].roomNo ??
                                          "",
                                      getProportionalScreenWidth(18),
                                      Constants.appDarkBlueTextColor,
                                      "Inter",
                                      FontWeight.w700,
                                      txtAlign: TextAlign.left),
                                  WidgetUtils().simpleTextViewWithGivenFontSize(
                                      userModel.staffHotelId!.currentHotel!.currencySymbol! +  _objBookingDataRowModel[index].totalAmount.toString() ?? "",
                                      getProportionalScreenWidth(18),
                                      Constants.appCobaltBlueTextColor,
                                      "Inter",
                                      FontWeight.w700,
                                      txtAlign: TextAlign.left),
                                ],
                              ),

                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objBookingDataRowModel[index]
                                          .bookingOwner!
                                          .firstName! +
                                      " " +
                                      _objBookingDataRowModel[index]
                                          .bookingOwner!
                                          .lastName!,
                                  getProportionalScreenWidth(14),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(15),
                              Container(
                                height: 1.0,
                                color: Constants.appSepratorColor,
                              ),
                              WidgetUtils().sizeBoxHeight(18),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strOrderNumber,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  '#' + _objBookingDataRowModel[index].orderId!,
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(15),

                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strService,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objBookingDataRowModel[index]
                                          .premiumServices!
                                          .name! ??
                                      "",
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(15),

                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strPackage,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objBookingDataRowModel[index]
                                      .premiumPackageServices!
                                      .name! ??
                                      "",
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(15),

                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strOrderedOn,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  DateUtilss.dateToString(
                                      DateUtilss.stringToDate(
                                          _objBookingDataRowModel[index]
                                              .createdAt!,
                                          format: AppDateFormat
                                              .serverDateTimeFormat1,
                                          isUTCTime: true)!,
                                      format: AppDateFormat
                                          .notificationFullDateTimeFormat),
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),
                              !isSelectedCompleted
                                  ? Visibility(
                                      visible: _objBookingDataRowModel[index]
                                              .status ==
                                          Constants.serviceStatusPending,
                                      child: WidgetUtils().sizeBoxHeight(20))
                                  : Container(),
                              !isSelectedCompleted
                                  ? Visibility(
                                      visible: _objBookingDataRowModel[index]
                                              .status ==
                                          Constants.serviceStatusPending,
                                      child: Container(
                                        height: 1.0,
                                        color: Constants.appSepratorColor,
                                      ),
                                    )
                                  : Container(),

                              WidgetUtils().sizeBoxHeight(18),
                              !isSelectedCompleted
                                  ? Visibility(
                                      child: _buttonsAcceptReject(index),
                                      visible: _objBookingDataRowModel[index]
                                              .status ==
                                          Constants.serviceStatusPending)
                                  : Container() //_viewDelivered(index),
                              //WidgetUtils().sizeBoxHeight(10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 15,
                  );
                },
              ),
            ),
          );
  }

  Widget requestView() {
    return (_objRequestDataRowModel.isEmpty)
        ? Container(
            height: SizeConfig.screenHeight * 0.75,
            child: WidgetUtils()
                .noDataFoundText(_isShowLoader, Translations.of(context).strNoDataFound, 150, 150))
        : Container(
            color: Constants.appLightBackgroundColor,
            child: RefreshIndicator(
              onRefresh: () => wsGetServiceList(),
              child: ListView.separated(
                //shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    top: 18.0, left: 20.0, right: 20.0, bottom: 20.0),
                itemCount: _objRequestDataRowModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      WidgetUtils().push(
                          context,
                          () => StaffOrderDetails(
                              null,
                              null,
                              _objRequestDataRowModel[index],
                              widget.type ?? ""));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objRequestDataRowModel[index].roomNo ?? "",
                                  getProportionalScreenWidth(18),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w700,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objRequestDataRowModel[index]
                                          .requestOwner!
                                          .firstName! +
                                      " " +
                                      _objRequestDataRowModel[index]
                                          .requestOwner!
                                          .lastName!,
                                  getProportionalScreenWidth(14),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(15),
                              Container(
                                height: 1.0,
                                color: Constants.appSepratorColor,
                              ),
                              WidgetUtils().sizeBoxHeight(18),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strOrderNumber,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  '#' + _objRequestDataRowModel[index].orderId!,
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(15),

                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strService,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objRequestDataRowModel[index]
                                          .hotelRequestSubService!
                                          .name! ??
                                      "",
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(15),

                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strOrderedOn,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  DateUtilss.dateToString(
                                      DateUtilss.stringToDate(
                                          _objRequestDataRowModel[index]
                                              .createdAt!,
                                          format: AppDateFormat
                                              .serverDateTimeFormat1,
                                          isUTCTime: true)!,
                                      format: AppDateFormat
                                          .notificationFullDateTimeFormat),
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),

                              WidgetUtils().sizeBoxHeight(15),

                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strAdditionalDetail,
                                  getProportionalScreenWidth(12),
                                  Constants.appLightBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  txtAlign: TextAlign.left),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objRequestDataRowModel[index]
                                          .requestedText ??
                                      "-",
                                  getProportionalScreenWidth(13),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w600,
                                  txtAlign: TextAlign.left),

                              !isSelectedCompleted
                                  ? Visibility(
                                      visible: _objRequestDataRowModel[index]
                                              .status ==
                                          Constants.serviceStatusPending,
                                      child: WidgetUtils().sizeBoxHeight(20))
                                  : Container(),
                              !isSelectedCompleted
                                  ? Visibility(
                                      visible: _objRequestDataRowModel[index]
                                              .status ==
                                          Constants.serviceStatusPending,
                                      child: Container(
                                        height: 1.0,
                                        color: Constants.appSepratorColor,
                                      ),
                                    )
                                  : Container(),

                              WidgetUtils().sizeBoxHeight(18),
                              !isSelectedCompleted
                                  ? Visibility(
                                      child: _buttonsAcceptReject(index),
                                      visible: _objRequestDataRowModel[index]
                                              .status ==
                                          Constants.serviceStatusPending)
                                  : Container() //_viewDelivered(index),
                              //WidgetUtils().sizeBoxHeight(10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 15,
                  );
                },
              ),
            ),
          );
  }

  Widget _buttonsAcceptReject(int index) {
    return Row(
      children: [
        Expanded(
          child: WidgetUtils().buttonSimpleText(
              Translations.of(context).btnAccept, "Inter", getProportionalScreenWidth(16), Colors.white,
              () {
            if (widget.type == Constants.typeOrder) {
              wsAcceptOrder(_objOrderDataRowModel[index].id!);
            } else if (widget.type == Constants.typeBooking) {
              wsAcceptBooking(_objBookingDataRowModel[index].id!);
            } else if (widget.type == Constants.typeRequest) {
              wsAcceptRequest(_objRequestDataRowModel[index].id!);
            }
          }, FontWeight.w600,
              bgColor: Constants.appGreenColor,
              cornerRadius: 50.0,
              isRoundedCorners: true),
        ),
        WidgetUtils().sizeBoxWidth(10),
        Expanded(
          child: WidgetUtils().buttonSimpleText(Translations.of(context).btnDecline, "Inter",
              getProportionalScreenWidth(16), Constants.appRedColor, () {
            _displayTextInputDialog(context, index);
          }, FontWeight.w600,
              cornerRadius: 50.0, isRoundedCorners: true, isShowBorder: true),
        )
      ],
    );
  }

  Widget _viewDelivered(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        WidgetUtils().simpleTextViewWithGivenFontSize(
            Translations.of(context).strOrderedOn,
            getProportionalScreenWidth(12),
            Constants.appLightBlueTextColor,
            "Inter",
            FontWeight.w400,
            txtAlign: TextAlign.left),
        WidgetUtils().sizeBoxHeight(5),
        WidgetUtils().simpleTextViewWithGivenFontSize(
            DateUtilss.dateToString(
                DateUtilss.stringToDate(_objOrderDataRowModel[index].createdAt!,
                    format: AppDateFormat.serverDateTimeFormat1,
                    isUTCTime: true)!,
                format: AppDateFormat.notificationFullDateTimeFormat),
            getProportionalScreenWidth(13),
            Constants.appDarkBlueTextColor,
            "Inter",
            FontWeight.w600,
            txtAlign: TextAlign.left),
        WidgetUtils().sizeBoxHeight(10),
      ],
    );
  }

  Future<void> wsGetOrderList() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();

    map["hotel_id"] = userModel.staffHotelId!.hotelId;
    map["is_complated"] = isSelectedCompleted;
    map["search_string"] = _searchController.text.toString();

    APICall(context).getOrderList(map, this);
  }

  Future<void> wsGetServiceList() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();

    map["hotel_id"] = userModel.staffHotelId!.hotelId;
    map["is_complated"] = isSelectedCompleted;
    map["filter"] = [widget.id];
    map["search_string"] = _searchController.text.toString();

    APICall(context).getServiceList(map, this);
  }

  Future<void> wsGetBookingList() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();

    map["hotel_id"] = userModel.staffHotelId!.hotelId;
    map["is_complated"] = isSelectedCompleted;
    map["search_string"] = _searchController.text.toString();

    APICall(context).getBookingList(map, this);
  }

  Future<void> wsAcceptOrder(int id) async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoaderAcceptDecline = true;
    });

    var map = Map();

    map["order_id"] = id.toString();

    APICall(context).acceptOrderApi(map, this);
  }

  Future<void> wsRejectOrder(int id) async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoaderAcceptDecline = true;
    });

    var map = Map();

    map["order_id"] = id.toString();
    map["rejected_reason"] = _reasonController.text.toString();

    APICall(context).rejectOrderApi(map, this);
  }

  Future<void> wsAcceptBooking(int id) async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoaderAcceptDecline = true;
    });

    var map = Map();

    map["booking_id"] = id.toString();
    map["hotel_id"] = userModel.staffHotelId!.hotelId;

    APICall(context).acceptBookingApi(map, this);
  }

  Future<void> wsRejectBooking(int id) async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoaderAcceptDecline = true;
    });

    var map = Map();

    map["booking_id"] = id.toString();
    map["hotel_id"] = userModel.staffHotelId!.hotelId;
    map["rejected_reason"] = _reasonController.text.toString();

    APICall(context).rejectBookingApi(map, this);
  }

  Future<void> wsAcceptRequest(int id) async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoaderAcceptDecline = true;
    });

    var map = Map();

    map["request_id"] = id.toString();
    map["hotel_id"] = userModel.staffHotelId!.hotelId;

    APICall(context).acceptRequestApi(map, this);
  }

  Future<void> wsRejectRequest(int id) async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoaderAcceptDecline = true;
    });

    var map = Map();

    map["request_id"] = id.toString();
    map["hotel_id"] = userModel.staffHotelId!.hotelId;
    map["rejection_reason"] = _reasonController.text.toString();

    APICall(context).rejectRequestApi(map, this);
  }

  Future<void> _displayTextInputDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Translations.of(context).strDeclineRequest),
            content: TextField(
              maxLines: 4,
              onChanged: (value) {
                setState(() {
                  //_reasonText = value;
                });
              },
              controller: _reasonController,
              decoration: InputDecoration(hintText: Translations.of(context).strEnterReason),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                child: Text(Translations.of(context).btnCancel),
                onPressed: () {
                  setState(() {
                    _reasonController.text = "";
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('Submit'),
                onPressed: () {
                  setState(() {
                    if (_reasonController.text.isEmpty) {
                      WidgetUtils()
                          .customToastMsg(Translations.of(context).strPleaseEnterRejectionReason);
                      return;
                    }
                    Navigator.pop(context);

                    if (widget.type == Constants.typeOrder) {
                      wsRejectOrder(_objOrderDataRowModel[index].id!);
                    } else if (widget.type == Constants.typeBooking) {
                      wsRejectBooking(_objBookingDataRowModel[index].id!);
                    } else if (widget.type == Constants.typeRequest) {
                      wsRejectRequest(_objRequestDataRowModel[index].id!);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  void onResponseError(String message, int requestCode) {
    setState(() {
      _isShowLoader = false;
      _isShowLoaderAcceptDecline = false;
    });
    WidgetUtils().customToastMsg(message);
  }

  @override
  void onResponseReceived(response, int requestCode) {
    if (requestCode == API.requestOrderList && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var orderListModel = MyRequestListModel.fromJson(response);

      if (orderListModel.code! == 200) {
        setState(() {
          _objOrderDataRowModel = orderListModel.data!.rows!;
        });
      } else {
        WidgetUtils().customToastMsg(orderListModel.msg!);
      }
    } else if (requestCode == API.requestServiceList && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var requestListModel = RequestListModel.fromJson(response);

      if (requestListModel.code! == 200) {
        setState(() {
          _objRequestDataRowModel = requestListModel.data!.rows!;
        });
      } else {
        WidgetUtils().customToastMsg(requestListModel.msg!);
      }
    } else if (requestCode == API.requestBookingList && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var bookingListModel = BookingListModel.fromJson(response);

      if (bookingListModel.code! == 200) {
        setState(() {
          _objBookingDataRowModel = bookingListModel.data!.rows!;
        });
      } else {
        WidgetUtils().customToastMsg(bookingListModel.msg!);
      }
    } else if (requestCode == API.requestAcceptOrder && this.mounted) {
      setState(() {
        _isShowLoaderAcceptDecline = false;
      });

      var baseResponse = BaseResponseModel.fromJson(response);

      if (baseResponse.code! == 200) {
        setState(() {});
        WidgetUtils().customToastMsg(baseResponse.msg!);
        if (widget.type == Constants.typeOrder) {
          wsGetOrderList();
        } else if (widget.type == Constants.typeBooking) {
          wsGetBookingList();
        } else if (widget.type == Constants.typeRequest) {
          wsGetServiceList();
        }
      } else {
        WidgetUtils().customToastMsg(baseResponse.msg!);
        if (widget.type == Constants.typeOrder) {
          wsGetOrderList();
        } else if (widget.type == Constants.typeBooking) {
          wsGetBookingList();
        } else if (widget.type == Constants.typeRequest) {
          wsGetServiceList();
        }
      }
    } else if (requestCode == API.requestRejectOrder && this.mounted) {
      setState(() {
        _isShowLoaderAcceptDecline = false;
      });

      var baseResponse = BaseResponseModel.fromJson(response);

      if (baseResponse.code! == 200) {
        setState(() {});
        WidgetUtils().customToastMsg(baseResponse.msg!);
        if (widget.type == Constants.typeOrder) {
          wsGetOrderList();
        } else if (widget.type == Constants.typeBooking) {
          wsGetBookingList();
        } else if (widget.type == Constants.typeRequest) {
          wsGetServiceList();
        }
      } else {
        WidgetUtils().customToastMsg(baseResponse.msg!);
        if (widget.type == Constants.typeOrder) {
          wsGetOrderList();
        } else if (widget.type == Constants.typeBooking) {
          wsGetBookingList();
        } else if (widget.type == Constants.typeRequest) {
          wsGetServiceList();
        }
      }
    } else if (requestCode == API.requestAcceptBooking && this.mounted) {
      setState(() {
        _isShowLoaderAcceptDecline = false;
      });

      var baseResponse = BaseResponseModel.fromJson(response);

      if (baseResponse.code! == 200) {
        setState(() {});
        WidgetUtils().customToastMsg(baseResponse.msg!);
        if (widget.type == Constants.typeOrder) {
          wsGetOrderList();
        } else if (widget.type == Constants.typeBooking) {
          wsGetBookingList();
        } else if (widget.type == Constants.typeRequest) {
          wsGetServiceList();
        }
      } else {
        WidgetUtils().customToastMsg(baseResponse.msg!);
        if (widget.type == Constants.typeOrder) {
          wsGetOrderList();
        } else if (widget.type == Constants.typeBooking) {
          wsGetBookingList();
        } else if (widget.type == Constants.typeRequest) {
          wsGetServiceList();
        }
      }
    } else if (requestCode == API.requestRejectBooking && this.mounted) {
      setState(() {
        _isShowLoaderAcceptDecline = false;
      });

      var baseResponse = BaseResponseModel.fromJson(response);

      if (baseResponse.code! == 200) {
        setState(() {});
        WidgetUtils().customToastMsg(baseResponse.msg!);
        if (widget.type == Constants.typeOrder) {
          wsGetOrderList();
        } else if (widget.type == Constants.typeBooking) {
          wsGetBookingList();
        } else if (widget.type == Constants.typeRequest) {
          wsGetServiceList();
        }
      } else {
        WidgetUtils().customToastMsg(baseResponse.msg!);
        if (widget.type == Constants.typeOrder) {
          wsGetOrderList();
        } else if (widget.type == Constants.typeBooking) {
          wsGetBookingList();
        } else if (widget.type == Constants.typeRequest) {
          wsGetServiceList();
        }
      }
    } else if (requestCode == API.requestAcceptRequest && this.mounted) {
      setState(() {
        _isShowLoaderAcceptDecline = false;
      });

      var baseResponse = BaseResponseModel.fromJson(response);

      if (baseResponse.code! == 200) {
        setState(() {});
        WidgetUtils().customToastMsg(baseResponse.msg!);

        if (widget.type == Constants.typeOrder) {
          wsGetOrderList();
        } else if (widget.type == Constants.typeBooking) {
          wsGetBookingList();
        } else if (widget.type == Constants.typeRequest) {
          wsGetServiceList();
        }
      } else {
        WidgetUtils().customToastMsg(baseResponse.msg!);
      }
    } else if (requestCode == API.requestRejectRequest && this.mounted) {
      setState(() {
        _isShowLoaderAcceptDecline = false;
      });

      var baseResponse = BaseResponseModel.fromJson(response);

      if (baseResponse.code! == 200) {
        setState(() {});
        WidgetUtils().customToastMsg(baseResponse.msg!);

        if (widget.type == Constants.typeOrder) {
          wsGetOrderList();
        } else if (widget.type == Constants.typeBooking) {
          wsGetBookingList();
        } else if (widget.type == Constants.typeRequest) {
          wsGetServiceList();
        }
      } else {
        WidgetUtils().customToastMsg(baseResponse.msg!);
      }
    }
  }
}
