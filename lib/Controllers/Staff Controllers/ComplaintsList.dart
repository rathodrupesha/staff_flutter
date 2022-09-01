
import 'package:flutter/material.dart';
import 'package:hamrostay/Models/OrderComplaintResponseModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/localization/localization.dart';

import '../../Models/BookingComplaintResponseModel.dart';
import '../../Models/RequestComplaintResponseModel.dart';
import 'ComplaintDetail.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';

class ComplaintsList extends StatefulWidget {
  ComplaintsList({Key? key,this.id,required this.toolbarTitle, this.type,}) : super(key: key);

  String toolbarTitle;
  String? type;
  int? id;

  @override
  State<ComplaintsList> createState() => _ComplaintsListState();
}

class _ComplaintsListState extends State<ComplaintsList> implements OnResponseCallback{
  var userModel = UserData();
  bool isSelectedCompleted = false;
  var _isShowLoader = false;

  OrderComplaintData? _objOrderComplaintRowModel;
  RequestComplaintData? _objRequestComplaintRowModel;
  BookingComplaintData? _objBookingComplaintRowModel;

  @override
  void initState() {
    super.initState();
    if (widget.type == Constants.typeOrder) {
      wsOrderComplaint();
    } else if (widget.type == Constants.typeBooking) {
      wsBookingComplaint();
    } else if (widget.type == Constants.typeRequest) {
      wsServiceComplaint();
    }
  }
  @override
   Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: WidgetUtils().customAppBar(
          context,
          widget.toolbarTitle,
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
            child: _allItemsView(),
          ),
        ));
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
                    isSelectedCompleted = index == 0 ? false : true;

                    _objOrderComplaintRowModel = null;

                    if (widget.type == Constants.typeOrder) {
                      wsOrderComplaint();
                    } else if (widget.type == Constants.typeBooking) {
                      wsBookingComplaint();
                    } else if (widget.type == Constants.typeRequest) {
                      wsServiceComplaint();
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
            (_objOrderComplaintRowModel != null && _objOrderComplaintRowModel!.rows!.isNotEmpty) ? Expanded(child: _viewComplaintDetails()) :  Expanded(child:Container(
                color: Constants.appTagBackgroundColor,
                child: WidgetUtils().noDataFoundText(
                    _isShowLoader, Translations.of(context).strNoDataFound, 150, 150)))
          ],
        ));
  }

  Widget _viewComplaintDetails() {
    return Container(
        padding: const EdgeInsets.all(16.0),
        color: Constants.appTagBackgroundColor,
        width: SizeConfig.screenWidth,
        child: RefreshIndicator(
          onRefresh: () async{
            if (widget.type == Constants.typeOrder) {
              wsOrderComplaint();
            } else if (widget.type == Constants.typeBooking) {
              wsBookingComplaint();
            } else if (widget.type == Constants.typeRequest) {
              wsServiceComplaint();
            }
          },
          child: ListView.separated(
                  itemCount: _objOrderComplaintRowModel!.rows!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                       // WidgetUtils().push(context, () => ComplaintDetail(_objOrderComplaintRowModel!.rows![index],widget.type));

                        var result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return ComplaintDetail(_objOrderComplaintRowModel!.rows![index],widget.type);
                        }));

                        if(result == true){
                          if (widget.type == Constants.typeOrder) {
                            wsOrderComplaint();
                          } else if (widget.type == Constants.typeBooking) {
                            wsBookingComplaint();
                          } else if (widget.type == Constants.typeRequest) {
                            wsServiceComplaint();
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
                                          color: _objOrderComplaintRowModel!.rows![index].currentStatusColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                    ),
                                    WidgetUtils().sizeBoxWidth(5),
                                    WidgetUtils().simpleTextViewWithGivenFontSize(
                                        _objOrderComplaintRowModel!.rows![index].currentStatus,
                                        getProportionalScreenWidth(12),
                                        _objOrderComplaintRowModel!.rows![index].currentStatusColor,
                                        "Inter",
                                        FontWeight.w600,
                                        txtAlign: TextAlign.left)
                                  ],
                                ),
                                WidgetUtils().sizeBoxHeight(5),
                                WidgetUtils().simpleTextViewWithGivenFontSize(
                                    _objOrderComplaintRowModel!.rows![index].comment ?? "",
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
                ),
        ));
  }

  Future<void> wsOrderComplaint() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _objOrderComplaintRowModel = null;
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.staffHotelId!.hotelId;
    map["is_resolved"] = isSelectedCompleted;

    APICall(context).orderComplaintApi(map, this);
  }

  Future<void> wsBookingComplaint() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _objOrderComplaintRowModel = null;
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.staffHotelId!.hotelId;
    map["is_resolved"] = isSelectedCompleted;

    APICall(context).bookingComplaintApi(map, this);
  }

  Future<void> wsServiceComplaint() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _objOrderComplaintRowModel = null;
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.staffHotelId!.hotelId;
    map["is_resolved"] = isSelectedCompleted;
    map["main_service_id"] = widget.id;

    APICall(context).serviceComplaintApi(map, this);
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
    if (requestCode == API.requestOrderComplaint && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var orderComplaintResponse = OrderComplaintResponseModel.fromJson(response);

      if (orderComplaintResponse.code! == 200) {
        setState(() {
          _objOrderComplaintRowModel = orderComplaintResponse.data!;
        });
      } else {
        WidgetUtils().customToastMsg(orderComplaintResponse.msg!);
      }
    }else if (requestCode == API.requestBookingComplaint && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var orderComplaintResponse = OrderComplaintResponseModel.fromJson(response);

      if (orderComplaintResponse.code! == 200) {
        setState(() {
          _objOrderComplaintRowModel = orderComplaintResponse.data!;
        });
      } else {
        WidgetUtils().customToastMsg(orderComplaintResponse.msg!);
      }
    }else if (requestCode == API.requestServiceComplaint && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var orderComplaintResponse = OrderComplaintResponseModel.fromJson(response);

      if (orderComplaintResponse.code! == 200) {
        setState(() {
          _objOrderComplaintRowModel = orderComplaintResponse.data!;
        });
      } else {
        WidgetUtils().customToastMsg(orderComplaintResponse.msg!);
      }
    }
  }
}