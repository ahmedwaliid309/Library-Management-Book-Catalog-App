import 'package:flutter/material.dart';

class BottomSheetScreen extends StatelessWidget {
  const BottomSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "أضف كتاب لمكتبتي",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "اختر الكتاب والرف المناسب",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10),
                  ),
                ],
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SearchBar(
            hintText: "ابحث عن كتاب",
            onChanged: (value) {
              // Handle search input change
            },
            shape: MaterialStateOutlinedBorder.fromMap({
              MaterialState.focused: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
              MaterialState.hovered: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
              ),
              MaterialState.pressed: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
              ),

            }
          ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.book),
                  title: Text("Book Title $index"),
                  subtitle: Text("Author Name"),
                  trailing: Icon(Icons.add),
                  onTap: () {
                    // Handle book selection
                  },
                ),
              );
            },
              itemCount: 10,
            ),
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(alignment: Alignment.bottomRight,
                  child: Text("اضفه الي رف ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),)),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(child: Text("اريد قراءته", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white,fontSize: 12),))),
                  SizedBox(width: 10),
                  Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(child: Text("أقراء حاليا", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black,fontSize: 12),))),
                  SizedBox(width: 10),
                  Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(child: Text("مكتمل", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black,fontSize: 12),))),
                ],
              ),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 60,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: Center(child: Text("الغاء", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black,fontSize: 12),))),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    // Handle add to library action
                  },
                  child: Container(
                      height: 60,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(child: Text("أضافة الي المكتبة", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white,fontSize: 12),))),
                ),
              ],)
            ],
          )
        ],
      ),
    );
  }
}
