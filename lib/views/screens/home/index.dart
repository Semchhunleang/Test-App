import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/home_view_model.dart';
import 'package:umgkh_mobile/view_models/nenam_version_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/screens/home/widgets/grid_menu_widget.dart';
import 'package:umgkh_mobile/views/screens/home/widgets/list_menu_widget.dart';
import 'package:umgkh_mobile/views/screens/home/widgets/caoursel_custom.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  static const screenName = 'Home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).getCarousel();
      Provider.of<HomeViewModel>(context, listen: false).loadMenuItems();
      Provider.of<HomeViewModel>(context, listen: false).getLocalMenuType();
      Provider.of<AccessLevelViewModel>(context, listen: false)
          .fetchAccessLevel();
      Provider.of<SelectionsViewModel>(context, listen: false)
          .fetchUMGSocialMedia();
      Provider.of<NenamVersionViewModel>(context, listen: false)
          .fetchNenamVersion(context);
    });
  }

  @override
  Widget build(BuildContext context) => Consumer<HomeViewModel>(
        builder: (context, viewModel, _) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (viewModel.isLoading) ...[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.23,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ] else ...[
                carouselCustom(context, viewModel.strImages!)
              ],
              Padding(
                padding: EdgeInsets.only(
                    top: mainPadding / 2,
                    left: mainPadding,
                    bottom: mainPadding / 2),
                child: Row(
                  children: [
                    SearchMenuTextField(
                        ctrl: viewModel.searchCtrl,
                        onChanged: viewModel.onSearchChanged,
                        onRemoveText: viewModel.onRemoveSearch),
                    Padding(
                      padding: EdgeInsets.fromLTRB(mainPadding / 6, 0, 0, 0),
                      child: IconButton(
                        onPressed: viewModel.onChangedMenuTypeGrid,
                        icon: const Icon(Icons.grid_view_rounded),
                        color: viewModel.menuUiType == grid
                            ? primaryColor
                            : Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, mainPadding / 6, 0),
                      child: IconButton(
                        onPressed: viewModel.onChangedMenuTypeList,
                        icon: const Icon(Icons.view_list_rounded),
                        color: viewModel.menuUiType == list
                            ? primaryColor
                            : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              
              Expanded(
                  child: viewModel.isLoadMenu
                      ? viewModel.menuUiType == list
                          ? const ListMenuWidget()
                          : const GridMenuWidget()
                      : sizedBoxShrink)
            ],
          ),
        ),
      );
}
