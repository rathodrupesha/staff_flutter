import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'zh_local.dart';

class Translations implements WidgetsLocalizations {
  const Translations();

  static Translations? current;

  // Helper method to keep the code in the widgets concise Localizations are accessed using an InheritedWidget "of" syntax
  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations) ??
        const Translations();
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<Translations> delegate =
      _TranslationsDelegate();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get appName => 'HamroStay Staff';

  /* Media Selection */
  String get strAlert => "Alert";
  String get strTakePhoto => "Take Photo";
  String get strChooseFromExisting => "Choose Photo";
  String get strImage => "Image";
  String get strVideo => "Video";

  /* Common Button List */
  String get btnCancel => 'Cancel';
  String get btnApply => 'Apply';
  String get btnCancelOrder => 'Cancel Order';
  String get btnOk => 'OK';
  String get btnDelete => 'Delete';
  String get btnDecline => 'Decline';
  String get btnAccept => 'Accept';
  String get btnSave => 'Save';
  String get btnSubmit => 'SUBMIT';
  String get btnSubmitSmall => 'Submit';
  String get btnYes => 'Yes';
  String get btnNo => 'No';
  String get btnDone => 'Done';
  String get btnEdit => 'Edit';
  String get btnAdd => 'Add';
  String get btnConfirm => 'Confirm';
  String get btnUpdate => 'Update';

  /* Login Page */
  String get strLogin => 'SIGN IN';
  String get strUserName => 'Username';
  String get strPassword => 'Password';
  String get strForgotPasswordWithQuestion => 'Forgot Password?';
  String get strSignUp => 'Sign Up';
  String get strWelcome => 'Welcome!';
  String get strLoginGuide => "Please enter credentials provided by your respective manager";
  String get strRememberMe => 'Remember Me!';
  String get strOrYouCanAskToYourManager => 'or you can ask to your Manager';

  /*Setting Screen*/
  String get strLogout => 'Logout';

  String get strUpdateServiceStatus => 'Update Service Status';
  String get strPleaseChangeTheRespectiveStatus => 'Please change the respective status';
  String get strServiceAccepted => 'Service Accepted';
  String get strServiceInProgress => 'Service In Progress';
  String get strServiceCompleted => 'Service Completed';


  String get strCancellationDetail => 'Cancellation Detail';
  String get strDeclineCancellation => 'Decline Cancellation';
  String get strEnterReason => 'Enter Reason';
  String get strPleaseEnterRejectionReason => 'Please enter rejection reason';

  String get strChangePassword => 'Change Password';
  String get strOldPassword => 'Old Password';
  String get strNewPassword => 'New Password';
  String get strConfirmNewPassword => 'Confirm New Password';
  String get strPleaseEnterYourOldPassword => 'Please enter your old password.';
  String get strPleaseEnterNewPassword => 'Please enter new password.';
  String get strPleaseEnterConfirmPassword => 'Please enter confirm password.';

  String get strComplaintDetail => 'Complaint Detail';
  String get strMarkAsResolved => 'Mark as resolved';

  String get strNoDataFound => 'No data found';
  String get strActive => 'Active';
  String get strComplete => 'Complete';

  String get strForgotPassword => 'Forgot Password';
  String get strPleaseEnterUsername => 'Please enter username';


  String get strUpdateOrderStatus => 'Update Order Status';
  String get strOrderAccepted => 'Order Accepted';
  String get strOrderPreparing => 'Order Preparing';
  String get strOrderCompleted => 'Order Completed';


  String get strFromWhereDoYouWantTakePhoto => 'From where do you want to take the photo?';
  String get strGallery => 'Gallery';
  String get strCamera => 'Camera';
  String get strFirstName => 'First Name';
  String get strLastName => 'Last Name';
  String get strEmail => 'Email';
  String get strPhoneNumber => 'Phone Number';

  String get strUpdateRequestStatus => 'Update Request Status';
  String get strRequestAccepted => 'Request Accepted';
  String get strRequestInProgress => 'Request In Progress';
  String get strRequestCompleted => 'Request Completed';

  String get strMenu => 'Menu';
  String get strPrivacyPolicy => 'Privacy Policy';
  String get strTermsOfUse => 'Terms of Use';
  String get strAboutUs => 'About us';
  String get strFAQs => 'FAQs';
  String get strSignOut => 'Sign Out';
  String get strEditProfile => 'Edit Profile';

  String get strPressBackToExit => 'Press back again to exit app.';
  String get strDashboard => 'Dashboard';
  String get strComplaints => 'Complaints';
  String get strNotification => 'Notification';
  String get strSearchHere => ' Search here';

  String get strOrderNumber => 'ORDER NUMBER';
  String get strItems => 'ITEMS';
  String get strOrderedOn => 'ORDERED ON';
  String get strAdditionalDetail => 'ADDITIONAL DETAIL';
  String get strEstTime => 'Est Time';
  String get strService => 'SERVICE';
  String get strPackage => 'PACKAGE';
  String get strDeliveredOn => 'DELIVERED ON';
  String get strDeclineRequest => 'Decline Request';

  String get strOrderStatus => 'Order Status';
  String get strUpdateStatus => 'Update Status';
  String get strOrderNewAccepted => 'Order\nAccepted';
  String get strOrderNewPreparing => 'Order\nPreparing';
  String get strOrderNewCompleted => 'Order\nCompleted';
  String get strServiceStatus => 'Service Status';
  String get strServiceNewAccepted => 'Service\nAccepted';
  String get strServiceNewInProgress => 'Service\nIn Progress';
  String get strServiceNewCompleted => 'Service\nCompleted';
  String get strRequestStatus => 'Request Status';
  String get strRequestNewAccepted => 'Request\nAccepted';
  String get strRequestNewInProgress => 'Request\nIn Progress';
  String get strRequestNewCompleted => 'Request\nCompleted';
  String get strEstimatedTime => 'ESTIMATED TIME:';
  String get strRequestOn => 'REQUEST ON';
  String get strSlotTime => 'SLOT TIME';
  String get strNoOfPerson => 'NO. OF PERSON';
  String get strPerson => ' Person';
  String get strCancellation => 'Cancellation';

}

class _TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const _TranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<Translations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    if (locale.languageCode.toLowerCase() == 'en') {
      Translations.current = const Translations();
      return SynchronousFuture<Translations>(
          Translations.current ?? const Translations());
    } else if (locale.languageCode.toLowerCase() == 'zh') {
      Translations.current = const $zh();
      return SynchronousFuture<Translations>(
          Translations.current ?? const $zh());
    }
    Translations.current = const Translations();
    return SynchronousFuture<Translations>(
        Translations.current ?? const Translations());
  }

  @override
  bool shouldReload(_TranslationsDelegate old) => false;
}
