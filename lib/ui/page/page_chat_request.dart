import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siri_wave/siri_wave.dart';

import '../../domain/entities/model_request.dart';
import '../provider/provider_chat_request.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_socket.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageChatRequest extends StatefulWidget {
  const PageChatRequest({Key? key}) : super(key: key);

  @override
  State<PageChatRequest> createState() => _PageChatRequestState();
}

class _PageChatRequestState extends State<PageChatRequest> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderChatRequest>().updateViewChat();
    context.read<ProviderChatRequest>().initialAudioPlayer();
    context.read<ProviderChatRequest>().optionChat!.isNotEmpty
        ? const Option().messageFast(context)
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          'Chat con ${prPrincipalRead.modelRequestActive!.requestData!.user!.names!.contains(' ') ? prPrincipalRead.modelRequestActive!.requestData!.user!.names!.split(' ')[0] : prPrincipalRead.modelRequestActive!.requestData!.user!.names!}',
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: GlobalLabel.typeLetterTitle,
              color: GlobalColors.colorLetterTitle),
        ),
        leading: IconButton(
            color: GlobalColors.colorButton,
            onPressed: () {
              if (MediaQuery.of(context).viewInsets.bottom > 0) {
                GlobalFunction().hideQuery();
              } else {
                Navigator.pop(context);
              }
            },
            icon: const WidgetIcon(
                icon: Icons.arrow_back_ios,
                size: 20,
                colors: GlobalColors.colorLetterTitle)),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: GlobalColors.colorWhite,
      ),
      backgroundColor: GlobalColors.colorWhite,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              GlobalFunction().backgroundImage(),
              const Column(
                children: [
                  Option(),
                  ListChat(),
                  TextFieldData(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  const Option({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prChatRequestRead = context.read<ProviderChatRequest>();
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (prChatRequestRead.optionChat!.isEmpty) return;
                GlobalFunction().hideQuery();
                messageFast(context);
              },
              child: WidgetContainer(
                  widget: Row(
                    children: [
                      const Expanded(
                          flex: 0,
                          child: WidgetIcon(
                              icon: Icons.sms,
                              size: 15,
                              colors: GlobalColors.colorWhite)),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: const WidgetTextFieldPersonalized(
                              type: 1,
                              color: GlobalColors.colorWhite,
                              size: 16,
                              title: GlobalLabel.textMessageFast,
                              align: TextAlign.left),
                        ),
                      ),
                      const Expanded(
                          flex: 0,
                          child: WidgetIcon(
                              icon: Icons.touch_app_rounded,
                              size: 25,
                              colors: GlobalColors.colorWhite)),
                    ],
                  ),
                  color: GlobalColors.colorButton),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 0,
            child: SizedBox(
              width: 50,
              child: GestureDetector(
                  onTap: () {
                    if (prPrincipalRead.modelRequestActive!.requestData !=
                        null) {
                      GlobalFunction().dialCall(prPrincipalRead
                          .modelRequestActive!.requestData!.user!.phone!);
                    }
                  },
                  child: const CircleAvatar(
                    backgroundColor: GlobalColors.colorButton,
                    child: WidgetIcon(
                        icon: Icons.phone,
                        size: 30,
                        colors: GlobalColors.colorWhite),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  messageFast(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 100));
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: GlobalFunction.context.currentContext!,
      builder: (context) => Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: GlobalColors.colorBackground,
                  border: Border.all(
                    width: .2,
                    color: GlobalColors.colorBorder,
                  ),
                ),
                child: Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 15.0, right: 15.0, bottom: 20),
                    child: const ListOptionMessage()),
              ),
            ),
          ),
        ),
      ),
    );
    return null;
  }
}

class TextFieldData extends StatelessWidget {
  const TextFieldData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prChatRequestRead = context.read<ProviderChatRequest>();
    final prChatRequestWatch = context.watch<ProviderChatRequest>();

    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 10),
              child: WidgetContainer(
                color: GlobalColors.colorWhite,
                widget: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: prChatRequestRead.editChat,
                  onChanged: (text) {
                    if (text.trim().isNotEmpty) {
                      prChatRequestWatch.typeChat = true;
                    } else {
                      prChatRequestWatch.typeChat = false;
                    }
                  },
                  style: const TextStyle(
                      fontFamily: GlobalLabel.typeLetterTitle,
                      color: GlobalColors.colorLetterTitle),
                  decoration: InputDecoration(
                    hintText: GlobalLabel.textWriteMessage,
                    labelStyle:
                        const TextStyle(color: GlobalColors.colorBackground),
                    contentPadding: const EdgeInsets.only(left: 10),
                    hintStyle: const TextStyle(
                        fontFamily: GlobalLabel.typeLetterSubTitle,
                        fontSize: 16,
                        color: GlobalColors.colorLetterSubTitle),
                    filled: true,
                    fillColor: GlobalColors.colorWhite,
                    isCollapsed: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                          width: .5, color: GlobalColors.colorWhite),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                          width: .5, color: GlobalColors.colorWhite),
                    ),
                  ),
                ),
              ),
            )),
            const Expanded(flex: 0, child: ButtonSend()),
          ],
        ),
      ),
    );
  }
}

class ButtonSend extends StatelessWidget {
  const ButtonSend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prChatRequestRead = context.read<ProviderChatRequest>();
    final prChatRequestWatch = context.watch<ProviderChatRequest>();
    final prServiceSocketsRead = context.read<ProviderServiceSocket>();
    return Center(
      child: prChatRequestWatch.typeChat
          ? Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CircleAvatar(
                backgroundColor: GlobalColors.colorGreenAqua,
                child: GestureDetector(
                  onTap: () {
                    prServiceSocketsRead.sendChat(
                        1, 1, prChatRequestRead.editChat.text.trim());
                  },
                  child: const WidgetIcon(
                      icon: Icons.send,
                      size: 25,
                      colors: GlobalColors.colorWhite),
                ),
              ),
            )
          : GestureDetector(
              onLongPress: () {
                GlobalFunction().playAudio(GlobalLabel.directionAudio);
                prChatRequestRead.startOrStopRecording(context);
              },
              onLongPressUp: () {
                prChatRequestRead.startOrStopRecording(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: CircleAvatar(
                  backgroundColor: GlobalColors.colorGreenAqua,
                  child: WidgetIcon(
                      icon: Icons.mic_rounded,
                      size: 30,
                      colors: GlobalColors.colorWhite),
                ),
              ),
            ),
    );
  }
}

class ListOptionMessage extends StatelessWidget {
  const ListOptionMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prChatRequestRead = context.watch<ProviderChatRequest>();
    final prServiceSocketRead = context.watch<ProviderServiceSocket>();

    return Container(
      margin: const EdgeInsets.all(10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: prChatRequestRead.optionChat!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              prServiceSocketRead.sendChat(
                  2, 1, prChatRequestRead.optionChat![index].message!);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: WidgetContainer(
                widget: Row(
                  children: [
                    Expanded(
                      child: WidgetTextFieldTitle(
                          title: prChatRequestRead.optionChat![index].message!,
                          align: TextAlign.left),
                    ),
                    const Expanded(
                        flex: 0,
                        child: WidgetIcon(
                            icon: Icons.navigate_next_rounded,
                            size: 20,
                            colors: GlobalColors.colorIcon))
                  ],
                ),
                color: GlobalColors.colorWhite,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ListChat extends StatelessWidget {
  const ListChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prChatRequestRead = context.read<ProviderChatRequest>();
    final prChatRequestWatch = context.watch<ProviderChatRequest>();
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          controller: prChatRequestRead.controller,
          physics: const BouncingScrollPhysics(),
          itemCount: prChatRequestWatch.listMessage!.length,
          itemBuilder: (context, index) {
            return ItemChat(
              chat: prChatRequestWatch.listMessage![index],
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({Key? key, required this.chat, required this.index})
      : super(key: key);
  final Chat chat;
  final int index;

  @override
  Widget build(BuildContext context) {
    return chat.uid == '123'
        ? MyMessage(chat: chat, index: index)
        : YourMessage(chat: chat, index: index);
  }
}

class YourMessage extends StatelessWidget {
  const YourMessage({Key? key, required this.chat, required this.index})
      : super(key: key);
  final Chat chat;
  final int index;

  @override
  Widget build(BuildContext context) {
    final prChatRequestRead = context.read<ProviderChatRequest>();
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(GlobalFunction.context.currentContext!).size.width *
                  0.80,
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: GlobalColors.colorWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: GlobalColors.colorBorder.withOpacity(.5),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (chat.typeChat == 4) ...[
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 0,
                          child: GestureDetector(
                            onTap: () {
                              if (!chat.isPlaying!) {
                                prChatRequestRead.playAudioChat(chat.message!);
                                prChatRequestRead.indexAudioPlaying = index;
                              }
                            },
                            child: Icon(
                                !chat.isPlaying!
                                    ? Icons.play_arrow_rounded
                                    : Icons.stop_rounded,
                                size: 40),
                          )),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          width: 60,
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: chat.isPlaying!
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
                              : chat.isPlaying!
                                  ? GlobalFunction().designChatAudio(true)
                                  : GlobalFunction().designChatAudio(false),
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: WidgetTextFieldSubTitle(
                            title:
                                '${chat.hour!.split(':')[0]}:${chat.hour!.split(':')[1]}',
                            align: TextAlign.center),
                      )
                    ],
                  ),
                ],
              )
            ] else if (chat.typeChat == 2) ...[
              ImageChat(chat: chat)
            ] else if (chat.typeChat == 1) ...[
              WidgetTextFieldTitle(title: chat.message!, align: TextAlign.left),
              const SizedBox(
                height: 5,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MyMessage extends StatelessWidget {
  const MyMessage({Key? key, required this.chat, required this.index})
      : super(key: key);
  final Chat chat;
  final int index;

  @override
  Widget build(BuildContext context) {
    final prChatRequestRead = context.read<ProviderChatRequest>();

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(GlobalFunction.context.currentContext!).size.width *
                  0.80,
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: GlobalColors.colorMyChat,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: GlobalColors.colorMyChat.withOpacity(.5),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (chat.typeChat == 4) ...[
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 0,
                          child: GestureDetector(
                            onTap: () {
                              if (!chat.isPlaying!) {
                                prChatRequestRead.playAudioChat(chat.message!);
                                prChatRequestRead.indexAudioPlaying = index;
                              }
                            },
                            child: Icon(
                                !chat.isPlaying!
                                    ? Icons.play_arrow_rounded
                                    : Icons.stop_rounded,
                                size: 40),
                          )),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          width: 60,
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: chat.isPlaying!
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
                              : chat.isPlaying!
                                  ? GlobalFunction().designChatAudio(true)
                                  : GlobalFunction().designChatAudio(false),
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: WidgetTextFieldSubTitle(
                            title:
                            '${chat.hour!.split(':')[0]}:${chat.hour!.split(':')[1]}', align: TextAlign.center),
                      )
                    ],
                  ),
                ],
              )
            ] else if (chat.typeChat == 2) ...[
              ImageChat(chat: chat)
            ] else if (chat.typeChat == 1) ...[
              WidgetTextFieldTitle(title: chat.message!, align: TextAlign.left),
              const SizedBox(
                height: 5,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ImageChat extends StatelessWidget {
  const ImageChat({Key? key, required this.chat}) : super(key: key);
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog<String>(
          context: GlobalFunction.context.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return PopScope(
                canPop: false,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(GlobalFunction.context.currentContext!);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: GlobalColors.colorBackgroundView,
                    child: Center(
                      child: FractionallySizedBox(
                        alignment: Alignment.center,
                        child: Image.file(File(chat.url!)),
                      ),
                    ),
                  ),
                ));
          },
        );
      },
      child:
          SizedBox(width: 120, height: 120, child: Image.file(File(chat.url!))),
    );
  }
}
