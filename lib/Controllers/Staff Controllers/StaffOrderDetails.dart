import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/Staff%20Controllers/ComplaintDetail.dart';
import 'package:hamrostay/Controllers/Staff%20Controllers/OrderStatusPopup.dart';
import 'package:hamrostay/Controllers/Staff%20Controllers/RequestStatusPopup.dart';
import 'package:hamrostay/Models/RequestDetailResponseModel.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';

import '../../Models/BookingDetailResponseModel.dart';
import '../../Models/BookingListModel.dart';
import '../../Models/MyOrderListModel.dart';
import '../../Models/OrderComplaintResponseModel.dart';
import '../../Models/OrderDetailResponseModel.dart';
import '../../Models/RequestListModel.dart';
import '../../Models/UserModel.dart';
import '../../Utils/API.dart';
import '../../Utils/APICall.dart';
import '../../Utils/app_date_format.dart';
import '../../Utils/date_utils.dart';
import '../../localization/localization.dart';
import 'BookingStatusPopup.dart';
import 'CancellationDetail.dart';

class StaffOrderDetails extends StatefulWidget {
  StaffOrderDetails(this.objOrderDataRowModel, this.objBookingDataRowModel,
      this.objRequestDataRowModel, this.type,
      {Key? key})
      : super(key: key);

  OrderListRows? objOrderDataRowModel;
  BookingListRows? objBookingDataRowModel;
  RequestListRows? objRequestDataRowModel;
  String type;

  @override
  _StaffOrderDetailsState createState() => _StaffOrderDetailsState();
}

class _StaffOrderDetailsState extends State<StaffOrderDetails>
    implements OnResponseCallback {
  var _isShowLoader = false;
  OrderDetailData orderDetailData = OrderDetailData();
  RequestDetailData requestDetailData = RequestDetailData();
  BookingDetailData bookingDetailData = BookingDetailData();
  var userModel = UserData();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 5),() async {
      userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;
    });

    if (widget.type == Constants.typeOrder) {
      wsGetOrderDetail();
    } else if (widget.type == Constants.typeBooking) {
      wsGetBookingDetail();
    } else if (widget.type == Constants.typeRequest) {
      wsGetRequestDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.appLightBackgroundColor,
        appBar: WidgetUtils().customAppBar(
          context,
          (widget.type == Constants.typeOrder)
              ? (orderDetailData.id != null)
                  ? '#' + orderDetailData.orderId!
                  : ""
              : (widget.type == Constants.typeBooking)
              ? (bookingDetailData.id != null)
              ? '#' + bookingDetailData.orderId!
              : ""
              :(requestDetailData.id != null)
                  ? '#' + requestDetailData.orderId!
                  : "",
          'assets/images/btn_back.png',
          Colors.white,
          () {
            Navigator.of(context).pop();
          },
          imgColor: Colors.white,
        ),
        body: Material(
          child: SafeArea(
            top: false,
            bottom: false,
            left: false,
            child: (orderDetailData.id != null ||
                    requestDetailData.id != null ||
                    bookingDetailData.id != null)
                ? _getBodyView()
                : Container(
                    height: SizeConfig.screenHeight * 0.75,
                    child: WidgetUtils().noDataFoundText(
                        _isShowLoader, Translations.of(context).strNoDataFound, 150, 150)),
          ),
        ));
  }

  Widget _getBodyView() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: SizeConfig.screenWidth,
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
                                (widget.type == Constants.typeOrder)
                                    ? orderDetailData.roomNumber!
                                    : (widget.type == Constants.typeRequest)
                                    ? requestDetailData.roomNo!
                                    : bookingDetailData.roomNo!,
                                getProportionalScreenWidth(18),
                                Constants.appDarkBlueTextColor,
                                "Inter",
                                FontWeight.w700,
                                txtAlign: TextAlign.left),
                            WidgetUtils().simpleTextViewWithGivenFontSize(
                                (widget.type == Constants.typeOrder)
                                    ? userModel.staffHotelId!.currentHotel!.currencySymbol! + orderDetailData.totalAmount!
                                    : (widget.type == Constants.typeRequest)
                                    ? ""
                                    : bookingDetailData.amountUnit! + bookingDetailData.totalAmount!,
                                getProportionalScreenWidth(18),
                                Constants.appCobaltBlueTextColor,
                                "Inter",
                                FontWeight.w700,
                                txtAlign: TextAlign.left)
                          ],
                        ),
                        WidgetUtils().sizeBoxHeight(5),
                        WidgetUtils().simpleTextViewWithGivenFontSize(
                            (widget.type == Constants.typeOrder)
                                ? orderDetailData.orderOwner!.firstName! +
                                    " " +
                                    orderDetailData.orderOwner!.lastName!
                                : (widget.type == Constants.typeRequest)
                                    ? requestDetailData
                                            .requestOwner!.firstName! +
                                        " " +
                                        requestDetailData
                                            .requestOwner!.lastName!
                                    : bookingDetailData
                                            .bookingOwner!.firstName! +
                                        " " +
                                        bookingDetailData
                                            .bookingOwner!.lastName!,
                            getProportionalScreenWidth(14),
                            Constants.appDarkBlueTextColor,
                            "Inter",
                            FontWeight.w400,
                            txtAlign: TextAlign.left),
                        WidgetUtils().sizeBoxHeight(15),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 8.0,
                  color: Constants.appTagBackgroundColor,
                ),
                (widget.type == Constants.typeOrder)
                    ? _viewOrderStatus()
                    : (widget.type == Constants.typeBooking)
                        ? _viewBookingStatus()
                        : _viewRequestStatus(),
                Container(
                  height: 8.0,
                  color: Constants.appTagBackgroundColor,
                ),
                (widget.type == Constants.typeOrder)
                    ? _viewOrderDetails()
                    : (widget.type == Constants.typeBooking)
                        ? _viewBookingDetails()
                        : _viewRequestDetails(),
              ],
            ),
            (widget.type == Constants.typeOrder)
                ? (orderDetailData.orderComplaints != null)
                    ? _viewComplaintDetails()
                    : Container()
                : (widget.type == Constants.typeBooking)
                    ? (bookingDetailData.bookingComplaints != null)
                        ? _viewComplaintDetails()
                        : Container()
                    : (requestDetailData.requestComplaints != null)
                        ? _viewComplaintDetails()
                        : Container(),

            //WidgetUtils().sizeBoxHeight(10),
            (widget.type == Constants.typeOrder)
                ? (orderDetailData.cancelOrders != null)
                    ? _viewCancellationDetails()
                    : Container()
                : (widget.type == Constants.typeBooking)
                    ? (bookingDetailData.cancelBookings != null)
                        ? _viewCancellationDetails()
                        : Container()
                    : (requestDetailData.cancelRequests != null)
                        ? _viewCancellationDetails()
                        : Container()
          ],
        ),
      ),
    );
  }

  Widget _viewOrderStatus() {
    return Container(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                    child: WidgetUtils().simpleTextViewWithGivenFontSize(
                        Translations.of(context).strOrderStatus,
                        getProportionalScreenWidth(18),
                        Constants.appDarkBlueTextColor,
                        "Inter",
                        FontWeight.w600,
                        txtAlign: TextAlign.left)),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    var result = await showDialog(
                        context: context,
                        builder: (context) =>
                            OrderStatusPopup(orderDetailData.id.toString()),
                        useSafeArea: false);

                    if (result) {
                      if (widget.type == Constants.typeOrder) {
                        wsGetOrderDetail();
                      } else if (widget.type == Constants.typeBooking) {
                        wsGetBookingDetail();
                      } else if (widget.type == Constants.typeRequest) {
                        wsGetRequestDetail();
                      }
                    }
                  },
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                      Translations.of(context).strUpdateStatus,
                      getProportionalScreenWidth(14),
                      Color.fromRGBO(84, 104, 255, 1.0),
                      "Inter",
                      FontWeight.w500,
                      txtAlign: TextAlign.right,
                      isUnderlinedText: true),
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    (orderDetailData.status == Constants.serviceStatusPending)
                        ? 'assets/images/img_order_completed.png'
                        : 'assets/images/img_order_accepted.png',
                    height: SizeConfig.screenWidth * 0.06,
                    width: SizeConfig.screenWidth * 0.06,
                  ),
                  Expanded(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.3,
                      height: 2.0,
                      color: (orderDetailData.status ==
                                  Constants.serviceStatusInProgress ||
                              orderDetailData.status ==
                                  Constants.serviceStatusCompleted)
                          ? Constants.appStatusGreenColor
                          : Constants.dividerColor,
                    ),
                  ),
                  Image.asset(
                    (orderDetailData.status ==
                            Constants.serviceStatusInProgress)
                        ? 'assets/images/img_order_preparing.png'
                        : (orderDetailData.status ==
                                Constants.serviceStatusCompleted)
                            ? 'assets/images/img_order_accepted.png'
                            : 'assets/images/img_order_completed.png',
                    height: SizeConfig.screenWidth * 0.06,
                    width: SizeConfig.screenWidth * 0.06,
                  ),
                  Expanded(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.3,
                      height: 2.0,
                      color: (orderDetailData.status ==
                              Constants.serviceStatusCompleted)
                          ? Constants.appStatusGreenColor
                          : Constants.dividerColor,
                    ),
                  ),
                  Image.asset(
                    (orderDetailData.status == Constants.serviceStatusCompleted)
                        ? 'assets/images/img_order_accepted.png'
                        : 'assets/images/img_order_completed.png',
                    height: SizeConfig.screenWidth * 0.06,
                    width: SizeConfig.screenWidth * 0.06,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strOrderNewAccepted,
                    getProportionalScreenWidth(14),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w500,
                    txtAlign: TextAlign.center),
                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strOrderNewPreparing,
                    getProportionalScreenWidth(14),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w500,
                    txtAlign: TextAlign.center),
                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strOrderNewCompleted,
                    getProportionalScreenWidth(14),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w500,
                    txtAlign: TextAlign.center)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _viewBookingStatus() {
    return Container(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                    child: WidgetUtils().simpleTextViewWithGivenFontSize(
                        Translations.of(context).strServiceStatus,
                        getProportionalScreenWidth(18),
                        Constants.appDarkBlueTextColor,
                        "Inter",
                        FontWeight.w600,
                        txtAlign: TextAlign.left)),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    var result = await showDialog(
                        context: context,
                        builder: (context) =>
                            BookingStatusPopup(bookingDetailData.id.toString()),
                        useSafeArea: false);

                    if (result) {
                      if (widget.type == Constants.typeOrder) {
                        wsGetOrderDetail();
                      } else if (widget.type == Constants.typeBooking) {
                        wsGetBookingDetail();
                      } else if (widget.type == Constants.typeRequest) {
                        wsGetRequestDetail();
                      }
                    }
                  },
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                      Translations.of(context).strUpdateStatus,
                      getProportionalScreenWidth(14),
                      Color.fromRGBO(84, 104, 255, 1.0),
                      "Inter",
                      FontWeight.w500,
                      txtAlign: TextAlign.right,
                      isUnderlinedText: true),
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    (bookingDetailData.status == Constants.serviceStatusPending)
                        ? 'assets/images/img_order_completed.png'
                        : 'assets/images/img_order_accepted.png',
                    height: SizeConfig.screenWidth * 0.06,
                    width: SizeConfig.screenWidth * 0.06,
                  ),
                  Expanded(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.3,
                      height: 2.0,
                      color: (bookingDetailData.status ==
                                  Constants.serviceStatusInProgress ||
                              bookingDetailData.status ==
                                  Constants.serviceStatusCompleted)
                          ? Constants.appStatusGreenColor
                          : Constants.dividerColor,
                    ),
                  ),
                  Image.asset(
                    (bookingDetailData.status ==
                            Constants.serviceStatusInProgress)
                        ? 'assets/images/img_order_preparing.png'
                        : (bookingDetailData.status ==
                                Constants.serviceStatusCompleted)
                            ? 'assets/images/img_order_accepted.png'
                            : 'assets/images/img_order_completed.png',
                    height: SizeConfig.screenWidth * 0.06,
                    width: SizeConfig.screenWidth * 0.06,
                  ),
                  Expanded(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.3,
                      height: 2.0,
                      color: (bookingDetailData.status ==
                              Constants.serviceStatusCompleted)
                          ? Constants.appStatusGreenColor
                          : Constants.dividerColor,
                    ),
                  ),
                  Image.asset(
                    (bookingDetailData.status ==
                            Constants.serviceStatusCompleted)
                        ? 'assets/images/img_order_accepted.png'
                        : 'assets/images/img_order_completed.png',
                    height: SizeConfig.screenWidth * 0.06,
                    width: SizeConfig.screenWidth * 0.06,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strServiceNewAccepted,
                    getProportionalScreenWidth(14),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w500,
                    txtAlign: TextAlign.center),
                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strServiceNewInProgress,
                    getProportionalScreenWidth(14),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w500,
                    txtAlign: TextAlign.center),
                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strServiceNewCompleted,
                    getProportionalScreenWidth(14),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w500,
                    txtAlign: TextAlign.center)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _viewRequestStatus() {
    return Container(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                    child: WidgetUtils().simpleTextViewWithGivenFontSize(
                        Translations.of(context).strRequestStatus,
                        getProportionalScreenWidth(18),
                        Constants.appDarkBlueTextColor,
                        "Inter",
                        FontWeight.w600,
                        txtAlign: TextAlign.left)),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    var result = await showDialog(
                        context: context,
                        builder: (context) =>
                            RequestStatusPopup(requestDetailData.id.toString()),
                        useSafeArea: false);

                    if (result) {
                      if (widget.type == Constants.typeOrder) {
                        wsGetOrderDetail();
                      } else if (widget.type == Constants.typeBooking) {
                        wsGetBookingDetail();
                      } else if (widget.type == Constants.typeRequest) {
                        wsGetRequestDetail();
                      }
                    }
                  },
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                      Translations.of(context).strUpdateStatus,
                      getProportionalScreenWidth(14),
                      Color.fromRGBO(84, 104, 255, 1.0),
                      "Inter",
                      FontWeight.w500,
                      txtAlign: TextAlign.right,
                      isUnderlinedText: true),
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    (requestDetailData.status == Constants.serviceStatusPending)
                        ? 'assets/images/img_order_completed.png'
                        : 'assets/images/img_order_accepted.png',
                    height: SizeConfig.screenWidth * 0.06,
                    width: SizeConfig.screenWidth * 0.06,
                  ),
                  Expanded(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.3,
                      height: 2.0,
                      color: (requestDetailData.status ==
                                  Constants.serviceStatusInProgress ||
                              requestDetailData.status ==
                                  Constants.serviceStatusCompleted)
                          ? Constants.appStatusGreenColor
                          : Constants.dividerColor,
                    ),
                  ),
                  Image.asset(
                    (requestDetailData.status ==
                            Constants.serviceStatusInProgress)
                        ? 'assets/images/img_order_preparing.png'
                        : (requestDetailData.status ==
                                Constants.serviceStatusCompleted)
                            ? 'assets/images/img_order_accepted.png'
                            : 'assets/images/img_order_completed.png',
                    height: SizeConfig.screenWidth * 0.06,
                    width: SizeConfig.screenWidth * 0.06,
                  ),
                  Expanded(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.3,
                      height: 2.0,
                      color: (requestDetailData.status ==
                              Constants.serviceStatusCompleted)
                          ? Constants.appStatusGreenColor
                          : Constants.dividerColor,
                    ),
                  ),
                  Image.asset(
                    (requestDetailData.status ==
                            Constants.serviceStatusCompleted)
                        ? 'assets/images/img_order_accepted.png'
                        : 'assets/images/img_order_completed.png',
                    height: SizeConfig.screenWidth * 0.06,
                    width: SizeConfig.screenWidth * 0.06,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strRequestNewAccepted,
                    getProportionalScreenWidth(14),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w500,
                    txtAlign: TextAlign.center),
                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strRequestNewInProgress,
                    getProportionalScreenWidth(14),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w500,
                    txtAlign: TextAlign.center),
                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strRequestNewCompleted,
                    getProportionalScreenWidth(14),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w500,
                    txtAlign: TextAlign.center)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _viewOrderDetails() {
    return Container(
        width: SizeConfig.screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strOrderNumber,
                  getProportionalScreenWidth(12),
                  Constants.appLightBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(5),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  '#' + orderDetailData.orderId!,
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
                  orderDetailData.orderItemString,
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
                      DateUtilss.stringToDate(orderDetailData.createdAt!,
                          format: AppDateFormat.serverDateTimeFormat1,
                          isUTCTime: true)!,
                      format: AppDateFormat.notificationFullDateTimeFormat),
                  getProportionalScreenWidth(13),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(15),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strEstimatedTime,
                  getProportionalScreenWidth(12),
                  Constants.appLightBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(5),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  orderDetailData.expectedTime! +
                      " " +
                      orderDetailData.expectedUnit!,
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
                  orderDetailData.comment ?? "-",
                  getProportionalScreenWidth(13),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(10),
            ],
          ),
        ));
  }

  Widget _viewRequestDetails() {
    return Container(
        width: SizeConfig.screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strOrderNumber,
                  getProportionalScreenWidth(12),
                  Constants.appLightBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(5),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  '#' + requestDetailData.orderId!,
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
                  requestDetailData.subCategory!.name! ?? "",
                  getProportionalScreenWidth(13),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(15),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strRequestOn,
                  getProportionalScreenWidth(12),
                  Constants.appLightBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(5),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  DateUtilss.dateToString(
                      DateUtilss.stringToDate(requestDetailData.createdAt!,
                          format: AppDateFormat.serverDateTimeFormat1,
                          isUTCTime: true)!,
                      format: AppDateFormat.notificationFullDateTimeFormat),
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
                  requestDetailData.requestedText ?? "-",
                  getProportionalScreenWidth(13),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(10),
            ],
          ),
        ));
  }

  Widget _viewBookingDetails() {
    return Container(
        width: SizeConfig.screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strOrderNumber,
                  getProportionalScreenWidth(12),
                  Constants.appLightBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(5),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  '#' + bookingDetailData.orderId!,
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
                  bookingDetailData.premiumServices!.name! ?? "",
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
                  bookingDetailData.premiumPackageServices!.name! ?? "",
                  getProportionalScreenWidth(13),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(15),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strSlotTime,
                  getProportionalScreenWidth(12),
                  Constants.appLightBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(5),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  bookingDetailData.premiumPackageServices!.slotDetail!.startTime! + " - " +bookingDetailData.premiumPackageServices!.slotDetail!.startTime!,
                  getProportionalScreenWidth(13),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(15),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strNoOfPerson,
                  getProportionalScreenWidth(12),
                  Constants.appLightBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(5),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  bookingDetailData.noOfPerson.toString() + Translations.of(context).strPerson,
                  getProportionalScreenWidth(13),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(15),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strRequestOn,
                  getProportionalScreenWidth(12),
                  Constants.appLightBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(5),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  DateUtilss.dateToString(
                      DateUtilss.stringToDate(bookingDetailData.createdAt!,
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
          ),
        ));
  }

  Widget _viewComplaintDetails() {
    return Container(
        padding: const EdgeInsets.all(10.0),
        color: Constants.appTagBackgroundColor,
        width: SizeConfig.screenWidth,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strComplaints,
                  getProportionalScreenWidth(18),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w700),
              WidgetUtils().sizeBoxHeight(15),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      var id = (widget.type == Constants.typeOrder)
                          ? orderDetailData.orderComplaints!.id
                          : (widget.type == Constants.typeRequest)
                              ? requestDetailData.requestComplaints!.id
                              : bookingDetailData.bookingComplaints!.id;
                      var comment = (widget.type == Constants.typeOrder)
                          ? orderDetailData.orderComplaints!.comment
                          : (widget.type == Constants.typeRequest)
                              ? requestDetailData.requestComplaints!.comment
                              : bookingDetailData.bookingComplaints!.comment;
                      var orderId = (widget.type == Constants.typeOrder)
                          ? orderDetailData.orderId
                          : (widget.type == Constants.typeRequest)
                              ? requestDetailData.orderId
                              : bookingDetailData.orderId;
                      var status = (widget.type == Constants.typeOrder)
                          ? orderDetailData.orderComplaints!.status
                          : (widget.type == Constants.typeRequest)
                              ? requestDetailData.requestComplaints!.status
                              : bookingDetailData.bookingComplaints!.status;

                      var result = await Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ComplaintDetail(
                            Rows(
                                id: id,
                                comment: comment,
                                orderId: orderId,
                                status: status),
                            widget.type);
                      }));

                      if (result == true) {
                        if (widget.type == Constants.typeOrder) {
                          wsGetOrderDetail();
                        } else if (widget.type == Constants.typeBooking) {
                          wsGetBookingDetail();
                        } else if (widget.type == Constants.typeRequest) {
                          wsGetRequestDetail();
                        }
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                        color:
                                            (widget.type == Constants.typeOrder)
                                                ? orderDetailData
                                                    .orderComplaints!
                                                    .currentStatusColor
                                                : (widget.type ==
                                                        Constants.typeRequest)
                                                    ? requestDetailData
                                                        .requestComplaints!
                                                        .currentStatusColor
                                                    : bookingDetailData
                                                        .bookingComplaints!
                                                        .currentStatusColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                  ),
                                  WidgetUtils().sizeBoxWidth(5),
                                  WidgetUtils().simpleTextViewWithGivenFontSize(
                                      (widget.type == Constants.typeOrder)
                                          ? orderDetailData
                                              .orderComplaints!.currentStatus
                                          : (widget.type ==
                                                  Constants.typeRequest)
                                              ? requestDetailData
                                                  .requestComplaints!
                                                  .currentStatus
                                              : bookingDetailData
                                                  .bookingComplaints!
                                                  .currentStatus,
                                      getProportionalScreenWidth(12),
                                      (widget.type == Constants.typeOrder)
                                          ? orderDetailData.orderComplaints!
                                              .currentStatusColor
                                          : (widget.type ==
                                                  Constants.typeRequest)
                                              ? requestDetailData
                                                  .requestComplaints!
                                                  .currentStatusColor
                                              : bookingDetailData
                                                  .bookingComplaints!
                                                  .currentStatusColor,
                                      "Inter",
                                      FontWeight.w600,
                                      txtAlign: TextAlign.left)
                                ],
                              ),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  (widget.type == Constants.typeOrder)
                                      ? orderDetailData
                                              .orderComplaints!.comment ??
                                          ""
                                      : (widget.type == Constants.typeRequest)
                                          ? requestDetailData
                                                  .requestComplaints!.comment ??
                                              ""
                                          : bookingDetailData
                                                  .bookingComplaints!.comment ??
                                              "",
                                  getProportionalScreenWidth(16),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w700,
                                  txtAlign: TextAlign.left)
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
              )
            ]));
  }

  Widget _viewCancellationDetails() {
    return Container(
        padding: const EdgeInsets.all(10.0),
        color: Constants.appTagBackgroundColor,
        width: SizeConfig.screenWidth,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strCancellation,
                  getProportionalScreenWidth(18),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w700),
              WidgetUtils().sizeBoxHeight(15),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      var id = (widget.type == Constants.typeOrder)
                          ? orderDetailData.cancelOrders!.id
                          : (widget.type == Constants.typeRequest)
                              ? requestDetailData.cancelRequests!.id
                              : bookingDetailData.cancelBookings!.id;
                      var comment = (widget.type == Constants.typeOrder)
                          ? orderDetailData.cancelOrders!.reason
                          : (widget.type == Constants.typeRequest)
                              ? requestDetailData.cancelRequests!.reason
                              : bookingDetailData.cancelBookings!.reason;
                      var orderId = (widget.type == Constants.typeOrder)
                          ? orderDetailData.orderId
                          : (widget.type == Constants.typeRequest)
                              ? requestDetailData.orderId
                              : bookingDetailData.orderId;
                      var status = (widget.type == Constants.typeOrder)
                          ? orderDetailData.cancelOrders!.status
                          : (widget.type == Constants.typeRequest)
                              ? requestDetailData.cancelRequests!.status
                              : bookingDetailData.cancelBookings!.status;

                      var result = await Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return CancellationDetail(
                            Rows(
                                id: id,
                                comment: comment,
                                orderId: orderId,
                                status: status),
                            widget.type);
                      }));

                      if (result == true) {
                        if (widget.type == Constants.typeOrder) {
                          wsGetOrderDetail();
                        } else if (widget.type == Constants.typeBooking) {
                          wsGetBookingDetail();
                        } else if (widget.type == Constants.typeRequest) {
                          wsGetRequestDetail();
                        }
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                        color:
                                            (widget.type == Constants.typeOrder)
                                                ? orderDetailData.cancelOrders!
                                                    .currentStatusColor
                                                : (widget.type ==
                                                        Constants.typeRequest)
                                                    ? requestDetailData
                                                        .cancelRequests!
                                                        .currentStatusColor
                                                    : bookingDetailData
                                                        .cancelBookings!
                                                        .currentStatusColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                  ),
                                  WidgetUtils().sizeBoxWidth(5),
                                  WidgetUtils().simpleTextViewWithGivenFontSize(
                                      (widget.type == Constants.typeOrder)
                                          ? orderDetailData
                                              .cancelOrders!.currentStatus
                                          : (widget.type ==
                                                  Constants.typeRequest)
                                              ? requestDetailData
                                                  .cancelRequests!.currentStatus
                                              : bookingDetailData
                                                  .cancelBookings!
                                                  .currentStatus,
                                      getProportionalScreenWidth(12),
                                      (widget.type == Constants.typeOrder)
                                          ? orderDetailData
                                              .cancelOrders!.currentStatusColor
                                          : (widget.type ==
                                                  Constants.typeRequest)
                                              ? requestDetailData
                                                  .cancelRequests!
                                                  .currentStatusColor
                                              : bookingDetailData
                                                  .cancelBookings!
                                                  .currentStatusColor,
                                      "Inter",
                                      FontWeight.w600,
                                      txtAlign: TextAlign.left)
                                ],
                              ),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  (widget.type == Constants.typeOrder)
                                      ? orderDetailData.cancelOrders!.reason ??
                                          ""
                                      : (widget.type == Constants.typeRequest)
                                          ? requestDetailData
                                                  .cancelRequests!.reason ??
                                              ""
                                          : bookingDetailData
                                                  .cancelBookings!.reason ??
                                              "",
                                  getProportionalScreenWidth(16),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w700,
                                  txtAlign: TextAlign.left)
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
              )
            ]));
  }

  Future<void> wsGetOrderDetail() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["order_id"] = widget.objOrderDataRowModel!.id;
    map["hotel_id"] = userModel.staffHotelId!.hotelId;

    APICall(context).getOrderDetail(map, this);
  }

  Future<void> wsGetBookingDetail() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();

    map["booking_id"] = widget.objBookingDataRowModel!.id;
    map["hotel_id"] = userModel.staffHotelId!.hotelId;

    APICall(context).getBookingDetail(map, this);
  }

  Future<void> wsGetRequestDetail() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["request_id"] = widget.objRequestDataRowModel!.id;
    map["hotel_id"] = userModel.staffHotelId!.hotelId;

    APICall(context).getRequestDetail(map, this);
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
    if (requestCode == API.requestOrderDetail && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var orderDetailResponse = OrderDetailResponse.fromJson(response);

      if (orderDetailResponse.code! == 200) {
        setState(() {
          orderDetailData = orderDetailResponse.data!;
        });
      } else {
        WidgetUtils().customToastMsg(orderDetailResponse.msg!);
      }
    } else if (requestCode == API.requestRequestDetail && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var requestDetailResponse = RequestDetailResponse.fromJson(response);

      if (requestDetailResponse.code! == 200) {
        setState(() {
          requestDetailData = requestDetailResponse.data!;
        });
      } else {
        WidgetUtils().customToastMsg(requestDetailResponse.msg!);
      }
    } else if (requestCode == API.requestBookingDetail && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var bookingDetailResponse = BookingDetailResponse.fromJson(response);

      if (bookingDetailResponse.code! == 200) {
        setState(() {
          bookingDetailData = bookingDetailResponse.data!;
        });
      } else {
        WidgetUtils().customToastMsg(bookingDetailResponse.msg!);
      }
    }
  }
}
