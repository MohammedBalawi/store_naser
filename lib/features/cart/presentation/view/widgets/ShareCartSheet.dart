import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class ShareCartSheet extends StatelessWidget {
  final String shareText;
  const ShareCartSheet({super.key, required this.shareText});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text(
                   ManagerStrings.shareWith
                  ,
                  style: getBoldTextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ShareIcon(label: ManagerStrings.copy, icon: ManagerImages.copy, onTap: () async {
                  await Clipboard.setData(ClipboardData(text: shareText));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(ManagerStrings.link)),
                  );
                }),
                _ShareIcon(label: ManagerStrings.telegrams, icon: ManagerImages.telegram, onTap: (){
                  Share.share(shareText);
                }),
                _ShareIcon(label:ManagerStrings.twitter , icon: ManagerImages.twitter, onTap: (){
                  Share.share(shareText);
                }),
                _ShareIcon(label: ManagerStrings.whatsapp, icon: ManagerImages.whatsapp, onTap: (){
                  Share.share(shareText);
                }),
                _ShareIcon(label: ManagerStrings.e_mail, icon: ManagerImages.email, onTap: (){
                  Share.share(shareText, subject: ManagerStrings.MyShoppingCart);
                }),





              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareIcon extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onTap;

  const _ShareIcon({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFF4ECFF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                height: 22,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: getRegularTextStyle(
              fontSize: 12,
              color: ManagerColors.black,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

