import 'package:autospectechnics/ui/screens/adding_object/adding_object_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_object/widgets/necessary_resource_widget.dart';
import 'package:autospectechnics/ui/screens/adding_object/widgets/necessary_vehicles_widget.dart';
import 'package:autospectechnics/ui/screens/adding_object/widgets/object_form_main_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddingObjectScreen extends StatelessWidget {
  const AddingObjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select(
      (AddingObjectViewModel vm) => vm.currentTabIndex,
    );
    return IndexedStack(
      index: currentIndex,
      children: const [
        //TODO Запретить переход на следующую страницу, если не заполнена текущая, аналогично в добавлении ТС
        ObjectFormMainInfoWidget(),
        NecessaryVehiclesWidget(),
        NecessaryResource(),
      ],
    );
  }
}