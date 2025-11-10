import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:get/get.dart';

import '../view/checkout_payment_view.dart';

enum PaymentMethod { card, cod, tabby, tamara, stcpay }

class AddressItem {
  final String name;
  final String addressLine;
  final String phone;
  AddressItem({required this.name, required this.addressLine, required this.phone});
}

class CardItem {
  final String brand; // "VISA", "MASTERCARD", "AMEX", "MADA"
  final String masked; // **** **** **** 0594
  final String last4;
  CardItem({required this.brand, required this.masked, required this.last4});
}

class CheckoutController extends GetxController {
  // الخطوة الحالية: 0 عنوان الشحن / 1 الدفع / 2 تم الإرسال
  int step = 0;

  // العناوين
  final addresses = <AddressItem>[
    AddressItem(name: "ناصر", addressLine: "Saudi Arabia., Makkah, حي الملك فهد حي الملك د", phone: "+966 512345678"),
    AddressItem(name: "ناصر", addressLine: "Saudi Arabia., Makkah, حي الملك فهد حي الملك د", phone: "+966 512345678"),
  ];
  int selectedAddress = 0;

  // ملخص عنصر واحد كما في الصورة
  String productTitle = "كريم سيتافيل المرطب - 450 جرام";
  double productPrice = 189.75;
  int productQty = 3;
  String productImage =
      ManagerImages.crame; // بدّلها بصورة منتجك

  // طرق الدفع
  PaymentMethod? selectedMethod = PaymentMethod.card;

  // بطاقات محفوظة
  final cards = <CardItem>[
    CardItem(brand: "VISA", masked: "************0594", last4: "0594"),
  ];
  int selectedCardIndex = 0;

  // القسيمة والملخص
  double itemsSubtotal = 569.25;
  double shipping = 19.0;
  double vat = 0.0;
  double get grandTotal => itemsSubtotal + shipping + vat;

  // حالة تأكيد/OTP
  bool termsAccepted = false;

  // رقم الطلب عند النجاح
  String orderNumber = "26579639";

  // أفعال
  void selectAddress(int i) {
    selectedAddress = i;
    update();
  }

  void addNewAddress() {
    addresses.add(AddressItem(
      name: "عنوان جديد",
      addressLine: "Saudi Arabia., Riyadh, شارع الملك",
      phone: "+966 500000000",
    ));
    selectedAddress = addresses.length - 1;
    update();
  }

  void editAddress(int i) {
    final a = addresses[i];
    addresses[i] = AddressItem(
      name: "${a.name}",
      addressLine: a.addressLine,
      phone: a.phone,
    );
    update();
  }

  void goNextFromAddress() {
    step = 1;        // ننتقل لخطوة الدفع
    update();
    Get.to(() => const CheckoutPaymentView()); // ✅ افتح شاشة الدفع
  }
  void deleteAddress(int i) {
    if (addresses.isEmpty) return;
    addresses.removeAt(i);
    if (selectedAddress >= addresses.length) {
      selectedAddress = addresses.isEmpty ? 0 : addresses.length - 1;
    }
    update();
  }


  void pickPayment(PaymentMethod m) {
    selectedMethod = m;
    update();
  }

  // إضافة بطاقة (من المودال)
  void addCard({required String brand, required String masked, required String last4}) {
    cards.add(CardItem(brand: brand, masked: masked, last4: last4));
    selectedCardIndex = cards.length - 1;
    update();
  }

  void chooseCard(int index) {
    selectedCardIndex = index;
    update();
  }

  void acceptTerms(bool v) {
    termsAccepted = v;
    update();
  }

  // إتمام الدفع (صوري)
  void placeOrder() {
    step = 2; // تم الإرسال
    update();
  }

  void resetFlow() {
    step = 0;
    selectedMethod = PaymentMethod.card;
    termsAccepted = false;
    update();
  }
}
