import 'package:flutter/material.dart';
import 'package:fenix_mobile_example/core/base/view_model_builder.dart';
import 'package:fenix_mobile_example/presentation/features/main/viewmodel/main_viewmodel.dart';
import 'package:fenix_mobile_example/core/extensions/context_localization_extension.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>(
      initViewModel: () => MainViewModel(),
      builder: (context, viewModel) => Scaffold(
        body: viewModel.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: viewModel.currentIndex,
          onTap: viewModel.onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: context.str.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: context.str.favorites,
            ),
          ],
        ),
      ),
    );
  }
} 