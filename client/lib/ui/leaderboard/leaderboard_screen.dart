import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_button.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/gen/assets.gen.dart';
import 'package:simon_ai/ui/common/app_constrained_widget.dart';
import 'package:simon_ai/ui/extensions/context_device_extensions.dart';
import 'package:simon_ai/ui/leaderboard/leaderboard_cubit.dart';

@RoutePage()
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => LeaderboardCubit(),
        child: _LeaderboardContentScreen(),
      );
}

class _LeaderboardContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppScaffold(
        showBackButton: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const _LeaderboardHeader(),
                context.isSmallAndLandscapeDevice
                    ? const _SmallAndLanscapeDeviceContent()
                    : const _BigAndPortraitDeviceContent(),
              ],
            ),
          ],
        ),
      );
}

class _SmallAndLanscapeDeviceContent extends StatelessWidget {
  const _SmallAndLanscapeDeviceContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const _CurrentPlayerCard(),
              SizedBox(height: 24.h),
              const _ResetGameButtonsSection(),
            ],
          ),
          const SizedBox(
            width: 32,
          ),
          Expanded(
            child: SizedBox(height: .57.sh, child: const _LeaderboardList()),
          ),
        ],
      );
}

class _ResetGameButtonsSection extends StatelessWidget {
  const _ResetGameButtonsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      BlocSelector<LeaderboardCubit, LeaderboardState, bool>(
        selector: (state) => state.isAdminNotAuthenticated,
        builder: (context, isAdminNotAuthenticated) => Column(
          children: [
            AppButton(
              onPressed: () => context.read<LeaderboardCubit>().restartGame(),
              text: context.localizations.restart_game,
            ),
            if (isAdminNotAuthenticated)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: InkWell(
                  onTap: () =>
                      context.read<LeaderboardCubit>().goToRegistration(),
                  child: Text(
                    context.localizations.leaderboard_back_home_button,
                    style: context.theme.textStyles.bodyLarge!.bold().copyWith(
                          color: context.theme.customColors.textColor
                              .getShade(500),
                        ),
                  ),
                ),
              ),
          ],
        ),
      );
}

class _BigAndPortraitDeviceContent extends StatelessWidget {
  const _BigAndPortraitDeviceContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => AppConstrainedWidget(
        child: Column(
          children: [
            const _CurrentPlayerCard(),
            const SizedBox(
              height: 45,
            ),
            SizedBox(height: 0.4.sh, child: const _LeaderboardList()),
            const SizedBox(height: 30),
            const _ResetGameButtonsSection(),
          ],
        ),
      );
}

class _LeaderboardHeader extends StatelessWidget {
  const _LeaderboardHeader({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        child: Text(
          context.localizations.ranking,
          style: context.theme.textStyles.headlineLarge!.copyWith(
            color: context.theme.customColors.textColor.getShade(500),
            fontSize: 40,
          ),
        ),
      );
}

class _CurrentPlayerCard extends StatelessWidget {
  const _CurrentPlayerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                context.localizations.ranking_title,
                style: context.theme.textStyles.headlineMedium!.copyWith(
                  color: context.theme.customColors.textColor.getShade(500),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const _CurrentUserScoreCard(),
        ],
      );
}

class _CurrentUserScoreCard extends StatelessWidget {
  const _CurrentUserScoreCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) => Container(
          decoration: BoxDecoration(
            color: context.theme.customColors.lightSurfaceColor.getShade(300),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: context.theme.colorScheme.surface.getShade(500),
              width: 2,
            ),
          ),
          padding:
              const EdgeInsets.only(left: 28, top: 16, bottom: 16, right: 20),
          child: _LeaderboardUserCard(
            name: state.currentUser?.name ?? '',
            points: state.currentUser?.points ?? 0,
            position: state.currentUserPosition ?? 0,
          ),
        ),
      );
}

class _LeaderboardUserCard extends StatelessWidget {
  const _LeaderboardUserCard({
    required this.name,
    required this.points,
    required this.position,
    super.key,
  });

  final String name;
  final int points;
  final int position;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '$position.',
                style: context.theme.textStyles.headlineMedium?.copyWith(
                  color: context.theme.colorScheme.surface.getShade(500),
                  fontSize: 24,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: context.theme.textStyles.headlineMedium?.copyWith(
                  color: context.theme.colorScheme.surface.getShade(500),
                  fontSize: 24,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Assets.images.estrella.image(
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
                width: 24,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 50,
                child: Row(
                  children: [
                    Text(
                      points.toString(),
                      style: context.theme.textStyles.headlineMedium?.copyWith(
                        color: context.theme.colorScheme.surface.getShade(500),
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
}

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) => state.users != null
            ? Container(
                decoration: BoxDecoration(
                  color: context.theme.customColors.lightSurfaceColor
                      .getShade(300),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ListView.builder(
                  itemCount: state.users!.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        _LeaderboardUserCard(
                          name: state.users![index].name ?? '',
                          points: state.users![index].points,
                          position: index + 1,
                        ),
                        const SizedBox(height: 16),
                        if (index < state.users!.length - 1)
                          Divider(
                            color: context.theme.customColors.lightSurfaceColor
                                .getShade(500),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
      );
}
