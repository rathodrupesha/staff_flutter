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

class CancellationDetail extends StatefulWidget {
  CancellationDetail(this.cancellationDetail,this.type, {Key? key}) : super(key: key);

  Rows cancellationDetail;
  String? type;

  @override
  _CancellationDetailState createState() => _CancellationDetailState();
}
  class _CancellationDetailState extends State<CancellationDetail> implements OnResponseCallback {

    var _isShowLoader = false;
    var userModel = UserData();
    var _reasonController = TextEditingController();

    @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.appLightBackgroundColor,
        appBar: WidgetUtils().customAppBar(
          context,
          Translations.of(context).strCancellationDetail,
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
          visible: true,
          child: Positioned(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 25, bottom: 35),
                  child: _buttonsAcceptReject()
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
                            color: widget.cancellationDetail.currentStatusColor,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                      ),
                      WidgetUtils().sizeBoxWidth(5),
                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          widget.cancellationDetail.currentStatus ?? "",
                          getProportionalScreenWidth(12),
                          widget.cancellationDetail.currentStatusColor,
                          "Inter",
                          FontWeight.w600,
                          txtAlign: TextAlign.left)
                    ],
                  ),
                  WidgetUtils().sizeBoxHeight(8),
                  WidgetUtils().simpleTextViewWithGivenFontSize(
                      "#"+widget.cancellationDetail.orderId.toString() ?? "",
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
                widget.cancellationDetail.comment ?? "",
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

    Widget _buttonsAcceptReject() {
      return Row(
        children: [
          Expanded(
            child: WidgetUtils().buttonSimpleText(
                Translations.of(context).btnAccept, "Inter", getProportionalScreenWidth(16), Colors.white,
                    () {
                  if (widget.type == Constants.typeOrder) {
                    wsAcceptCancelOrder();
                  } else if (widget.type == Constants.typeBooking) {
                    wsAcceptCancelBooking();
                  } else if (widget.type == Constants.typeRequest) {
                    wsAcceptCancelRequest();
                  }
                }, FontWeight.w600,
                bgColor: Constants.appGreenColor,
                cornerRadius: 50.0,
                isRoundedCorners: true),
          ),
          WidgetUtils().sizeBoxWidth(10),
          Expanded(
            child: WidgetUtils().buttonSimpleText(Translations.of(context).btnDecline, "Inter", getProportionalScreenWidth(16), Constants.appRedColor, () {
              _displayTextInputDialog(context);
            }, FontWeight.w600,
                cornerRadius: 50.0, isRoundedCorners: true, isShowBorder: true),
          )
        ],
      );
    }

    Future<void> _displayTextInputDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(Translations.of(context).strDeclineCancellation),
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
                  child: Text(Translations.of(context).btnSubmitSmall),
                  onPressed: () {
                    setState(() {
                      if (_reasonController.text.isEmpty) {
                        WidgetUtils()
                            .customToastMsg(Translations.of(context).strPleaseEnterRejectionReason);
                        return;
                      }
                      Navigator.pop(context);

                      if (widget.type == Constants.typeOrder) {
                        wsRejectCancelOrder();
                      } else if (widget.type == Constants.typeBooking) {
                        wsRejectCancelBooking();
                      } else if (widget.type == Constants.typeRequest) {
                        wsRejectCancelRequest();
                      }
                    });
                  },
                ),
              ],
            );
          });
    }

    Future<void> wsAcceptCancelOrder() async {
      userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

      setState(() {
        _isShowLoader = true;
      });

      var map = Map();

      map["cancel_id"] = widget.cancellationDetail.id.toString();
      map["hotel_id"] = userModel.staffHotelId!.hotelId;

      APICall(context).acceptCancelOrderApi(map, this);
    }

    Future<void> wsRejectCancelOrder() async {
      userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

      setState(() {
        _isShowLoader = true;
      });

      var map = Map();

      map["cancel_id"] = widget.cancellationDetail.id.toString();
      map["hotel_id"] = userModel.staffHotelId!.hotelId;
      map["rejected_reason"] = _reasonController.text.toString();

      APICall(context).rejectCancelOrderApi(map, this);
    }

    Future<void> wsAcceptCancelBooking() async {
      userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

      setState(() {
        _isShowLoader = true;
      });

      var map = Map();

      map["cancel_id"] = widget.cancellationDetail.id.toString();
      map["hotel_id"] = userModel.staffHotelId!.hotelId;

      APICall(context).acceptCancelBookingApi(map, this);
    }

    Future<void> wsRejectCancelBooking() async {
      userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

      setState(() {
        _isShowLoader = true;
      });

      var map = Map();

      map["cancel_id"] = widget.cancellationDetail.id.toString();
      map["hotel_id"] = userModel.staffHotelId!.hotelId;
      map["rejected_reason"] = _reasonController.text.toString();

      APICall(context).rejectCancelBookingApi(map, this);
    }

    Future<void> wsAcceptCancelRequest() async {
      userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

      setState(() {
        _isShowLoader = true;
      });

      var map = Map();

      map["cancel_id"] = widget.cancellationDetail.id.toString();
      map["hotel_id"] = userModel.staffHotelId!.hotelId;

      APICall(context).acceptCancelRequestApi(map, this);
    }

    Future<void> wsRejectCancelRequest() async {
      userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

      setState(() {
        _isShowLoader = true;
      });

      var map = Map();

      map["cancel_id"] = widget.cancellationDetail.id.toString();
      map["hotel_id"] = userModel.staffHotelId!.hotelId;
      map["rejected_reason"] = _reasonController.text.toString();

      APICall(context).rejectCancelRequestApi(map, this);
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
      if (requestCode == API.requestAcceptCancelRequest && this.mounted) {
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
      }else if (requestCode == API.requestRejectCancelRequest && this.mounted) {
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
      }else if (requestCode == API.requestAcceptCancelOrder && this.mounted) {
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
      }else if (requestCode == API.requestRejectCancelOrder && this.mounted) {
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
      }else if (requestCode == API.requestAcceptCancelBooking && this.mounted) {
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
      }else if (requestCode == API.requestRejectCancelBooking && this.mounted) {
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
