import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hello_world/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:hello_world/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:hello_world/features/todos/domain/usecases/add_todo_usecase.dart';
import 'package:hello_world/features/todos/domain/usecases/delete_todo_usecase.dart';
import 'package:hello_world/features/todos/domain/usecases/get_todos_usecase.dart';
import 'package:hello_world/features/todos/domain/usecases/update_todo_usecase.dart';
import 'package:hello_world/features/todos/presentation/provider/todo_provider.dart';
import 'package:hello_world/features/todos/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';


void main() async {

  final localDataSource = InMemoryTodoLoalDataSource();


  final repository = TodoRepositoryImpl(localDataSource: localDataSource);

 
  final getTodosUseCase = GetTodosUsecase(repository);
  final addTodoUseCase = AddTodoUsecase(repository);
  final deleteTodoUsecase = DeleteTodoUsecase( repository);
  final updateTodoUsecase = UpdateTodoUsecase(repository);

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'assets/translations', 
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => TodoProvider(
              getTodosUsecase: getTodosUseCase,
              addTodoUsecase: addTodoUseCase,
              deleteTodoUsecase: deleteTodoUsecase,
              updateTodoUsecase: updateTodoUsecase,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ('todo.title'.tr()), 
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const TodoListScreen(),
    );
  }
}

