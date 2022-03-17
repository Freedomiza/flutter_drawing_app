import 'package:hooks_riverpod/hooks_riverpod.dart';

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier(0);
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier(int value) : super(value);

  increment() {
    state++;
  }

  decrement() {
    state--;
  }
}
