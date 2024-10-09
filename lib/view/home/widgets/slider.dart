import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeSlider extends StatelessWidget {
  const HomeSlider({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "https://marketplace.canva.com/EAFanHj4_og/1/0/1600w/canva-yellow-red-modern-food-promotion-banner-landscape-D5j43WWUmtA.jpg",
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "https://marketplace.canva.com/EAE5z64hb14/1/0/1600w/canva-red-yellow-burger-food-menu-banner-TI0aNByie7I.jpg",
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "https://design-assets.adobeprojectm.com/content/download/express/public/urn:aaid:sc:VA6C2:b27d5344-6cd0-4d55-acae-0003d8f49923/component?assetType=TEMPLATE&etag=1832a094e6fea039a25be61cb93537b2&revision=0&component_id=bd5a1e36-37f0-438d-9cf0-e4b9defc1e60",
              ),
            ),
          ),
        ),
      ],
      options: CarouselOptions(
        height: size.height * 0.15,
        aspectRatio: 16 / 9,
        viewportFraction: 0.95,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
      ),
    );
  }
}
