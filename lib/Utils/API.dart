class API {
  static const BASE_URL = "hemrostay-api.apps.openxcell.dev";

  // web-services
  static const LOGIN = "api/v1/staff-user/signin";
  static const ASSIGN_SERVICE = "api/v1/staff-services/assign-service";
  static const FETCH_USER = "api/v1/staff-user/profile";
  static const SERVICE_COMPLAINT = "api/v1/staff-services/request-complaint-listing";
  static const BOOKING_COMPLAINT = "api/v1/staff-services/booking-complaint-listing";
  static const ORDER_COMPLAINT = "api/v1/staff-orders/order-complaint-listing";
  static const FAQS = "api/v1/staff-user/faqs";
  static const CMS = "api/v1/customer/user/cms";
  static const LOGOUT = "api/v1/staff-user/logout";
  static const NOTIFICATION_LIST = "api/v1/staff-user/notificationList";
  static const DEVICE_INFO = "api/v1/customer/user/deviceInfo";
  static const ORDER_LIST = "api/v1/staff-orders/order-listing";
  static const ORDER_DETAIL = "api/v1/staff-orders/order-details";
  static const BOOKING_DETAIL = "api/v1/staff-services/bookingDetails";
  static const REQUEST_DETAIL = "api/v1/staff-services/request-details";
  static const SERVICE_LIST = "api/v1/staff-services/request-listing";
  static const BOOKING_LIST = "api/v1/staff-services/booking-listing";
  static const ACCEPT_ORDER = "api/v1/staff-orders/accept-order";
  static const REJECT_ORDER = "api/v1/staff-orders/reject-order";
  static const ACCEPT_BOOKING = "api/v1/staff-services/accept-booking";
  static const REJECT_BOOKING = "api/v1/staff-services/reject-booking";
  static const ACCEPT_REQUEST = "api/v1/staff-services/accept-request";
  static const REJECT_REQUEST = "api/v1/staff-services/reject-request";
  static const REQUEST_COMPLAINT_RESOLVED = "api/v1/staff-services/request-complaint-resolved";
  static const BOOKING_COMPLAINT_RESOLVED = "api/v1/staff-services/booking-complaint-resolved";
  static const ORDER_COMPLAINT_RESOLVED = "api/v1/staff-orders/order-complaint-resolved";
  static const UPDATE_ORDER_STATUS = "api/v1/staff-orders/order-change-status";
  static const UPDATE_BOOKING_STATUS = "api/v1/staff-services/booking-change-status";
  static const UPDATE_REQUEST_STATUS = "api/v1/staff-services/request-change-status";
  static const COMPLAINT_COUNT = "api/v1/staff-services/complaint-count";
  static const CHANGE_PASSWORD = "api/v1/staff-user/change-password";
  static const FORGOT_PASSWORD = "api/v1/customer/user/forgetPassword";

  static const ACCEPT_CANCEL_REQUEST = "api/v1/staff-services/accept-cancel-request";
  static const REJECT_CANCEL_REQUEST = "api/v1/staff-services/reject-cancel-request";
  static const ACCEPT_CANCEL_BOOKING = "api/v1/staff-services/accept-cancel-booking";
  static const REJECT_CANCEL_BOOKING = "api/v1/staff-services/reject-cancel-booking";
  static const ACCEPT_CANCEL_ORDER = "api/v1/staff-orders/accept-cancel-order";
  static const REJECT_CANCEL_ORDER = "api/v1/staff-orders/reject-cancel-order";
  static const EDIT_PROFILE = "api/v1/staff-user/edit-profile";



  // request codes
  static int requestLogin = 1001;
  static int requestFetchUser = 1002;
  static int requestAssignService = 1003;
  static int requestServiceComplaint = 1004;
  static int requestBookingComplaint = 1005;
  static int requestOrderComplaint = 1006;
  static int requestFaqs = 1007;
  static int requestCms = 1008;
  static int requestLogout = 1009;
  static int requestNotificationList = 1010;
  static int requestDeviceInfo = 1011;
  static int requestOrderList = 1012;
  static int requestServiceList = 1013;
  static int requestBookingList = 1014;
  static int requestAcceptOrder = 1015;
  static int requestRejectOrder = 1016;
  static int requestOrderDetail = 1017;
  static int requestAcceptBooking = 1018;
  static int requestRejectBooking = 1019;
  static int requestAcceptRequest = 1020;
  static int requestRejectRequest = 1021;
  static int requestBookingDetail = 1022;
  static int requestRequestDetail = 1023;
  static int requestComplaintResolved = 1024;
  static int requestBookingComplaintResolved = 1025;
  static int requestOrderComplaintResolved = 1026;
  static int requestUpdateOrderStatus = 1027;
  static int requestComplaintCount = 1028;
  static int requestChangePassword = 1029;
  static int requestAcceptCancelRequest = 1030;
  static int requestRejectCancelRequest = 1031;
  static int requestAcceptCancelBooking = 1032;
  static int requestRejectCancelBooking = 1033;
  static int requestAcceptCancelOrder = 1034;
  static int requestRejectCancelOrder = 1035;
  static int requestEditProfile = 1036;
  static int requestUpdateBookingStatus = 1037;
  static int requestUpdateRequestStatus = 1038;
  static int requestForgotPassword = 1041;
}
