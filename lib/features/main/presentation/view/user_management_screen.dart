import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/resources/manager_fonts.dart';
import '../../../../core/resources/manager_styles.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> users = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await supabase
          .from('users')
          .select()
          .order('created_at', ascending: true);

      if (response != null && response is List) {
        setState(() {
          users = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      Get.snackbar(
        ManagerStrings.error,
        ManagerStrings.fetchingUsers,
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    try {
      await supabase.from('users').update({
        'email': user['email'],
        'role': user['role'],
        'phone': user['phone'],
        'created_at': user['created_at'],
        'full_name': user['full_name'],
        'is_wholesaler': user['is_wholesaler'],
      }).eq('id', user['id']);

      Get.snackbar(
        ManagerStrings.success,
        ManagerStrings.userDataHasBeenUpdated,
      );
      await fetchUsers();
    } catch (e) {
      Get.snackbar(
        ManagerStrings.error,
        ManagerStrings.failedUpdated,
      );
    }
  }

  void showEditDialog(Map<String, dynamic> user) {
    final emailController = TextEditingController(text: user['email'] ?? '');
    final roleController = TextEditingController(text: user['role'] ?? '');
    final nameController = TextEditingController(text: user['full_name'] ?? '');
    final imageController = TextEditingController(text: user['image'] ?? '');
    final phoneController = TextEditingController(text: user['phone'] ?? '');
    final createdController =
        TextEditingController(text: user['created_at'] ?? '');
    bool isWholesaler = user['is_wholesaler'] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 12,
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.85,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ManagerStrings.editUserData,
                    style: TextStyle(
                     fontFamily:  ManagerFontFamily.fontFamily,
                      fontSize: ManagerFontSize.s18,
                      fontWeight: FontWeight.bold,
                      color: ManagerColors.primaryColor,
                      shadows: [
                        Shadow(
                          color: ManagerColors.primaryColor.withOpacity(0.3),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: ManagerHeight.h20),
                  _buildStyledTextField(emailController, ManagerStrings.email,
                      icon: Icons.email),
                   SizedBox(height: ManagerHeight.h12),
                  _buildStyledTextField(roleController, ManagerStrings.users,
                      icon: Icons.badge),
                   SizedBox(height: ManagerHeight.h12),
                  _buildStyledTextField(nameController, ManagerStrings.fullName,
                      icon: Icons.person),
                   SizedBox(height: ManagerHeight.h12),
                  _buildStyledTextField(phoneController, ManagerStrings.phone,
                      icon: Icons.phone),
                   SizedBox(height: ManagerHeight.h12),
                  _buildStyledTextField(
                      createdController, ManagerStrings.registrationDate,
                      icon: Icons.calendar_today, enabled: false),
                   SizedBox(height: ManagerHeight.h20),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: ManagerColors.pink50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.store,
                            color: ManagerColors.primaryColor),
                         SizedBox(width: ManagerWidth.w8),
                        Expanded(
                          child: Text(ManagerStrings.wholesaler,
                              style:  getRegularTextStyle(fontSize: ManagerFontSize.s18, color: ManagerColors.black)),
                        ),
                        StatefulBuilder(builder: (context, setStateDialog) {
                          return Switch(
                            activeColor: ManagerColors.pink,
                            value: isWholesaler,
                            onChanged: (val) {
                              setStateDialog(() {
                                isWholesaler = val;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                   SizedBox(height: ManagerHeight.h12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        icon:  const Icon(Icons.close, color: ManagerColors.red),
                        label: Text(ManagerStrings.cancel,
                            style:  getRegularTextStyle(color: ManagerColors.red, fontSize: ManagerFontSize.s20)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton.icon(
                        label: Text(ManagerStrings.saved,
                            style:
                                 getRegularTextStyle(fontSize: ManagerFontSize.s16, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ManagerColors.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          elevation: 7,
                          shadowColor: Colors.white,
                        ),
                        icon: const Icon(Icons.check_circle_outline,
                            color: Colors.white),
                        onPressed: () {
                          final updatedUser = {
                            ...user,
                            'email': emailController.text.trim(),
                            'role': roleController.text.trim(),
                            'full_name': nameController.text.trim(),
                            'image': imageController.text.trim(),
                            'phone': phoneController.text.trim(),
                            'is_wholesaler': isWholesaler,
                          };
                          updateUser(updatedUser);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStyledTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      style: getRegularTextStyle(fontSize: ManagerFontSize.s16, color: ManagerColors.black),
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: getRegularTextStyle(fontSize: ManagerFontSize.s12, color: ManagerColors.black),
        prefixIcon:
            icon != null ? Icon(icon, color: ManagerColors.primaryColor) : null,
        filled: true,
        fillColor: ManagerColors.pinkBackground,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ManagerColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: ManagerColors.primaryColor, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ManagerColors.white,
        title: Text(ManagerStrings.userManagement,
            style: getBoldTextStyle(fontSize: ManagerFontSize.s20, color: ManagerColors.primaryColor)
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchUsers,
            tooltip: ManagerStrings.update,
            color: ManagerColors.primaryColor,
          ),
        ],
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(color: ManagerColors.primaryColor))
          : users.isEmpty
              ?  Center(
                  child: Text(
                    ManagerStrings.userProfileFailed,
                    style:
                    getMediumTextStyle(
                        fontSize: ManagerFontSize.s18,
                        color: ManagerColors.primaryColor,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: users.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      color: ManagerColors.card,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding:  const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: ManagerColors.primaryColor,
                            backgroundImage: (user['image'] != null && user['image'].toString().isNotEmpty)
                                ? NetworkImage(user['image'])
                                : null,
                            radius: 25,
                            child: (user['image'] == null || user['image'].toString().isEmpty)
                                ? Text(
                              (user['full_name'] != null && user['full_name'].toString().isNotEmpty)
                                  ? user['full_name'].toString()[0].toUpperCase()
                                  : '',
                              style: getRegularTextStyle(
                                color: ManagerColors.white,
                                fontSize: ManagerFontSize.s25,
                              ),
                            )
                                : null,
                          ),
                        ),


                        title: Text(
                          user['full_name'] ?? 'no name',
                          style:  getMediumTextStyle(
                               fontSize: ManagerFontSize.s18,
                          color: ManagerColors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('${ManagerStrings.email}: ${user['email'] ?? 'غير متوفر'}',
                              style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s10,
                                color: ManagerColors.black),),
                            Text('${ManagerStrings.users}: ${user['role'] ?? 'غير محدد'}', style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s10,
                                color: ManagerColors.black),),
                            Text('${ManagerStrings.phone}: ${user['phone'] ?? 'غير متوفر'}', style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s10,
                                color: ManagerColors.black),),
                          ],
                        ),
                        trailing: Switch(
                          activeColor: ManagerColors.primaryColor,
                          value: user['is_wholesaler'] ?? false,
                          onChanged: (_) => showEditDialog(user),
                        ),
                        onTap: () => showEditDialog(user),
                      ),
                    );
                  },
                ),
    );
  }
}
