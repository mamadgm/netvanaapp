import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:provider/provider.dart';

class Spelco extends StatelessWidget {
  final Function(int) handlechange;

  const Spelco({super.key, required this.handlechange});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(index: 0, icon: Icons.electric_bolt_rounded, label: "سرعت"),
      _NavItem(index: 1, icon: HugeIcons.strokeRoundedSun01, label: "روشنایی"),
      _NavItem(index: 2, icon: Icons.color_lens, label: "رنگ"),
    ];

    return LayoutBuilder(
      builder: (context, constsize) {
        return Consumer<ProvData>(
          builder: (context, value, child) {
            return Container(
              decoration: BoxDecoration(
                color: FIGMA.Gray,
                border: Border.all(color: FIGMA.Gray, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items.map((item) {
                  final isActive = value.current_selected_slider == item.index;
                  return Expanded(
                    child: InkWell(
                      onTap: () => handlechange(item.index),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        // padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: isActive ? FIGMA.Gray2 : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          height: constsize.maxHeight * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (isActive)
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontFamily: FIGMA.estsb,
                                    fontSize: 13.sp,
                                    color: FIGMA.Wrn,
                                  ),
                                ),
                              SizedBox(width: 6.w),
                              Icon(
                                item.icon,
                                size: 24.w,
                                color: isActive ? FIGMA.Orn : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}

class _NavItem {
  final int index;
  final IconData icon;
  final String label;

  _NavItem({required this.index, required this.icon, required this.label});
}
