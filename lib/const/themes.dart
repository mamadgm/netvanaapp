// مدل EspTheme به همراه isColorSingle (فرضی، اگر ندارید اضافه کنید)
class EspTheme {
  final int id;
  final String name;
  final List<ContentItem> content;
  final bool isOrganization;
  final Category category;

  EspTheme({
    required this.id,
    required this.name,
    required this.content,
    required this.isOrganization,
    required this.category,
  });

  bool get isColorSingle {
    // مثلا اگر مقدار m تو content برابر 0 باشه فرض کنیم تک‌رنگه
    if (content.isEmpty) return false;
    return content.first.m == 0;
  }

  factory EspTheme.fromJson(Map<String, dynamic> json) {
    return EspTheme(
      id: json['id'],
      name: json['name'],
      content: (json['content'] as List)
          .map((e) => ContentItem.fromJson(e))
          .toList(),
      isOrganization: json['is_organization'] ?? false,
      category: Category.fromJson(json['category']),
    );
  }
}

class ContentItem {
  final int s;
  final int e;
  final int m;
  final int sp;
  final dynamic c;

  ContentItem({
    required this.s,
    required this.e,
    required this.m,
    required this.sp,
    this.c,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      s: json['s'],
      e: json['e'],
      m: json['m'],
      sp: json['sp'],
      c: json['c'],
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

// تابع کمکی برای آدرس تصویر
String getPicUrlByThemeName(String name) {
  switch (name) {
    case "تک رنگ":
      return "assets/themes/static.png";
    case "آکواریوم":
      return "assets/themes/fish.png";
    case "رنگین کمان":
      return "assets/themes/rainbow.png";
    case "نفس کشیدن":
      return "assets/themes/fade.png";
    case "چشمک زن":
      return "assets/themes/blink.png";
    case "دریا":
      return "assets/themes/sea.png";
    case "رنگ آمیزی":
      return "assets/themes/paint.png";
    case "جشن و پارتی":
      return "assets/themes/party.png";
    case "نور فراری":
      return "assets/themes/run.png";
    case "نور چرخان":
      return "assets/themes/circle.png";
    case "پلیسی":
      return "assets/themes/police.png";
    case "نور چرخان رنگی":
      return "assets/themes/circle2.png";
    case "رقص":
      return "assets/themes/dance.png";
    default:
      return "assets/themes/run.png";
  }
}
