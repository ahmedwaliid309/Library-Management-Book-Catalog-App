# رفّي (Raffi)

تطبيق Flutter لإدارة مكتبة الكتب الشخصية والمفضلة، بواجهة عربية (RTL).



## التقنيات

- Flutter + Material 3
- go_router (التنقل) + Bottom Nav بـ StatefulShellRoute
- flutter_screenutil (الأبعاد؛ حجم التصميم 390x844)
- خط Tajawal محلي (assets/fonts) بدل google_fonts
- RTL ثابت (`Locale('ar')`)

## الهيكل

```
lib/
├── main.dart
├── core/
│   ├── theme/      app_colors.dart, app_theme.dart
│   ├── router/     app_router.dart  (كل المسارات في AppRoutes)
│   └── widgets/    ويدجتس مشتركة
└── features/       فولدر لكل شاشة
```

## توزيع شاشات الـ UI

| الشاشة | المسؤول | الملف |
|--------|---------|-------|
| Splash | إيمان | features/splash |
| تفاصيل الكتاب | إيمان | features/book_details |
| Onboarding | سارة | features/onboarding |
| عن التطبيق | سارة | features/about |
| Home + الفلتر + عرض الكل | معاذ | features/home |
| Search | أحمد وليد | features/search |
| مكتبتي + إضافة كتاب | أحمد عطا | features/library |
| المفضلة (فاضية / مليانة) | السيد | features/favorites |

## قواعد الشغل

1. كل واحد Branch باسم شاشته: `feature/home`، `feature/search`...
2. ممنوع الرفع على `main` مباشرة. Pull Request فقط.
3. ممنوع كتابة ألوان أو خطوط يدوي. استخدم `AppColors` و`Theme.of(context)`.
4. الأبعاد بـ `.w` و`.h` و`.r` و`.sp` من screenutil.
5. التنقل بـ `AppRoutes` فقط.
6. شغل في فولدر شاشتك فقط. لو محتاج تعدل في `core/` كلم وليد.
7. قبل كل يوم شغل: `git checkout main && git pull`.

## المواعيد

- UI: لحد 16 بليل
- اللوجيك والربط: من 17 لحد 19
- التجربة والتسليم: 20
