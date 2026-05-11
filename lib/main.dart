import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sankar/core/navigation/app_router.dart';
import 'package:sankar/core/theme/app_theme.dart';
import 'package:sankar/core/network/dio_client.dart';
import 'package:sankar/firebase_options.dart';

// Repositories
import 'package:sankar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sankar/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:sankar/features/quotes/data/repositories/quote_repository_impl.dart';

// Cubits
import 'package:sankar/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sankar/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:sankar/features/quotes/presentation/cubit/quote_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dioClient = DioClient();
  
  final authRepository = AuthRepositoryImpl();
  final taskRepository = TaskRepositoryImpl();
  final quoteRepository = QuoteRepositoryImpl(dioClient);

  runApp(MyApp(
    authRepository: authRepository,
    taskRepository: taskRepository,
    quoteRepository: quoteRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final TaskRepositoryImpl taskRepository;
  final QuoteRepositoryImpl quoteRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.taskRepository,
    required this.quoteRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: taskRepository),
        RepositoryProvider.value(value: quoteRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(authRepository)),
          BlocProvider(create: (context) => TaskCubit(taskRepository)),
          BlocProvider(create: (context) => QuoteCubit(quoteRepository)..getRandomQuote()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812), // iPhone X design size
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              title: 'Taskly',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}
