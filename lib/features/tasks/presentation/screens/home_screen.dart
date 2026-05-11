import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sankar/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sankar/features/auth/presentation/cubit/auth_state.dart';
import 'package:sankar/features/tasks/data/models/task_model.dart';
import 'package:sankar/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:sankar/features/tasks/presentation/cubit/task_state.dart';
import 'package:sankar/features/tasks/presentation/widgets/task_card.dart';
import 'package:sankar/features/tasks/presentation/widgets/add_edit_task_sheet.dart';
import 'package:sankar/shared/widgets/confirmation_dialog.dart';
import 'package:sankar/shared/widgets/loading_widget.dart';
import 'package:sankar/features/quotes/presentation/widgets/quote_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<TaskCubit>().getTasks(authState.user.id);
    }
  }

  void _showAddEditSheet({TaskModel? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => AddEditTaskSheet(
        task: task,
        onSave: (title, description, date, status) {
          final authState = context.read<AuthCubit>().state as AuthAuthenticated;
          if (task == null) {
            context.read<TaskCubit>().addTask(TaskModel(
                  id: '',
                  uid: authState.user.id,
                  title: title,
                  description: description,
                  date: date,
                  status: status,
                  createdAt: DateTime.now(),
                ));
          } else {
            context.read<TaskCubit>().updateTask(task.copyWith(
                  title: title,
                  description: description,
                  date: date,
                  status: status,
                ));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          print('DEBUG: HomeScreen AuthListener: Authenticated. Fetching tasks...');
          context.read<TaskCubit>().getTasks(state.user.id);
        } else if (state is AuthUnauthenticated) {
          print('DEBUG: HomeScreen AuthListener: Unauthenticated. Clearing tasks...');
          context.read<TaskCubit>().clearTasks();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tasks'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<AuthCubit>().logout(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddEditSheet(),
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return Text(
                        'Hello, ${state.user.displayName ?? 'User'}!',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24.sp),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 8.h),
                const QuoteCard(),
                SizedBox(height: 24.h),
                Text(
                  'Current Tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: BlocBuilder<TaskCubit, TaskState>(
                    builder: (context, state) {
                      print('DEBUG: HomeScreen Task BlocBuilder state: $state');
                      if (state is TaskLoading || state is TaskInitial) {
                        return const LoadingWidget();
                      } else if (state is TaskLoaded) {
                        if (state.tasks.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.task_alt, size: 64.sp, color: Colors.grey[300]),
                                SizedBox(height: 16.h),
                                Text(
                                  'No tasks yet. Add one!',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: state.tasks.length,
                          itemBuilder: (context, index) {
                            final task = state.tasks[index];
                            return TaskCard(
                              task: task,
                              onToggle: (val) {
                                final newStatus = (val ?? false) ? TaskStatus.completed : TaskStatus.todo;
                                context.read<TaskCubit>().updateTaskStatus(task.id, newStatus);
                              },
                              onStatusChanged: (status) {
                                context.read<TaskCubit>().updateTaskStatus(task.id, status);
                              },
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ConfirmationDialog(
                                    title: 'Delete Task',
                                    message: 'Are you sure you want to delete this task?',
                                    confirmText: 'Delete',
                                    onConfirm: () => context.read<TaskCubit>().deleteTask(task.id),
                                  ),
                                );
                              },
                              onEdit: () => _showAddEditSheet(task: task),
                            );
                          },
                        );
                      } else if (state is TaskError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 48),
                              SizedBox(height: 16.h),
                              Text('Error: ${state.message}', textAlign: TextAlign.center),
                              TextButton(
                                onPressed: () {
                                  final authState = context.read<AuthCubit>().state;
                                  if (authState is AuthAuthenticated) {
                                    context.read<TaskCubit>().getTasks(authState.user.id);
                                  }
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
