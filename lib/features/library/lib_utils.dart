import 'package:flutter/material.dart';
typedef OnTapCallback = void Function();
class LibUtils extends StatelessWidget {
  String imagePath;
  String text;
  OnTapCallback? onActionTap;


  LibUtils({required this.imagePath, required this.text, this.onActionTap});
  List<Items>items = [
    Items()
      ..imagePath = "assets/images/raffi.png"
      ..bookName = "كتاب 1"
      ..bookAuthor = "مؤلف 1",
    Items()
      ..imagePath = "assets/images/ic_books.png"
      ..bookName = "كتاب 2"
      ..bookAuthor = "مؤلف 2",
    Items()
      ..imagePath = "assets/images/ic_books.png"
      ..bookName = "كتاب 3"
      ..bookAuthor = "مؤلف 3",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 270,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(15),
        ),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      borderRadius:
                      BorderRadius.circular(15),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),
                    ),

                    child: ImageIcon(
                      AssetImage(
                        imagePath,
                      ),
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),
                ),
                Text(text,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: onActionTap,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary,
                        borderRadius:
                        BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                        ),
                      ),

                      child: Icon(
                        Icons.add,
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),
                    ),
                  ),
                )
              ],
            ),
            items.isEmpty?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  AssetImage(
                    "assets/images/ic_books.png",
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "لا يوجد كتب في مكتبتك",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            )
                :Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image.asset("${items[index].imagePath}",fit: BoxFit.fill,),
                                IconButton(onPressed: onActionTap, icon: Icon(Icons.favorite_border_outlined))
                                  ],
                                ),
                          ),
                        );
                      },
                                    ),
                                  ),
                    ],
                  ),
                ),
          ],
        )

    );
  }
}
class Items{
  String? imagePath;
  String? bookName;
  String? bookAuthor;
}
