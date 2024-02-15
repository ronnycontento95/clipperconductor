
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siri_wave/siri_wave.dart';

import '../../domain/entities/model_request.dart';
import '../provider/provider_walkies_talkie.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';

class PageWalkiesTalkie extends StatefulWidget {
  const PageWalkiesTalkie({Key? key}) : super(key: key);

  @override
  State<PageWalkiesTalkie> createState() => _PageWalkiesTalkieState();

}

class _PageWalkiesTalkieState extends State<PageWalkiesTalkie> {

  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion(
      value: GlobalFunction().colorBarView(),
      child: Scaffold(
        appBar: AppBar(
          title: const AutoSizeText(
            GlobalLabel.textBack,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: GlobalLabel.typeLetterTitle,
                color: GlobalColors.colorButton),
          ),
          leading: IconButton(
            color: GlobalColors.colorButton,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          elevation: 0,
          backgroundColor: GlobalColors.colorWhite,
        ),
        backgroundColor: GlobalColors.colorBorder,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GlobalColors.colorWhite,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: GlobalColors.colorWhite,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                GlobalFunction().backgroundImage(),
                 const Column(
                  children: [
                    SelectTypeAudio(),
                    ListChat(),
                    ButtonAudio(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListChat extends StatelessWidget {
  const ListChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prWalkieTalkieWatch = context.watch<ProviderWalkiesTalkie>();
    return Expanded(
      child: ListView.builder(
        controller: prWalkieTalkieWatch.scrollControllerList,
        padding: const EdgeInsets.only(bottom: 10, top: 20),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        reverse: true,
        itemCount: prWalkieTalkieWatch.positionSelectedRequest == 1
            ? prWalkieTalkieWatch.listFilterChatAudioBusiness.length
            : prWalkieTalkieWatch.positionSelectedRequest == 2
            ? prWalkieTalkieWatch.listFilterChatAudioCallCenter.length
            : prWalkieTalkieWatch.listFilterChatAudioAllDriver.length,
        itemBuilder: (context, index) {
          return ItemChat(chat: prWalkieTalkieWatch.positionSelectedRequest == 1
              ? prWalkieTalkieWatch.listFilterChatAudioBusiness[index]
              : prWalkieTalkieWatch.positionSelectedRequest == 2
              ? prWalkieTalkieWatch.listFilterChatAudioCallCenter[index]
              : prWalkieTalkieWatch
              .listFilterChatAudioAllDriver[index], index: index);
        },
        // reverse: true,
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({Key? key, required this.chat, required this.index}) : super(key: key);
  final Chat chat;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ChatMyMessage(chat: chat, index: index,);
  }
}

class ChatMyMessage extends StatelessWidget {
  const ChatMyMessage({Key? key, required this.chat, required this.index}) : super(key: key);
  final Chat? chat;
  final  int? index;

  @override
  Widget build(BuildContext context) {
    final prWalkiesTalkieWatch = context.watch<ProviderWalkiesTalkie>();
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
          constraints: BoxConstraints(
            maxWidth:
            MediaQuery.of(GlobalFunction.context.currentContext!)
                .size
                .width *
                0.80,
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: .1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 0,
                      child: GestureDetector(
                        onTap: () {
                          if (!chat!.isPlaying! && prWalkiesTalkieWatch.audioPlayerChat!.state != PlayerState.playing) {
                            prWalkiesTalkieWatch.playAudioChat(chat!.pathAudio!);
                            prWalkiesTalkieWatch.indexAudioPlaying = index!;
                          }
                        },
                        child: Icon(
                            !chat!.isPlaying!
                                ? Icons.play_arrow_rounded
                                : Icons.stop_rounded,
                            size: 40),
                      )),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: chat!.isPlaying!
                          ? SiriWave(
                        controller: SiriWaveController(
                            color: GlobalColors.colorBackgroundView),
                        options: SiriWaveOptions(
                          height: 40,
                          showSupportBar: true,
                          width: MediaQuery.of(GlobalFunction
                              .context.currentContext!)
                              .size
                              .width /
                              2,
                        ),
                        style: SiriWaveStyle.ios_7,
                      )
                          : chat!.isPlaying!
                          ? GlobalFunction().designChatAudio(true)
                          : GlobalFunction().designChatAudio(false),
                    ),
                  ),
                  Expanded(
                      flex: 0,
                      child: WidgetTextFieldSubTitle(title: chat!.hour!, align: TextAlign.center))
                ],
              ),
            ],
          )),
    );
  }
}




class SelectTypeAudio extends StatelessWidget {
  const SelectTypeAudio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prWalkTalkieWatch = context.watch<ProviderWalkiesTalkie>();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: CustomSlidingSegmentedControl<int>(
        initialValue: prWalkTalkieWatch.positionSelectedRequest,
        children: const {
          1: WidgetTextFieldPersonalized(type: 1,title: GlobalLabel.textRecordBusiness, align: TextAlign.center, size: 15, color: GlobalColors.colorWhite),
          2: WidgetTextFieldPersonalized(type: 1,title: GlobalLabel.textRecordCallCenter, align: TextAlign.center, size: 15, color: GlobalColors.colorWhite),
          3: WidgetTextFieldPersonalized(type: 1,title: GlobalLabel.textRecordAll, align: TextAlign.center, size: 15, color: GlobalColors.colorWhite),
        },
        decoration: BoxDecoration(
          color: GlobalColors.colorBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        thumbDecoration: BoxDecoration(
          color: GlobalColors.colorBackgroundView.withOpacity(.8),
          borderRadius: prWalkTalkieWatch.positionSelectedRequest == 1
              ? const BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
              : prWalkTalkieWatch.positionSelectedRequest == 2
              ? const BorderRadius.all(Radius.zero)
              : const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
        onValueChanged: (position) {
          prWalkTalkieWatch.positionSelectedRequest = position;
          prWalkTalkieWatch.deleteListChatAudio();
          prWalkTalkieWatch.chatFilterAudio();
        },
      ),
    );
  }
}

class ButtonAudio extends StatelessWidget {
  const ButtonAudio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prWalkiesTalkieWatch = context.watch<ProviderWalkiesTalkie>();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: GlobalColors.colorBackgroundView,
          border: Border.all(
            width: 0.5,
            color: GlobalColors.colorBackgroundView,
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: GestureDetector(
          onLongPress: () {
            prWalkiesTalkieWatch.startOrStopRecording(context, prWalkiesTalkieWatch.positionSelectedRequest, 2);
          },
          onLongPressUp: () {
            prWalkiesTalkieWatch.startOrStopRecording(context, prWalkiesTalkieWatch.positionSelectedRequest, 2);
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: prWalkiesTalkieWatch.isRecording
                    ? GlobalColors.colorOrange
                    : GlobalColors.colorButtonNavigation,
                radius: 25,
                child: const Icon(
                  Icons.graphic_eq_outlined,
                  color: GlobalColors.colorWhite,
                  size: 25,
                ),
              ),
              const SizedBox(width: 10),
              const WidgetTextFieldPersonalized(type: 1,title: GlobalLabel.textPushRecord, align: TextAlign.left, size: 15, color: GlobalColors.colorWhite)],
          ),
        ),
      ),
    );
  }
}

