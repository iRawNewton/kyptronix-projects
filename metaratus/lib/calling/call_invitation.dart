import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallInvitationPage extends StatelessWidget {
  const CallInvitationPage({
    super.key,
    required this.child,
    required this.username,
  });

  final Widget child;
  final String username;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return ZegoUIKitPrebuiltCallWithInvitation(
    //   appID: 973715559,
    //   appSign:
    //       '769698967cc1c13f99bc5d26a0c51999115eb8f9ae63021ff61858b8d9f8f2f6',
    //   userID: username,
    //   userName: username,
    //   // plugins: [ZegoUIKitSignalingPlugin()],
    //   // ringtoneConfig: const ZegoRingtoneConfig(),
    //   showDeclineButton: true,
    //   child: child,
    // );
  }
}
