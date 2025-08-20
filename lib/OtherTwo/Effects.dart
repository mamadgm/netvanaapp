// ignore_for_file: non_constant_identifier_names, file_names
import 'package:easy_container/easy_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/themes.dart';
import 'package:netvana/customwidgets/ThemeCard.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:netvana/const/figma.dart';

class Effectsscr extends StatefulWidget {
  const Effectsscr({super.key});

  @override
  State<Effectsscr> createState() => _EffectsscrState();
}

class _EffectsscrState extends State<Effectsscr> {
  @override
  void initState() {
    super.initState();
    // وقتی صفحه ساخته شد، تم‌ها رو بگیر
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = context.read<ProvData>();
      prov.fetchThemes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(
      builder: (context, value, child) {
        final themes = value.themes.isNotEmpty
            ? getFilteredAndSortedThemes(value, value.themes)
            : null;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      EasyContainer(
                        color: FIGMA.Back,
                        borderWidth: 0,
                        elevation: 0,
                        customMargin: const EdgeInsets.only(right: 24),
                        padding: 0,
                        child: Container(
                          color: FIGMA.Back,
                          child: Text(
                            "افکت های اختصاصی",
                            style: TextStyle(
                                fontFamily: FIGMA.abrlb,
                                fontSize: 28.sp,
                                color: FIGMA.Wrn),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  buildFilters(context),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3 / 4,
                    children: themes?.map((theme) {
                          return ThemeCard(
                            id: theme.id,
                            picUrl: getPicUrlByThemeName(theme.name),
                            bigText: theme.name,
                            smallText: theme.category.name,
                            scale: theme.content.isNotEmpty
                                ? theme.content.first.sp
                                : 0,
                            content: theme.content,
                          );
                        }).toList() ??
                        [],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

List<EspTheme> getFilteredAndSortedThemes(
    ProvData prov, List<EspTheme> allThemes) {
  List<EspTheme> filtered = [];

  switch (prov.selectedFilter) {
    case ThemeFilter.liked:
      filtered = allThemes.where((t) => prov.Favorites.contains(t.id)).toList();
      break;

    case ThemeFilter.single:
      filtered = allThemes
          .where((t) => t.content.every((item) => item.c == null))
          .toList();
      break;

    case ThemeFilter.multiple:
      filtered = allThemes
          .where((t) => t.content.any((item) => item.c != null))
          .toList();
      break;

    case ThemeFilter.none:
      filtered = [...allThemes];
      break;
  }

  filtered.sort((a, b) {
    final aFav = prov.Favorites.contains(a.id);
    final bFav = prov.Favorites.contains(b.id);
    if (aFav == bFav) return 0;
    return aFav ? -1 : 1;
  });

  return filtered;
}
