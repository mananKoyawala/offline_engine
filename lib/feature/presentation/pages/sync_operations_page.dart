import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/feature/presentation/provider/sync_operation_provider.dart';
import 'package:offline_engine/feature/presentation/provider/task_provider.dart';

class SyncOperationsPage extends ConsumerWidget {
  SyncOperationsPage({super.key});

  bool initialized = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!initialized) {
      ref.read(taskProvider.notifier).initScheduler();
      initialized = true;
    }

    final syncOperations = ref.watch(syncOperationsProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Sync Operations"), centerTitle: true),
      body: syncOperations.when(
        data: (streamData) {
          return streamData.fold(
            (failure) {
              return Center(child: Text(failure.message));
            },
            (data) {
              if (data.isEmpty) {
                return Center(child: Text('No sync operations are there'));
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  separatorBuilder: (_, _) => Divider(color: Colors.black),
                  itemBuilder: (context, index) {
                    final operation = data[index];
                    return ListTile(
                      title: Text('${operation.id} | ${operation.taskId}'),
                      subtitle: Text(operation.payload.toString()),
                      leading: Text(operation.status.status),
                      trailing: Text(operation.type.type),
                    );
                  },
                  itemCount: data.length,
                ),
              );
            },
          );
        },
        error: (e, st) {
          return Center(child: Text('Error occured'));
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
