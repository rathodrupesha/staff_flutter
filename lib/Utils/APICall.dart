import 'dart:async';
import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:http/http.dart' as http;

import 'API.dart';
import 'NetworkUtils.dart';
import 'OnResponseCallback.dart';
import 'package:mime/mime.dart';

class APICall {
  final BuildContext context;

  APICall(this.context);

  Future<void> login(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.LOGIN),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestLogin, request, API.LOGIN);
      print("Headers of ${API.LOGIN}, $_getHeader()");
      print("Request of ${API.LOGIN}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestLogin);
      return null;
    }
  }

  Future<void> fetchUser(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response =
      await http.get(_getUri(API.FETCH_USER), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestFetchUser, request,
          API.FETCH_USER);
      print("Headers of ${API.FETCH_USER}, $_getHeader()");
      print("Request of ${API.FETCH_USER}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestFetchUser);
      return null;
    }
  }

  Future<void> getAssignServiceApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.ASSIGN_SERVICE),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestAssignService, request, API.ASSIGN_SERVICE);
      print("Headers of ${API.ASSIGN_SERVICE}, $_getHeader()");
      print("Request of ${API.ASSIGN_SERVICE}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestAssignService);
      return null;
    }
  }

  Future<void> serviceComplaintApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.SERVICE_COMPLAINT),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestServiceComplaint, request, API.SERVICE_COMPLAINT);
      print("Headers of ${API.SERVICE_COMPLAINT}, $_getHeader()");
      print("Request of ${API.SERVICE_COMPLAINT}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestServiceComplaint);
      return null;
    }
  }

  Future<void> bookingComplaintApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.BOOKING_COMPLAINT),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestBookingComplaint, request, API.BOOKING_COMPLAINT);
      print("Headers of ${API.BOOKING_COMPLAINT}, $_getHeader()");
      print("Request of ${API.BOOKING_COMPLAINT}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestBookingComplaint);
      return null;
    }
  }

  Future<void> orderComplaintApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.ORDER_COMPLAINT),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestOrderComplaint, request, API.ORDER_COMPLAINT);
      print("Headers of ${API.ORDER_COMPLAINT}, $_getHeader()");
      print("Request of ${API.ORDER_COMPLAINT}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestOrderComplaint);
      return null;
    }
  }

  Future<void> deviceInfo(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.DEVICE_INFO),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestDeviceInfo, request, API.DEVICE_INFO);
      print("Headers of ${API.DEVICE_INFO}, $_getHeader()");
      print("Request of ${API.DEVICE_INFO}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestDeviceInfo);
      return null;
    }
  }

  Future<void> getOrderList(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ORDER_LIST),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestOrderList, request, API.ORDER_LIST);
      print("Headers of ${API.ORDER_LIST}, $_getHeader()");
      print("Request of ${API.ORDER_LIST}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestOrderList);
      return null;
    }
  }

  Future<void> getOrderDetail(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ORDER_DETAIL),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestOrderDetail, request, API.ORDER_DETAIL);
      print("Headers of ${API.ORDER_DETAIL}, $_getHeader()");
      print("Request of ${API.ORDER_DETAIL}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestOrderDetail);
      return null;
    }
  }

  Future<void> getBookingDetail(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.BOOKING_DETAIL),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestBookingDetail, request, API.BOOKING_DETAIL);
      print("Headers of ${API.BOOKING_DETAIL}, $_getHeader()");
      print("Request of ${API.BOOKING_DETAIL}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestBookingDetail);
      return null;
    }
  }

  Future<void> getRequestDetail(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.REQUEST_DETAIL),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestRequestDetail, request, API.REQUEST_DETAIL);
      print("Headers of ${API.REQUEST_DETAIL}, $_getHeader()");
      print("Request of ${API.REQUEST_DETAIL}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestRequestDetail);
      return null;
    }
  }

  Future<void> getServiceList(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.SERVICE_LIST),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestServiceList, request, API.SERVICE_LIST);
      print("Headers of ${API.SERVICE_LIST}, $_getHeader()");
      print("Request of ${API.SERVICE_LIST}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestServiceList);
      return null;
    }
  }

  Future<void> getBookingList(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.BOOKING_LIST),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestBookingList, request, API.BOOKING_LIST);
      print("Headers of ${API.BOOKING_LIST}, $_getHeader()");
      print("Request of ${API.BOOKING_LIST}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestBookingList);
      return null;
    }
  }

  Future<void> acceptOrderApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ACCEPT_ORDER),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestAcceptOrder, request, API.ACCEPT_ORDER);
      print("Headers of ${API.ACCEPT_ORDER}, $_getHeader()");
      print("Request of ${API.ACCEPT_ORDER}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestAcceptOrder);
      return null;
    }
  }

  Future<void> rejectOrderApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.REJECT_ORDER),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestRejectOrder, request, API.REJECT_ORDER);
      print("Headers of ${API.REJECT_ORDER}, $_getHeader()");
      print("Request of ${API.REJECT_ORDER}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestRejectOrder);
      return null;
    }
  }

  Future<void> acceptBookingApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ACCEPT_BOOKING),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestAcceptBooking, request, API.ACCEPT_BOOKING);
      print("Headers of ${API.ACCEPT_BOOKING}, $_getHeader()");
      print("Request of ${API.ACCEPT_BOOKING}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestAcceptBooking);
      return null;
    }
  }

  Future<void> rejectBookingApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.REJECT_BOOKING),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestRejectBooking, request, API.REJECT_BOOKING);
      print("Headers of ${API.REJECT_BOOKING}, $_getHeader()");
      print("Request of ${API.REJECT_BOOKING}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestRejectBooking);
      return null;
    }
  }

  Future<void> acceptRequestApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ACCEPT_REQUEST),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestAcceptRequest, request, API.ACCEPT_REQUEST);
      print("Headers of ${API.ACCEPT_REQUEST}, $_getHeader()");
      print("Request of ${API.ACCEPT_REQUEST}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestAcceptRequest);
      return null;
    }
  }

  Future<void> rejectRequestApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.REJECT_REQUEST),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestRejectRequest, request, API.REJECT_REQUEST);
      print("Headers of ${API.REJECT_REQUEST}, $_getHeader()");
      print("Request of ${API.REJECT_REQUEST}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestRejectRequest);
      return null;
    }
  }

  Future<void> acceptCancelOrderApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ACCEPT_CANCEL_ORDER),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestAcceptCancelOrder, request, API.ACCEPT_CANCEL_ORDER);
      print("Headers of ${API.ACCEPT_CANCEL_ORDER}, $_getHeader()");
      print("Request of ${API.ACCEPT_CANCEL_ORDER}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestAcceptCancelOrder);
      return null;
    }
  }

  Future<void> rejectCancelOrderApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.REJECT_CANCEL_ORDER),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestRejectCancelOrder, request, API.REJECT_CANCEL_ORDER);
      print("Headers of ${API.REJECT_CANCEL_ORDER}, $_getHeader()");
      print("Request of ${API.REJECT_CANCEL_ORDER}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestRejectCancelOrder);
      return null;
    }
  }

  Future<void> acceptCancelBookingApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ACCEPT_CANCEL_BOOKING),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestAcceptCancelBooking, request, API.ACCEPT_CANCEL_BOOKING);
      print("Headers of ${API.ACCEPT_CANCEL_BOOKING}, $_getHeader()");
      print("Request of ${API.ACCEPT_CANCEL_BOOKING}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestAcceptCancelBooking);
      return null;
    }
  }

  Future<void> rejectCancelBookingApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.REJECT_CANCEL_BOOKING),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestRejectCancelBooking, request, API.REJECT_CANCEL_BOOKING);
      print("Headers of ${API.REJECT_CANCEL_BOOKING}, $_getHeader()");
      print("Request of ${API.REJECT_CANCEL_BOOKING}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestRejectCancelBooking);
      return null;
    }
  }

  Future<void> acceptCancelRequestApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ACCEPT_CANCEL_REQUEST),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestAcceptCancelRequest, request, API.ACCEPT_CANCEL_REQUEST);
      print("Headers of ${API.ACCEPT_CANCEL_REQUEST}, $_getHeader()");
      print("Request of ${API.ACCEPT_CANCEL_REQUEST}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestAcceptCancelRequest);
      return null;
    }
  }

  Future<void> rejectCancelRequestApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.REJECT_CANCEL_REQUEST),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestRejectCancelRequest, request, API.REJECT_CANCEL_REQUEST);
      print("Headers of ${API.REJECT_CANCEL_REQUEST}, $_getHeader()");
      print("Request of ${API.REJECT_CANCEL_REQUEST}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestRejectCancelRequest);
      return null;
    }
  }

  Future<void> getFaq(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.FAQS),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestFaqs, request, API.FAQS);
      print("Headers of ${API.FAQS}, $_getHeader()");
      print("Request of ${API.FAQS}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestFaqs);
      return null;
    }
  }

  Future<void> getCms(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.CMS),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestCms, request, API.CMS);
      print("Headers of ${API.CMS}, $_getHeader()");
      print("Request of ${API.CMS}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestCms);
      return null;
    }
  }

  Future<void> logout(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.LOGOUT),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestLogout, request, API.LOGOUT);
      print("Headers of ${API.LOGOUT}, $_getHeader()");
      print("Request of ${API.LOGOUT}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestLogout);
      return null;
    }
  }

  Future<void> getNotificationListApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.NOTIFICATION_LIST),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestNotificationList, request, API.NOTIFICATION_LIST);
      print("Headers of ${API.NOTIFICATION_LIST}, $_getHeader()");
      print("Request of ${API.NOTIFICATION_LIST}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestNotificationList);
      return null;
    }
  }

  Future<void> requestComplaintResolvedApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.REQUEST_COMPLAINT_RESOLVED),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestComplaintResolved, request, API.REQUEST_COMPLAINT_RESOLVED);
      print("Headers of ${API.REQUEST_COMPLAINT_RESOLVED}, $_getHeader()");
      print("Request of ${API.REQUEST_COMPLAINT_RESOLVED}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestComplaintResolved);
      return null;
    }
  }

  Future<void> bookingComplaintResolvedApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.BOOKING_COMPLAINT_RESOLVED),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestBookingComplaintResolved, request, API.BOOKING_COMPLAINT_RESOLVED);
      print("Headers of ${API.BOOKING_COMPLAINT_RESOLVED}, $_getHeader()");
      print("Request of ${API.BOOKING_COMPLAINT_RESOLVED}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestBookingComplaintResolved);
      return null;
    }
  }

  Future<void> orderComplaintResolvedApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ORDER_COMPLAINT_RESOLVED),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestOrderComplaintResolved, request, API.ORDER_COMPLAINT_RESOLVED);
      print("Headers of ${API.ORDER_COMPLAINT_RESOLVED}, $_getHeader()");
      print("Request of ${API.ORDER_COMPLAINT_RESOLVED}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestOrderComplaintResolved);
      return null;
    }
  }

  Future<void> updateOrderStatusApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.UPDATE_ORDER_STATUS),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestUpdateOrderStatus, request, API.UPDATE_ORDER_STATUS);
      print("Headers of ${API.UPDATE_ORDER_STATUS}, $_getHeader()");
      print("Request of ${API.UPDATE_ORDER_STATUS}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestUpdateOrderStatus);
      return null;
    }
  }

  Future<void> updateBookingStatusApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.UPDATE_BOOKING_STATUS),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestUpdateBookingStatus, request, API.UPDATE_BOOKING_STATUS);
      print("Headers of ${API.UPDATE_BOOKING_STATUS}, $_getHeader()");
      print("Request of ${API.UPDATE_BOOKING_STATUS}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestUpdateBookingStatus);
      return null;
    }
  }

  Future<void> updateRequestStatusApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.UPDATE_REQUEST_STATUS),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestUpdateRequestStatus, request, API.UPDATE_REQUEST_STATUS);
      print("Headers of ${API.UPDATE_REQUEST_STATUS}, $_getHeader()");
      print("Request of ${API.UPDATE_REQUEST_STATUS}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestUpdateRequestStatus);
      return null;
    }
  }

  Future<void> complaintCountApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.COMPLAINT_COUNT),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestComplaintCount, request, API.COMPLAINT_COUNT);
      print("Headers of ${API.COMPLAINT_COUNT}, $_getHeader()");
      print("Request of ${API.COMPLAINT_COUNT}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestComplaintCount);
      return null;
    }
  }

  Future<void> changePasswordApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.CHANGE_PASSWORD),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestChangePassword, request, API.CHANGE_PASSWORD);
      print("Headers of ${API.CHANGE_PASSWORD}, $_getHeader()");
      print("Request of ${API.CHANGE_PASSWORD}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestChangePassword);
      return null;
    }
  }

  Future<void> editProfileApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      var multipartReq =
      http.MultipartRequest('POST', _getUri(API.EDIT_PROFILE));
      multipartReq.headers.addAll(_getHeader());
      multipartReq.fields["first_name"] = request["first_name"];
      multipartReq.fields["last_name"] = request["last_name"];
      multipartReq.fields["email"] = request["email"];
      multipartReq.fields["mobile_num"] = request["mobile_num"];
      var imagePath = request["profile_image"];

      if(imagePath != null) {
        String? mineType = lookupMimeType(imagePath);

        if (imagePath != null && mineType != null) {
          multipartReq.files.add(await http.MultipartFile.fromPath(
              'profile_image', request["profile_image"],
              contentType: MediaType(mineType
                  .split("/")
                  .first, mineType
                  .split("/")
                  .last)));
        }
      }

      var response = await multipartReq.send();
      _checkResponse(await http.Response.fromStream(response), responseCallback,
          API.requestEditProfile, multipartReq, API.EDIT_PROFILE);
      print("Headers of ${API.EDIT_PROFILE}, $_getHeader()");
      print("Request of ${API.EDIT_PROFILE}, $multipartReq");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestEditProfile);
      return null;
    }
  }

  Future<void> forgotPassword(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.FORGOT_PASSWORD),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestForgotPassword, request, API.FORGOT_PASSWORD);
      print("Headers of ${API.FORGOT_PASSWORD}, $_getHeader()");
      print("Request of ${API.FORGOT_PASSWORD}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestForgotPassword);
      return null;
    }
  }

  Future<void> _checkResponse(http.Response response, responseCallback,
      requestCode, mapRequest, currentURL) async {
    var map = json.decode(utf8.decode(response.bodyBytes));
    switch (map["code"]) {
      case 200:
        print("RESPONSE $currentURL -> ${response.body}");
        responseCallback.onResponseReceived(map, requestCode);
        break;
      // case 204:
      //   responseCallback.onResponseError("No_Data", requestCode);
      //   print("ERROR -> ${response.statusCode}: ${response.body}");
      //   break;
      case 400:
        print("RESPONSE $currentURL -> ${response.body}");
        responseCallback.onResponseReceived(map, requestCode);
        break;

      case 401:
        print("RESPONSE $currentURL -> ${response.body}");
        responseCallback.onResponseReceived(map, requestCode);
        break;
      // case 401:
      // var map = Map();
      // var userModel = await WidgetUtils.fetchUserDetailsFromPreference();
      // map["refresh_token"] = userModel.data.refreshToken;
      // refreshToken(map, responseCallback, _getUri(currentURL), mapRequest,
      //     requestCode);
      // break;
      case 500:
        responseCallback.onResponseError('error_something_wrong', requestCode);
        print("ERROR -> ${response.statusCode}: ${response.body}");
        break;
      default:
        responseCallback.onResponseError('error_something_wrong', requestCode);
        print("ERROR -> ${response.statusCode}: ${response.body}");
        break;
    }
  }

  Map<String, String> _getHeader() {
    print('Token-> Bearer ${Constants.token}');
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "language": Constants.isEnglishLanguage ? "english" : "chinese",
      "authorization": "Bearer ${Constants.token}"
    };
  }

  Uri _getUri(String path) {
    // var map = {
    //   'lang': Constants.isEnglishLanguage ? "en" : "ar",
    // };
    var url = Uri.https(API.BASE_URL, path);
    print("Normal URL:: $url");
    return url;
  }

  Uri _getUriWithQuery(String path, Map<String, String> queryParams) {
    var url = Uri.https(API.BASE_URL, path, queryParams);
    print("Query URL:: $url");
    return url;
  }
}
