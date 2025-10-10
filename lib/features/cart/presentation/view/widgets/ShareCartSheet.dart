import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class ShareCartSheet extends StatelessWidget {
  final String shareText; // نص المشاركة (مثلاً مجموع السلة/رابط)
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
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('مشاركة مع', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ShareIcon(label: 'البريد الإلكتروني', icon: Icons.alternate_email, onTap: (){
                  Share.share(shareText, subject: 'سلة مشترياتي');
                }),
                _ShareIcon(label: 'واتساب', icon: Icons.e_mobiledata, onTap: (){
                  Share.share(shareText);
                }),
                _ShareIcon(label: 'اكس', icon: Icons.share, onTap: (){
                  Share.share(shareText);
                }),
                _ShareIcon(label: 'تيليجرام', icon: Icons.send, onTap: (){
                  Share.share(shareText);
                }),
                _ShareIcon(label: 'نسخ', icon: Icons.copy, onTap: () async {
                  await Clipboard.setData(ClipboardData(text: shareText));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ الرابط/النص')),
                  );
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
  final IconData icon;
  final VoidCallback onTap;
  const _ShareIcon({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF4ECFF), // بنفسجي فاتح مثل اللقطة
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF8A4DD7)),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 64,
            child: Text(label, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
