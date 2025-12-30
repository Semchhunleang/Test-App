import 'package:flutter/material.dart';

class ListCondition extends StatelessWidget {
  final dynamic viewModel; // Can accept any type of ViewModel
  final Widget child;
  final List<dynamic> showedData;
  final Future<void> Function() onRefresh;

  const ListCondition({
    super.key,
    required this.viewModel,
    required this.showedData,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: Builder(
          builder: (context) {
            // Assuming each viewModel has `isLoading` and `apiResponse` properties
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (viewModel.apiResponse.statusCode != 200) {
              return Center(
                child: Text(
                  viewModel.apiResponse.error ?? 'Unknown error',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (showedData.isEmpty) {
              return const Center(
                child: Text('No data available'),
              );
            } else {
              return child;
            }
          },
        ),
      ),
    );
  }
}
