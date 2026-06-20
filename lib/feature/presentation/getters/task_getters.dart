import 'package:offline_engine/feature/domain/usecases/task_usecases.dart';
import 'package:offline_engine/locator/locator.dart';

// LOCAL

GetTasksLocalUsecase get getTasksLocalUsecase =>
    locator<GetTasksLocalUsecase>();

CreateTasksLocalUsecase get createTasksLocalUsecase =>
    locator<CreateTasksLocalUsecase>();

UpdateTasksLocalUsecase get updateTasksLocalUsecase =>
    locator<UpdateTasksLocalUsecase>();

DeleteTasksLocalUsecase get deleteTasksLocalUsecase =>
    locator<DeleteTasksLocalUsecase>();

// REMOTE

GetTasksRemoteUsecase get getTasksRemoteUsecase =>
    locator<GetTasksRemoteUsecase>();

CreateTasksRemoteUsecase get createTasksRemoteUsecase =>
    locator<CreateTasksRemoteUsecase>();

UpdateTasksRemoteUsecase get updateTasksRemoteUsecase =>
    locator<UpdateTasksRemoteUsecase>();

DeleteTasksRemoteUsecase get deleteTasksRemoteUsecase =>
    locator<DeleteTasksRemoteUsecase>();
