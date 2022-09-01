import 'package:flutter/material.dart';
import 'package:hamrostay/Models/BaseResponseModel.dart';
import 'package:hamrostay/Models/OrderComplaintResponseModel.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/localization/localization.dart';

import '../../Models/UserModel.dart';
import '../../Utils/API.dart';
import '../../Utils/APICall.dart';

class ComplaintDetail extends StatefulWidget {
  ComplaintDetail(this.complaintDetail,this.type, {Key? key}) : super(key: key);

  Rows complaintDetail;
  String? type;

  @override
  _ComplaintsDetailState createState() => _ComplaintsDetailState();
}
  class _ComplaintsDetailState extends State<ComplaintDetail> implements OnResponseCallback {

    var _isShowLoader = false;
    var userModel = UserData();

    @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.appLightBackgroundColor,
        appBar: WidgetUtils().customAppBar(
          context,
          Translations.of(context).strComplaintDetail,
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
            child: _getBodyView(context),
          ),
        ));
  }

  Widget _getBodyView(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: SingleChildScrollView(
            child: _getChildView(context),
          ),
        ),
        Visibility(
          visible: widget.complaintDetail.status != Constants.serviceStatusResolved,
          child: Positioned(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 25, bottom: 35),
                  child: WidgetUtils().customButton(
                    context,
                    '',
                    Colors.transparent,
                    "Inter",
                    getProportionalScreenWidth(16),
                    Constants.appAquaTextColor,
                    () {
                      if(widget.type == Constants.typeRequest) {
                        wsRequestComplaintResolved();
                      }else if(widget.type == Constants.typeBooking){
                        wsBookingComplaintResolved();
                      }else{
                        wsOrderComplaintResolved();
                      }
                    },
                    btnAttributedText: Translations.of(context).strMarkAsResolved.toUpperCase(),
                    strSubTextFontFamily: "Inter",
                    isOuterBorder: true
                  ),
                )),
          ),
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
    );
  }

  Widget _getChildView(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
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
                            color: widget.complaintDetail.currentStatusColor,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                      ),
                      WidgetUtils().sizeBoxWidth(5),
                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          widget.complaintDetail.currentStatus ?? "",
                          getProportionalScreenWidth(12),
                          widget.complaintDetail.currentStatusColor,
                          "Inter",
                          FontWeight.w600,
                          txtAlign: TextAlign.left)
                    ],
                  ),
                  WidgetUtils().sizeBoxHeight(8),
                  WidgetUtils().simpleTextViewWithGivenFontSize(
                      "#"+widget.complaintDetail.orderId.toString() ?? "",
                      getProportionalScreenWidth(16),
                      Constants.appDarkBlueTextColor,
                      "Inter",
                      FontWeight.w700,
                      txtAlign: TextAlign.left)
                ]),
          ),
          Container(
            height: 8.0,
            color: Constants.appTagBackgroundColor,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: WidgetUtils().simpleTextViewWithGivenFontSize(
                widget.complaintDetail.comment ?? "",
                getProportionalScreenWidth(14),
                Constants.appDarkBlueTextColor,
                "Inter",
                FontWeight.w400,
                txtAlign: TextAlign.left),
          ),
          
        ],
      ),
    );
  }

  Future<void> wsRequestComplaintResolved() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();

    map["complaint_id"] =  widget.complaintDetail.id;
    map["hotel_id"] = userModel.staffHotelId!.hotelId;

    APICall(context).requestComplaintResolvedApi(map, this);
  }

    Future<void> wsBookingComplaintResolved() async {
      userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

      setState(() {
        _isShowLoader = true;
      });

      var map = Map();

      map["complaint_id"] =  widget.complaintDetail.id;
      map["hotel_id"] = userModel.staffHotelId!.hotelId;

      APICall(context).bookingComplaintResolvedApi(map, this);
    }

    Future<void> wsOrderComplaintResolved() async {
      userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

      setState(() {
        _isShowLoader = true;
      });

      var map = Map();

      map["complaint_id"] =  widget.complaintDetail.id;
      map["hotel_id"] = userModel.staffHotelId!.hotelId;

      APICall(context).orderComplaintResolvedApi(map, this);
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
      if (requestCode == API.requestComplaintResolved && this.mounted) {
        setState(() {
          _isShowLoader = false;
        });

        var baseResponseModel = BaseResponseModel.fromJson(response);

        if (baseResponseModel.code! == 200) {
          WidgetUtils().customToastMsg(baseResponseModel.msg!);
          Navigator.pop(context,true);
        } else {
          WidgetUtils().customToastMsg(baseResponseModel.msg!);
        }
      }else if (requestCode == API.requestBookingComplaintResolved && this.mounted) {
        setState(() {
          _isShowLoader = false;
        });

        var baseResponseModel = BaseResponseModel.fromJson(response);

        if (baseResponseModel.code! == 200) {
          WidgetUtils().customToastMsg(baseResponseModel.msg!);
          Navigator.pop(context,true);
        } else {
          WidgetUtils().customToastMsg(baseResponseModel.msg!);
        }
      }else if (requestCode == API.requestOrderComplaintResolved && this.mounted) {
        setState(() {
          _isShowLoader = false;
        });
        var baseResponseModel = BaseResponseModel.fromJson(response);

        if (baseResponseModel.code! == 200) {
          WidgetUtils().customToastMsg(baseResponseModel.msg!);
          Navigator.pop(context,true);
        } else {
          WidgetUtils().customToastMsg(baseResponseModel.msg!);
        }
      }
    }
}
