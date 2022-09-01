import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
import 'Login.dart';

class Complaints extends StatefulWidget {
  Complaints({Key? key}) : super(key: key);

  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints>
    implements OnResponseCallback {
  var userModel = UserData();
  var _isShowLoader = false;
  List<AssignServiceData> _objAssignServicesRowModel = [];

  @override
  void initState() {
    super.initState();
    wsAssignService();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Constants.appLightBackgroundColor,
            body: _getBodyView(),
          ),
        ],
      ),
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
                  padding: const EdgeInsets.only(top: 20,bottom: 16,left: 16,right: 16),
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
              WidgetUtils().push(context, () => ComplaintsList(id: _objAssignServicesRowModel[index].id,toolbarTitle:_objAssignServicesRowModel[index].name!,type: _objAssignServicesRowModel[index].type ?? "order",));
            });
      },
    );
  }

  Future<void> wsAssignService() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;
    setState(() {
      _isShowLoader = true;
    });
    var map = Map();
    map["hotel_id"] = userModel.staffHotelId!.hotelId!;

    APICall(context).complaintCountApi(map, this);
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
    if (requestCode == API.requestComplaintCount && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var assignServiceResponse = AssignServiceResponseModel.fromJson(response);

      if (assignServiceResponse.code! == 200) {
        setState(() {
          _objAssignServicesRowModel = assignServiceResponse.data!;
        });
      }  else {
        WidgetUtils().customToastMsg(assignServiceResponse.msg!);
      }
    }
  }
}
