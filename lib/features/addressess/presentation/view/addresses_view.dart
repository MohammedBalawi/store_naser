import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/features/addressess/domain/di/addresses_di.dart';
import 'package:app_mobile/features/addressess/presentation/controller/addresses_controller.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_icons.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';
import '../../domain/model/address_model.dart';
import '../controller/edit_address_controller.dart';
import 'edit_address_view.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({super.key});

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
  final SupabaseClient supabase = Supabase.instance.client;
  final AddressesController controller = Get.find<AddressesController>();

  Future<void> fetchAddresses() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response = await Supabase.instance.client
        .from('addresses')
        .select()
        .eq('user_id', user.id);

    controller.addresses.assignAll(
      response.map((json) => AddressModel.fromJson(json)).toList(),
    );

    setState(() {});
  }





  @override
  void initState() {
    super.initState();
    fetchAddresses();
    if (!Get.isRegistered<AddressesController>()) {
      Get.put(AddressesController());
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(
        title: ManagerStrings.address,
      ),
      backgroundColor: ManagerColors.background,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(
              ManagerHeight.h16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ManagerStrings.address,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.primaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.navigateToAddAddress();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        ManagerRadius.r12,
                      ),
                      border: Border.all(
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ManagerHeight.h10,
                        vertical: ManagerHeight.h6,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            ManagerIcons.addAddress,
                            color: ManagerColors.primaryColor,
                          ),
                          Text(
                            ManagerStrings.addAddress,
                            style: getRegularTextStyle(
                              fontSize: ManagerFontSize.s16,
                              color: ManagerColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...controller.addresses.map((address) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w16,
                vertical: ManagerHeight.h12,
              ),
              child:
                  GestureDetector(
                    onTap: () async {
                      final editController = Get.put(EditAddressController());
                      editController.model = address;
                      editController.fetchModel();

                      await Get.to(() => const EditAddressView(), arguments: address);

                      fetchAddresses();
                    },


                    child: Container(
                  padding: EdgeInsets.all(ManagerHeight.h16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ManagerRadius.r12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(' ${ManagerStrings.addressType}: ${address.type}', style: getBoldTextStyle(fontSize: ManagerFontSize.s16, color: ManagerColors.primaryColor)),
                      Text('${ManagerStrings.city}: ${address.city}', style: getRegularTextStyle(fontSize: ManagerFontSize.s14, color: ManagerColors.primaryColor)),
                      Text('${ManagerStrings.governorate}: ${address.state}', style: getRegularTextStyle(fontSize: ManagerFontSize.s14, color: ManagerColors.primaryColor)),
                      Text('${ManagerStrings.street}: ${address.street}', style: getRegularTextStyle(fontSize: ManagerFontSize.s14, color: ManagerColors.primaryColor)),
                      Text('${ManagerStrings.postalCode}: ${address.postalCode}', style: getRegularTextStyle(fontSize: ManagerFontSize.s14, color: ManagerColors.primaryColor)),
                      if (address.isDefault == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(ManagerStrings.defaultAddress, style: getBoldTextStyle(fontSize: ManagerFontSize.s14, color: Colors.green)),
                        )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    disposeAddresses();
    super.dispose();
  }
}
