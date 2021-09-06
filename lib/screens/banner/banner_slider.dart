import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class BannerSlider extends StatelessWidget {
  const BannerSlider({
    Key? key,
    @required this.buttonCarouselController,
    @required this.onPageChanged
  }) : super(key: key);

  final CarouselController? buttonCarouselController;
  final Function(int index, CarouselPageChangedReason changeReason)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
