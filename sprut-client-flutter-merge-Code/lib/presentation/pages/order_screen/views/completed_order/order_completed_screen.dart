import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sprut/presentation/pages/order_screen/views/completed_order/order_completed_detail_view.dart';

import '../../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../widgets/custom_dialog/custom_dialog.dart';
import '../../../no_internet/no_internet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/order_controller.dart';

class OrderCompletedScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OrderCompletedScreenState();
}

class OrderCompletedScreenState extends State<OrderCompletedScreen> {

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    print("OrderCompletedScreen::");
    Helpers.systemStatusBar1();
    var colorScheme = Theme.of(context).colorScheme;
    dynamic object = ModalRoute.of(context)!.settings.arguments;
    Map<String, dynamic> mapData = jsonDecode(object.toString());

    return BlocConsumer<ConnectedBloc, ConnectedState>(
      listener: (context, state) {
        if (state is ConnectedInitialState) {}
        if (state is ConnectedSucessState) {}

      },
      builder: (context, connectionState) {
        return connectionState is ConnectedFailureState
            ? NoInternetScreen(onPressed: () async {})
            : Scaffold(
                extendBodyBehindAppBar: true,
                body: SafeArea(
                  top: false,
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        top: MediaQuery.of(context).viewInsets.top),
                    child: Column(
                      children: [
                        Expanded(
                            child: OrderCompletedDetailView(mapData['order_id'], mapData['from']))
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.black,
              );
      },
    );
  }
}
