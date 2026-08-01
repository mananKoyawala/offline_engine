import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/feature/tasks/presentation/provider/sync_operation_provider.dart';
import 'package:offline_engine/feature/tasks/presentation/provider/task_provider.dart';

class SyncOperationsPage extends ConsumerWidget {
  const SyncOperationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncOperations = ref.watch(syncOperationsProvider);
    final pendingcount = ref.watch(pendingCountProvider);
    final failedCount = ref.watch(failedCountProvider);
    final processingCount = ref.watch(processingCountProvider);
    final successCount = ref.watch(successCountProvider);
    final createCount = ref.watch(createCountProvider);
    final deleteCount = ref.watch(deleteCountProvider);
    final updateCount = ref.watch(updateCountProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sync Operations"),
        centerTitle: true,
        actions: [
          Tooltip(
            message: "Schedule Tasks",
            child: IconButton(
              onPressed: () {
                ref.read(taskProvider.notifier).initScheduler();
              },
              icon: Icon(Icons.schedule),
            ),
          ),
        ],
      ),
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
                child: Column(
                  children: [
                    Text('Operation status'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Pending count : ${pendingcount.value ?? 0}'),
                            Text('Failed count : ${failedCount.value ?? 0}'),
                          ],
                        ),

                        Column(
                          children: [
                            Text(
                              'Processing count : ${processingCount.value ?? 0}',
                            ),
                            Text('Success count : ${successCount.value ?? 0}'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey.shade400),
                    SizedBox(height: 10),
                    Text('Operation type'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Create count : ${createCount.value ?? 0}'),
                            Text('Update count : ${updateCount.value ?? 0}'),
                          ],
                        ),

                        Column(
                          children: [
                            Text('Delete count : ${deleteCount.value ?? 0}'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey.shade400),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (_, _) =>
                            Divider(color: Colors.black),
                        itemBuilder: (context, index) {
                          final operation = data[index];
                          return ListTile(
                            title: Text(
                              '${operation.id} | ${operation.taskId}',
                            ),
                            subtitle: Text(operation.payload.toString()),
                            leading: Text(operation.status.status),
                            trailing: Text(operation.type.type),
                          );
                        },
                        itemCount: data.length,
                      ),
                    ),
                  ],
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
