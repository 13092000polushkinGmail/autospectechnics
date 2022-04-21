import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/adding_vehicle_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/widgets/vehicle_stepper_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegulationsWidget extends StatefulWidget {
  const RegulationsWidget({Key? key}) : super(key: key);

  @override
  State<RegulationsWidget> createState() => _RegulationsWidgetState();
}

class _RegulationsWidgetState extends State<RegulationsWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  bool _isActive = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleContainer() {
    // print(_animation.status);
    if (_animation.status != AnimationStatus.completed) {
      _controller.forward();
      setState(() {
        _isActive = true;
      });
    } else {
      _controller.animateBack(0, duration: const Duration(milliseconds: 500));
      setState(() {
        _isActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingVehicleViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регламенты'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () => model.decrementCurrentTabIndex(),
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
        children: [
          const VehicleStepperWidget(),
          const SizedBox(height: 32),
          InkWell(
            onTap: () => _toggleContainer(),
            child: _HeaderWidget(isActive: _isActive),
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, __) => Text(
                      'Замена масляного фильтра и масла ДВС',
                      style: AppTextStyles.hint
                          .copyWith(color: AppColors.greyText),
                    ),
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemCount: 4),
          ),
        ],
      ),
      floatingActionButton: FloatingButtonWidget(
        text: 'Далее',
        onPressed: () => model.incrementCurrentTabIndex(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  final bool isActive;

  const _HeaderWidget({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.greyText : AppColors.black;
    final arrowIcon = isActive
        ? Icons.keyboard_arrow_up_rounded
        : Icons.keyboard_arrow_down_rounded;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Использовать стандартные для данного типа техники регламенты?',
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Switch(value: true, onChanged: (onwvwv) {}),
          ],
        ),
        Icon(
          arrowIcon,
          color: color,
        ),
      ],
    );
  }
}