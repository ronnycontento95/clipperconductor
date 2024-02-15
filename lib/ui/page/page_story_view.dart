import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:story_view/widgets/story_view.dart';
import '../provider/provider_notification.dart';

class PageStoriesView extends StatefulWidget {
  const PageStoriesView({super.key});

  @override
  State<PageStoriesView> createState() => _PageStoriesViewState();
}

class _PageStoriesViewState extends State<PageStoriesView> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderNotification>().addStoryItems(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prNotificationsRead = context.read<ProviderNotification>();

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent),
      child: Scaffold(
        body: StoryView(
          storyItems: prNotificationsRead.storyItems,
          onStoryShow: (s) {
          },
          onComplete: () {
            prNotificationsRead.viewStory(context);
            prNotificationsRead.storyController.dispose();
            Navigator.pop(context);
          },
          progressPosition: ProgressPosition.top,
          repeat: false,
          controller: prNotificationsRead.storyController,
        ),
      ),
    );
  }
}
