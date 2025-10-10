import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../data/models/reel.dart';

class ReelCard extends StatelessWidget {
  const ReelCard({
    super.key,
    required this.reel,
    this.onPlay,
    this.onShare,
    this.onOrderNow,
  });

  final Reel reel;
  final VoidCallback? onPlay;
  final VoidCallback? onShare;
  final VoidCallback? onOrderNow;

  @override
  Widget build(BuildContext context) {
    final ImageProvider img = reel.isNetwork
        ? NetworkImage(reel.cover)
        : AssetImage(reel.cover) as ImageProvider;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 9 / 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(ManagerImages.reelsa, fit: BoxFit.cover,),

                const _BottomGradient(),

                Center(
                  child: InkWell(
                    onTap: onPlay,
                    customBorder: const CircleBorder(),
                    child:  SvgPicture.asset(ManagerImages.play,height: 70,),
                  ),
                ),

                Positioned(
                  right: 25,
                  bottom: 80, // فوق العنوان بقليل
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _PillButton(
                        label: 'مشاركة',
                        icon: ManagerImages.shares,
                        bg: ManagerColors.greens,
                        fg: Colors.black87,
                        onTap: onShare,
                        f: ManagerColors.black,
                      ),
                      const SizedBox(height: 10),
                      _PillButton(
                        label: 'اطلب الآن',
                        icon: ManagerImages.carbon_product,
                        bg: ManagerColors.popp_new,
                        fg: ManagerColors.pop_color,
                        onTap: onOrderNow,
                        f: ManagerColors.white,

                      ),
                    ],
                  ),
                ),

                Positioned(
                  left: 12,
                  right: 25,
                  bottom: 35,
                  child: Text(
                    reel.title,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getMediumTextStyle(fontSize: 16, color: Colors.white).copyWith(
                      shadows: const [
                        Shadow(blurRadius: 6, color: Colors.black54, offset: Offset(0, 1)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    this.icon,
    this.svgIcon,
    required this.bg,
    required this.fg,
    required this.f,
    this.onTap,
  });

  final String label;
  final String? icon;
  final String? svgIcon;
  final Color bg;
  final Color fg;
  final Color f;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          height: 34,
          width: 108,
          padding: const EdgeInsetsDirectional.only(start: 12, end: 14, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 6),
                  child:SvgPicture.asset(icon!)
                ),
              if (svgIcon != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 6),
                  child: SvgPicture.asset(svgIcon!, width: 16, height: 16, color: fg),
                ),
              Text(label, style: getMediumTextStyle(fontSize: 12, color: f)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomGradient extends StatelessWidget {
  const _BottomGradient();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.0, 0.5],
            colors: [
              Colors.black.withOpacity(.55),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
