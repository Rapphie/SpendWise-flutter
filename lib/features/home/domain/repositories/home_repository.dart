import 'package:spend_wise/features/auth/domain/entities/app_user.dart';

abstract class HomeRepository {
  Future<List> getRecentTransactions(String userid);
}