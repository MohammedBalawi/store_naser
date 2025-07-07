import 'dart:io';

import 'package:app_mobile/features/cart/data/response/add_order_response.dart';
import 'package:app_mobile/features/categories/data/response/main_categories_response.dart';
import 'package:app_mobile/features/change_password/data/response/change_password_response.dart';
import 'package:app_mobile/features/chats/data/response/chats_response.dart';
import 'package:app_mobile/features/chats/data/response/new_chat_response.dart';
import 'package:app_mobile/features/chats/data/response/send_message_response.dart';
import 'package:app_mobile/features/product_details/data/response/add_rate_response.dart';
import 'package:app_mobile/features/products/data/response/products_response.dart';
import 'package:app_mobile/features/search/data/response/search_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../constants/env/env_constants.dart';
import '../../constants/request_constants/request_constants.dart';
import '../../constants/request_constants/request_constants_endpoints.dart';
import '../../features/addressess/data/response/add_address_response.dart';
import '../../features/addressess/data/response/addresses_response.dart';
import '../../features/addressess/data/response/delete_address_response.dart';
import '../../features/addressess/data/response/edit_address_response.dart';
import '../../features/auth/data/response/login_response.dart';
import '../../features/auth/data/response/logout_response.dart';
import '../../features/auth/data/response/register_response.dart';
import '../../features/cart/data/response/cart_response.dart';
import '../../features/categories/data/response/category_products_response.dart';
import '../../features/delete_account/data/response/delete_account_response.dart';
import '../../features/favorite/data/response/add_favorite_response.dart';
import '../../features/favorite/data/response/favorite_response.dart';
import '../../features/forget_password/data/response/forget_password_response.dart';
import '../../features/home/data/response/home_response.dart';
import '../../features/notifications/data/response/notifications_response.dart';
import '../../features/orders/data/response/finished_order_response.dart';
import '../../features/orders/data/response/orders_response.dart';
import '../../features/otp_register/data/response/otp_register_response.dart';
import '../../features/product_details/data/response/product_details_response.dart';
import '../../features/reset_password/data/response/reset_password_response.dart';
import '../../features/terms/data/response/accept_terms_response.dart';
import '../../features/terms/data/response/terms_response.dart';
import '../service/env_service.dart';

part 'app_api.g.dart';

@RestApi()
abstract class AppService {
  factory AppService(Dio dio) {
    return _AppService(
      dio,
      baseUrl: EnvService.getString(
        key: EnvConstants.apiUrl,
      ),
    );
  }

  // Login Request
  @POST(RequestConstantsEndpoints.loginRequest)
  Future<LoginResponse> login(
    @Field(RequestConstants.identifier) String identifier,
    @Field(RequestConstants.password) String password,
  );

  @POST(RequestConstantsEndpoints.registerRequest)
  Future<RegisterResponse> register(
    @Field(RequestConstants.name) String fullName,
    @Field(RequestConstants.email) String email,
    @Field(RequestConstants.phoneNumber) String phone,
    @Field(RequestConstants.password) String password,
    @Field(RequestConstants.passwordConfirmation) String confirmPassword,
  );

  // Change Password
  @POST(RequestConstantsEndpoints.changePassword)
  Future<ChangePasswordResponse> changePassword(
    @Field(RequestConstants.oldPassword) String oldPassword,
    @Field(RequestConstants.password) String password,
    @Field(RequestConstants.passwordConfirmation) String passwordConfirmation,
  );

  @POST(RequestConstantsEndpoints.forgetPasswordRequest)
  Future<ForgetPasswordResponse> forgetPassword(
    @Field(RequestConstants.email) String email,
  );

  @POST(RequestConstantsEndpoints.resetPassword)
  Future<ResetPasswordResponse> resetPassword(
    @Field(RequestConstants.email) email,
    @Field(RequestConstants.password) password,
    @Field(RequestConstants.otp) otp,
  );

  @POST(RequestConstantsEndpoints.otpRegister)
  Future<OtpRegisterResponse> otpRegister(
    @Field(RequestConstants.email) email,
    @Field(RequestConstants.password) password,
    @Field(RequestConstants.otp) otp,
  );

  @GET(RequestConstantsEndpoints.notifications)
  Future<NotificationsResponse> notifications();

  @GET(RequestConstantsEndpoints.home)
  Future<HomeResponse> home();

  @GET(RequestConstantsEndpoints.orders)
  Future<OrdersResponse> orders();

  @POST(RequestConstantsEndpoints.finishedOrder)
  Future<FinishedOrderResponse> finishedOrder(
    @Field(RequestConstants.id) id,
  );

  @GET(RequestConstantsEndpoints.addresses)
  Future<AddressesResponse> addresses();

  @GET(RequestConstantsEndpoints.terms)
  Future<TermsResponse> terms();

  @POST(RequestConstantsEndpoints.addAddress)
  Future<AddAddressResponse> addAddress(
    @Field(RequestConstants.title) String type,
    @Field(RequestConstants.areaId) String city,
    @Field(RequestConstants.govId) String state,
    @Field(RequestConstants.street) String street,
    @Field(RequestConstants.zipCode) String postalCode,
    @Field(RequestConstants.isDefault) int useDefault,
    @Field(RequestConstants.mobile) String mobile,
    @Field(RequestConstants.lat) String lat,
    @Field(RequestConstants.lang) String lang,
  );

  @POST(RequestConstantsEndpoints.editAddress)
  Future<EditAddressResponse> editAddress(
    @Field(RequestConstants.id) int id,
    @Field(RequestConstants.title) String type,
    @Field(RequestConstants.areaId) String city,
    @Field(RequestConstants.govId) String state,
    @Field(RequestConstants.street) String street,
    @Field(RequestConstants.zipCode) String postalCode,
    @Field(RequestConstants.isDefault) int useDefault,
    @Field(RequestConstants.mobile) String mobile,
    @Field(RequestConstants.lat) String lat,
    @Field(RequestConstants.lang) String lang,
  );

  @POST(RequestConstantsEndpoints.deleteAddress)
  Future<DeleteAddressResponse> deleteAddress(
    @Field(RequestConstants.id) int id,
  );

  @POST(RequestConstantsEndpoints.acceptTerms)
  Future<AcceptTermsResponse> acceptTerms();

  @POST(RequestConstantsEndpoints.logout)
  Future<LogoutResponse> logout();

  @POST(RequestConstantsEndpoints.deleteAccount)
  Future<DeleteAccountResponse> deleteAccount();

  @GET(RequestConstantsEndpoints.cart)
  Future<CartResponse> cart(
    @Field(RequestConstants.ids) List<int> ids,
  );

  @GET(RequestConstantsEndpoints.categories)
  Future<MainCategoriesResponse> categories();

  @POST(RequestConstantsEndpoints.categoryProducts)
  Future<CategoryProductsResponse> categoryProducts(
    @Query(RequestConstants.productId) String id,
  );

  @GET(RequestConstantsEndpoints.favorite)
  Future<FavoriteResponse> favorite();

  @POST(RequestConstantsEndpoints.addFavorite)
  Future<AddFavoriteResponse> addFavorite(
    @Field(RequestConstants.productId) String id,
  );

  @GET(RequestConstantsEndpoints.productDetails)
  Future<ProductDetailsResponse> productDetails(
    @Query(RequestConstants.productId) int id,
  );

  @POST(RequestConstantsEndpoints.addRate)
  Future<AddRateResponse> addRate(
    @Field(RequestConstants.productId) int id,
    @Field(RequestConstants.rate) int rate,
    @Field(RequestConstants.title) String title,
    @Field(RequestConstants.comment) String comment,
  );

  @GET(RequestConstantsEndpoints.products)
  Future<SearchResponse> search(
    @Query(RequestConstants.filter) String filter,
  );

  @GET(RequestConstantsEndpoints.products)
  Future<ProductsResponse> products();

  @GET(RequestConstantsEndpoints.chats)
  Future<ChatsResponse> chats();

  @POST(RequestConstantsEndpoints.newChat)
  Future<NewChatResponse> newChat(
      @Field(RequestConstants.merchantId) int merchantId);

  @POST(RequestConstantsEndpoints.sendMessage)
  Future<SendMessageResponse> sendMessage(
      @Field(RequestConstants.message) String message);
  @POST(RequestConstantsEndpoints.addOrder)
  Future<AddOrderResponse> addOrder(
      @Field(RequestConstants.totalPrice) int totalPrice,
      @Field(RequestConstants.products) List<List<int>> products,
      @Field(RequestConstants.paymentType) int paymentType,
      @Field(RequestConstants.currencyId) int currencyId,
      @Field(RequestConstants.addressId) int addressId,
      @Field(RequestConstants.referenceId) int referenceId,
      @Field(RequestConstants.couponId) int couponId,
      );
}
