import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lebroid_crm/feaure/auth/presentation/screens/splash_screen.dart';
import 'feaure/Admin/attendance_management/bloc/employee_attendance/employee_attendance_bloc.dart';
import 'feaure/Admin/attendance_management/data/repository/employee_attendance_repository.dart';
import 'feaure/Admin/expense_management/bloc/expense_bloc.dart';
import 'feaure/Employee/bottom_navigation_bar/logics/navigation/navigation_bloc.dart';
import 'firebase_options.dart';
import 'feaure/auth/logics/auth_bloc.dart';
import 'feaure/auth/data/repositories/auth_repository.dart';
import 'feaure/auth/data/services/auth_service.dart';
import 'notification/notication.dart';

import 'package:lebroid_crm/feaure/Admin/branch_management/bloc/branch_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/data/repository/branch_repository.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/data/repository/role_repository.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/logics/department_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/data/repositiores/department_repository.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/bloc/employee_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/data/repository/employee_repository.dart';
import 'package:lebroid_crm/feaure/Admin/tasks_productivity/bloc/task_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/tasks_productivity/data/repository/task_repository.dart';
import 'package:lebroid_crm/feaure/Admin/performance_management/bloc/performance_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/performance_management/data/repository/performance_repository.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/payroll_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/data/repository/payroll_repository.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/bloc/salary_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/payroll/data/repository/salary_repository.dart';
import 'package:lebroid_crm/feaure/Admin/expense_management/data/repository/expense_repository.dart';
import 'package:lebroid_crm/feaure/Admin/reports_analytics/bloc/reports_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/reports_analytics/data/repository/reports_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// ✅ REGISTER BACKGROUND HANDLER
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(create: (_) => NavigationBloc()),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(AuthRepository(AuthService()))),
        BlocProvider<BranchBloc>(create: (_) => BranchBloc(branchRepository: BranchRepository())),
        BlocProvider<RoleBloc>(create: (_) => RoleBloc(roleRepository: RoleRepository())),
        BlocProvider<DepartmentBloc>(create: (_) => DepartmentBloc(departmentRepository: DepartmentRepository())),
        BlocProvider<EmployeeBloc>(create: (_) => EmployeeBloc(employeeRepository: EmployeeRepository())),
        BlocProvider<TaskBloc>(create: (_) => TaskBloc(TaskRepository(AuthService()))),
        BlocProvider<PerformanceBloc>(create: (_) => PerformanceBloc(PerformanceRepository(AuthService()))),
        BlocProvider<PayrollBloc>(create: (_) => PayrollBloc(PayrollRepository(AuthService()))),
        BlocProvider<SalaryBloc>(create: (_) => SalaryBloc(SalaryRepository(AuthService()))),
        BlocProvider<ExpenseBloc>(create: (_) => ExpenseBloc(expenseRepository: ExpenseRepository(AuthService()))),
        BlocProvider<ReportsBloc>(create: (_) => ReportsBloc(reportsRepository: ReportsRepository(AuthService()))),
        BlocProvider<EmployeeAttendanceBloc>(create: (_) => EmployeeAttendanceBloc(repository: EmployeeAttendanceRepository())),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lebroid CRM',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: false,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
