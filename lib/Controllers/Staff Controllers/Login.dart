import 'package:flutter/material.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/MyPrefs.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/Validations.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/device_utils.dart';
import '../../Utils/firebase_cloud_messaging.dart';
import '../../localization/localization.dart';
import 'ForgotPassword.dart';
import 'StaffDashborad.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> implements OnResponseCallback {
  var _isShowLoader = false;
  var _emailController = TextEditingController();
  var _passwdController = TextEditingController();
  var _isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadUserNameAndPassword();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        body: Material(
      child: SafeArea(
        top: false,
        bottom: false,
        child: _getBodyView(),
      ),
    ));
  }

  Widget _getBodyView() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Constants.gradient1,
                    Constants.gradient2,
                    Constants.gradient3,
                    Constants.gradient4,
                  ])),
          height: SizeConfig.screenHeight * 0.45,
          width: SizeConfig.screenWidth,
          child: Align(
              child: Image.asset(
            'assets/images/logo.png',
            height: SizeConfig.screenWidth * 0.6,
            width: SizeConfig.screenWidth * 0.6,
          )),
        ),
        Padding(
          padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.35),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  topLeft: Radius.circular(25.0)),
              color: Colors.white,
            ),
            height: (SizeConfig.screenHeight * 0.55) +
                (SizeConfig.screenHeight * 0.35),
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        WidgetUtils().simpleTextViewWithGivenFontSize(
                            Translations.of(context).strWelcome,
                            getProportionalScreenWidth(34),
                            Constants.appDarkBlueTextColor,
                            "Inter",
                            FontWeight.bold),
                        WidgetUtils().sizeBoxHeight(25),
                        WidgetUtils().simpleTextViewWithGivenFontSize(
                            Translations.of(context).strLoginGuide,
                            getProportionalScreenWidth(14),
                            Constants.appLightBlueTextColor,
                            "Inter",
                            FontWeight.normal),
                        WidgetUtils().sizeBoxHeight(40),
                        WidgetUtils().simpleTextViewWithGivenFontSize(
                            Translations.of(context).strUserName,
                            getProportionalScreenWidth(14),
                            Constants.appLightBlueTextColor,
                            "Inter",
                            FontWeight.normal),
                        WidgetUtils().customTextField(
                            "Inter",
                            getProportionalScreenWidth(16),
                            '',
                            FontWeight.normal,
                            Constants.appGrayBottomLineColor,
                            Constants.appDarkBlueTextColor,
                            false,
                            myController: _emailController),
                        WidgetUtils().sizeBoxHeight(20),
                        WidgetUtils().simpleTextViewWithGivenFontSize(
                            Translations.of(context).strPassword,
                            getProportionalScreenWidth(14),
                            Constants.appLightBlueTextColor,
                            "Inter",
                            FontWeight.normal),
                        WidgetUtils().customTextField(
                            "Inter",
                            getProportionalScreenWidth(16),
                            '',
                            FontWeight.normal,
                            Constants.appGrayBottomLineColor,
                            Constants.appDarkBlueTextColor,
                            true,
                            myController: _passwdController),
                        WidgetUtils().sizeBoxHeight(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: _handleRemeberme,
                                  activeColor: Constants.appBlueColor,
                                ),
                                WidgetUtils().simpleTextViewWithGivenFontSize(
                                    Translations.of(context).strRememberMe,
                                    getProportionalScreenWidth(12),
                                    Constants.appDarkBlueTextColor,
                                    "Inter",
                                    FontWeight.w400),
                              ],
                            ),
                            InkWell(
                              onTap: () => {
                                WidgetUtils()
                                    .push(context, () => ForgotPassword())
                              },
                              child: WidgetUtils()
                                  .simpleTextViewWithGivenFontSize(
                                  Translations.of(context).strForgotPasswordWithQuestion,
                                  getProportionalScreenWidth(12),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w400,
                                  isUnderlinedText: true),
                            )
                          ],
                        ),
                        WidgetUtils().sizeBoxHeight(5),
                        WidgetUtils().customButton(
                          context,
                          '',
                          Constants.appBlueColor,
                          "Inter",
                          getProportionalScreenWidth(16),
                          Colors.white,
                          () {
                            wsLogin();
                          },
                          btnAttributedText: Translations.of(context).strLogin,
                          strSubTextFontFamily: "Inter",
                        ),
                        WidgetUtils().sizeBoxHeight(45),
                        Align(
                          alignment: Alignment.center,
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              Translations.of(context).strOrYouCanAskToYourManager,
                              getProportionalScreenWidth(12),
                              Constants.appDarkBlueTextColor,
                              "Inter",
                              FontWeight.w400),
                        ),
                        WidgetUtils().sizeBoxHeight(45),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

  void wsLogin() {
    FocusScope.of(context).requestFocus(FocusNode());
    var map = Map();

    if (Validations(context)
        .loginValidations(_emailController.text, _passwdController.text)) {
      setState(() {
        _isShowLoader = true;
      });

      map["password"] = _passwdController.text;
      map["user_name"] = _emailController.text;
      map["role_id"] = 4;

      APICall(context).login(map, this);
    }
  }

  void wsDeviceInfo(int id) {
    FocusScope.of(context).requestFocus(FocusNode());

    var map = Map();

    map["device_id"] =DeviceUtil().deviceId;
    map["device_type"] = DeviceUtil().deviceType;
    map["device_token"] = FireBaseCloudMessagingWrapper().fcmToken;
    map["id"] = id.toString();

    APICall(context).deviceInfo(map, this);
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
    if (requestCode == API.requestLogin && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });
      var userModel = UserModel.fromJson(response);

      if (userModel.code! == 200) {
        WidgetUtils().customToastMsg(userModel.msg!);

        MyPrefs.saveObject(Keys.LOGIN_DATA, userModel.data);
        MyPrefs.saveObject(Keys.TOKEN, userModel.data!.accessToken);
        MyPrefs.putString(Keys.EMAIL, _emailController.text.toString());
        MyPrefs.putString(Keys.PASSWORD, _passwdController.text.toString());
        MyPrefs.putBoolean(Keys.IS_REMEMBER_ME, _isChecked);

        MyPrefs.readObject(Keys.LOGIN_DATA);

        Constants.token = userModel.data!.accessToken;

        String strFullname =
            '${userModel.data!.firstName!.replaceAll(" ", "")} ${userModel.data!.lastName ?? ""}';
        List<String> nameparts = strFullname.split(" ");

        String initials = nameparts[0].characters.first.toUpperCase() +
            nameparts[1].characters.first.toUpperCase();

        Constants.userInitials = initials;

        wsDeviceInfo(userModel.data!.id!);


        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => StaffDashboard()),
            (Route<dynamic> route) => false);
      } else {
        WidgetUtils().customToastMsg(userModel.msg!);
      }
    }
  }

  //handle remember me function
  void _handleRemeberme(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
    print("Saving Preference");
    print(_isChecked);
    print(_emailController.text);
    print(_passwdController.text);
  }

//load username and password
  void _loadUserNameAndPassword() async {
    try {
      var isRememberMe = await MyPrefs.getBoolean(Keys.IS_REMEMBER_ME);
      var email = await MyPrefs.getString(Keys.EMAIL);
      var pass = await MyPrefs.getString(Keys.PASSWORD);
      print(isRememberMe);
      print(email);
      print(pass);
      if (isRememberMe) {
        setState(() {
          _isChecked = true;
        });
        _emailController.text = email;
        _passwdController.text = pass;
      }
    } catch (e) {
      print(e);
    }
  }
}
