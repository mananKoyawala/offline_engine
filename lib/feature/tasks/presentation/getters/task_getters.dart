import 'package:todus/feature/tasks/domain/usecases/task_usecases.dart';
import 'package:todus/locator/locator.dart';

GetTasksLocalUsecase get getTasksLocalUsecase =>
    locator<GetTasksLocalUsecase>();

CreateTasksLocalUsecase get createTasksLocalUsecase =>
    locator<CreateTasksLocalUsecase>();

UpdateTasksLocalUsecase get updateTasksLocalUsecase =>
    locator<UpdateTasksLocalUsecase>();

DeleteTasksLocalUsecase get deleteTasksLocalUsecase =>
    locator<DeleteTasksLocalUsecase>();

FetchAndUpsertTasksUsecase get fetchAndUpsertTasksUsecase =>
    locator<FetchAndUpsertTasksUsecase>();
