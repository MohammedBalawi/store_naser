class AddOrderRequest {
  List<List<int>> products;
  int totalPrice;
  int paymentType;
  int currencyId;
  int addressId;
  int referenceId;
  int couponId;

  AddOrderRequest({
    required this.products,
    required this.totalPrice,
    required this.paymentType,
    required this.currencyId,
    required this.addressId,
    required this.referenceId,
    required this.couponId,
  });
}
