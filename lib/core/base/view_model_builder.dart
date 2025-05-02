import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fenix_mobile_example/core/base/base_viewmodel.dart';

class ViewModelBuilder<T extends BaseViewModel> extends StatelessWidget {
  final T Function() initViewModel;
  final Widget Function(BuildContext context, T viewModel) builder;

  const ViewModelBuilder({
    super.key,
    required this.initViewModel,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) {
        final viewModel = initViewModel();
        if (viewModel is BaseViewModel) {
          (viewModel as BaseViewModel).onBindingCreated();
        }
        return viewModel;
      },
      child: Consumer<T>(
        builder: (context, viewModel, child) => builder(context, viewModel),
      ),
    );
  }
} 