import 'package:flutter/material.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/localization/localization.dart';

import '../../Models/BaseResponseModel.dart';
import '../../Models/UserModel.dart';
import '../../Utils/API.dart';
import '../../Utils/APICall.dart';

class OrderStatusPopup extends StatefulWidget {
  OrderStatusPopup(this.id,{Key? key}) : super(key: key);

  String id;
  @override
  _OrderStatusPopupState createState() => _OrderStatusPopupState();
}

class _OrderStatusPopupState extends State<OrderStatusPopup> implements OnResponseCallback{
  String dropdownValue = Translations.current!.strOrderAccepted;
  var userModel = UserData();
  var _isShowLoader = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.65,
            color: Colors.transparent,
          ),
        ),
        Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight:
                      Radius.circular((SizeConfig.screenHeight * 0.45 / 10)),
                  topLeft:
                      Radius.circular((SizeConfig.screenHeight * 0.45 / 10))),
            ),
            child: Stack(
              children: [
                Positioned(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: Material(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        WidgetUtils().simpleTextViewWithGivenFontSize(
                            Translations.of(context).strUpdateOrderStatus,
                            getProportionalScreenWidth(18),
                            Constants.appDarkBlueTextColor,
                            "Inter",
                            FontWeight.w700,
                            txtAlign: TextAlign.center),
                        WidgetUtils().sizeBoxHeight(10),
                        WidgetUtils().simpleTextViewWithGivenFontSize(
                            Translations.of(context).strPleaseChangeTheRespectiveStatus,
                            getProportionalScreenWidth(14),
                            Constants.appDarkBlueTextColor,
                            "Inter",
                            FontWeight.w400,
                            txtAlign: TextAlign.center),
                        WidgetUtils().sizeBoxHeight(20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.all(Radius.circular(
                                SizeConfig.screenHeight * 0.05 / 4)),
                            color: Color.fromRGBO(244, 245, 247, 1.0),
                          ),
                          height: getProportionalScreenHeight(50),
                          width: SizeConfig.screenWidth - 50,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValue,
                              iconSize: 30,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                              ),
                              elevation: 16,
                              style: const TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.appDarkBlueTextColor),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>[
                                Translations.of(context).strOrderAccepted,
                                Translations.of(context).strOrderPreparing,
                                Translations.of(context).strOrderCompleted,
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                Positioned(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 25, bottom: 35),
                          child: WidgetUtils().customButton(
                            context,
                            '',
                            Constants.appBlueColor,
                            "Inter",
                            getProportionalScreenWidth(16),
                            Colors.white,
                            () {
                              wsUpdateOrderStatus();
                            },
                            btnAttributedText: Translations.of(context).btnSubmit,
                            strSubTextFontFamily: "Inter",
                          ),
                        ),
                      )),
                )
              ],
            ))
      ],
    );
  }

  Future<void> wsUpdateOrderStatus() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();

    map["order_id"] =  widget.id;
    map["hotel_id"] = userModel.staffHotelId!.hotelId;

    if(dropdownValue == Translations.of(context).strOrderAccepted) {
      map["status"] = Constants.serviceStatusAccepted;
    }else if(dropdownValue == Translations.of(context).strOrderPreparing) {
      map["status"] = Constants.serviceStatusInProgress;
    }else if(dropdownValue == Translations.of(context).strOrderCompleted) {
      map["status"] = Constants.serviceStatusCompleted;
    }

    APICall(context).updateOrderStatusApi(map, this);
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
    if (requestCode == API.requestUpdateOrderStatus && this.mounted) {
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
