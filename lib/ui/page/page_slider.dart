import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_slider.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_image_background.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import 'page_login.dart';

class PageSlider extends StatelessWidget {
  const PageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: GlobalFunction().colorBarView(),
      child: const Scaffold(
        backgroundColor: GlobalColors.colorWhite,
        body: Center(
            child: SafeArea(
                child: Stack(
          children: [
            WidgetImageBackground(name: 'imageBackground.png'),
            InformationSlider(),
            DostIndicator(),
          ],
        ))),
      ),
    );
  }
}

class InformationSlider extends StatelessWidget {
  const InformationSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final prSliderRead = context.read<ProviderSlider>();
    return PageView(
      onPageChanged: (index) {
        prSliderRead.updatePositionSlider(index);
      },
      children: const <Widget>[
        SliderOne(),
        SliderTwo(),
        SliderThree(),
        SliderFour(),
      ],
    );
  }
}

class SliderOne extends StatelessWidget {
  const SliderOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 0,
            child: SizedBox(
              height: 230,
              child: Image(
                  width: 350,
                  image: AssetImage(
                      '${GlobalLabel.directionImageInternal}slideruno.png')),
            ),
          ),
          SizedBox(height: 50),
          Column(
            children: [
              WidgetTextFieldTitle(
                  title: GlobalLabel.textTitleSliderOne, align: TextAlign.center),
              SizedBox(height: 10),
              WidgetTextFieldSubTitle(
                  title: GlobalLabel.textDescriptionSliderOne,
                  align: TextAlign.center)
            ],
          ),
        ],
      ),
    );
  }
}

class SliderTwo extends StatelessWidget {
  const SliderTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 0,
            child: SizedBox(
              height: 230,
              child: Image(
                  width: 350,
                  image: AssetImage(
                      '${GlobalLabel.directionImageInternal}sliderdos.png')),
            ),
          ),
          SizedBox(height: 50),
          Column(
            children: [
              WidgetTextFieldTitle(
                  title: GlobalLabel.textTitleSliderTwo, align: TextAlign.center),
              SizedBox(height: 10),
              WidgetTextFieldSubTitle(
                  title: GlobalLabel.textDescriptionSliderTwo,
                  align: TextAlign.center)
            ],
          ),
        ],
      ),
    );
  }
}

class SliderThree extends StatelessWidget {
  const SliderThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 0,
            child: SizedBox(
              height: 230,
              child: Image(
                  width: 350,
                  image: AssetImage(
                      '${GlobalLabel.directionImageInternal}slidertres.png')),
            ),
          ),
          SizedBox(height: 50),
          Column(
            children: [
              WidgetTextFieldTitle(
                  title: GlobalLabel.textTitleSliderThree,
                  align: TextAlign.center),
              SizedBox(height: 10),
              WidgetTextFieldSubTitle(
                  title: GlobalLabel.textDescriptionSliderThree,
                  align: TextAlign.center)
            ],
          ),
        ],
      ),
    );
  }
}

class SliderFour extends StatelessWidget {
  const SliderFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            flex: 0,
            child: SizedBox(
              height: 230,
              child: Image(
                  width: 350,
                  image: AssetImage(
                      '${GlobalLabel.directionImageInternal}slidercuatro.png')),
            ),
          ),
          //const SizedBox(height: 50),
          Column(
            children: [
              const WidgetTextFieldTitle(
                  title: GlobalLabel.textTitleSliderFour,
                  align: TextAlign.center),
              const SizedBox(height: 10),
              const WidgetTextFieldSubTitle(
                  title: GlobalLabel.textDescriptionSliderFour,
                  align: TextAlign.center),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: WidgetButton(
                    text: GlobalLabel.buttonBegin,
                    type: 1,
                    onPressed: () {
                      GlobalFunction().nextPageUntilView(const PageLogin());
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class DostIndicator extends StatelessWidget {
  const DostIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final prSliderWatch = context.watch<ProviderSlider>();
    return Container(
      alignment: Alignment.bottomCenter,
      child: DotsIndicator(
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Colors.grey.shade300,
            activeColor: GlobalColors.colorButton,
          ),
          dotsCount: 4,
          position: double.parse(prSliderWatch.positionSlider.toString())),
    );
  }
}
