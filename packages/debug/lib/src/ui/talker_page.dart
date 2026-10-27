import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'talker_page.g.dart';

@riverpod
Talker talker(Ref ref) => throw UnimplementedError();

class TalkerPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = ref.watch(talkerProvider);

    return Scaffold(
      body: TalkerScreen(talker: talker),
    );
  }
}
