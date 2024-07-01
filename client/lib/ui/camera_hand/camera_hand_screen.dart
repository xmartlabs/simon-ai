// ignore_for_file: unused-files, unused-code
import 'package:auto_route/auto_route.dart';
import 'package:design_system/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/ui/camera_hand/camera_hand_cubit.dart';
import 'package:simon_ai/ui/widgets/camera/camera_widget.dart';

@RoutePage()
class CameraHandScreen extends StatelessWidget {
  const CameraHandScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => CameraHandCubit(),
        child: _CameraHandContentScreen(),
      );
}

class _CameraHandContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CameraHandCubit, CameraHandState>(
        builder: (context, state) => Scaffold(
          backgroundColor: context.theme.colorScheme.secondary,
          appBar: AppBar(
            title: const Text('Camera Hand Tracking'),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                CameraWidget(
                  width: 480,
                  height: 640,
                  enableBorderRadius: true,
                  onNewFrame: (dynamic frame) {
                    context.read<CameraHandCubit>().onNewFrame(frame);
                  },
                  movenetStream: state.movenetResultStream,
                ),
              ],
            ),
          ),
        ),
      );
}
