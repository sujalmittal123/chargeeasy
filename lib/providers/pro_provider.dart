import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pro_provider.g.dart';

@riverpod
class ProStatus extends _$ProStatus {
  @override
  bool build() {
    return false; // Free version by default
  }

  void upgrade() {
    state = true;
  }
}
