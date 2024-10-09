import 'package:dine_ease/data/category_list.dart';
import 'package:dine_ease/view/category/category_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCategoryRow extends StatelessWidget {
  const HomeCategoryRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categoryList.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Get.to(() =>  CategoryPage(category: categoryList[index].name,),
                    transition: Transition.leftToRight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      backgroundImage: categoryList[index].image,
                    ),
                    Text(
                      categoryList[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
