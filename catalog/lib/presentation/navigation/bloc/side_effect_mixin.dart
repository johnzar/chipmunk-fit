import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc에 SideEffect를 추가하는 Mixin
mixin SideEffectMixin<Event, State, SideEffect> on Bloc<Event, State> {
  final _sideEffectController = StreamController<SideEffect>.broadcast();

  void emitSideEffect(SideEffect sideEffect) {
    _sideEffectController.add(sideEffect);
  }

  @override
  Future<void> close() {
    _sideEffectController.close();
    return super.close();
  }
}

/// SideEffect를 리스닝하는 위젯
class BlocSideEffectListener<B extends Bloc<dynamic, dynamic>, SE>
    extends StatefulWidget {
  final void Function(BuildContext context, SE sideEffect) listener;
  final Widget child;

  const BlocSideEffectListener({
    super.key,
    required this.listener,
    required this.child,
  });

  @override
  State<BlocSideEffectListener<B, SE>> createState() =>
      _BlocSideEffectListenerState<B, SE>();
}

class _BlocSideEffectListenerState<B extends Bloc<dynamic, dynamic>, SE>
    extends State<BlocSideEffectListener<B, SE>> {
  StreamSubscription<SE>? _subscription;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<B>() as SideEffectMixin<dynamic, dynamic, SE>;
    _subscription = bloc._sideEffectController.stream.listen((sideEffect) {
      if (mounted) {
        widget.listener(context, sideEffect);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
