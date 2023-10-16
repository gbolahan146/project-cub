import 'package:cubex/src/presentation/providers/auth_state.dart';
import 'package:cubex/src/presentation/providers/forgotpassword/forgot_password_state.dart';
import 'package:cubex/src/presentation/providers/bank/bank_state.dart';
import 'package:cubex/src/presentation/providers/trade/trade_state.dart';
import 'package:cubex/src/presentation/providers/transfer/transfer_state.dart';
import 'package:cubex/src/presentation/providers/upload/upload_state.dart';
import 'package:cubex/src/presentation/providers/user-account/accounts_state.dart';
import 'package:cubex/src/presentation/providers/wallet/wallet_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider((ref) => AuthState());
final accountsProvider = ChangeNotifierProvider((ref) => AccountState());
final transferProvider = ChangeNotifierProvider((ref) => TransferState());
final walletProvider = ChangeNotifierProvider((ref) => WalletState());
final userAccountsProvider =
    ChangeNotifierProvider((ref) => UserAccountState());
final forgotPassProvider =
    ChangeNotifierProvider((ref) => ForgotPasswordState());
final uploadProvider = ChangeNotifierProvider((ref) => UploadState());
final tradeProvider = ChangeNotifierProvider((ref) => TradeState());
// final mgtProvider = ChangeNotifierProvider((ref) => ManagementState());
// final assetProvider = ChangeNotifierProvider((ref) => AssetState());
// final customProvider = ChangeNotifierProvider((ref) => CustomState());
// final researchProvider = ChangeNotifierProvider((ref) => ResearchState());
// final scholarProvider = ChangeNotifierProvider((ref) => ScholarState());
// final assignmentProvider = ChangeNotifierProvider((ref) => AssignmentState());
// final walletProvider = ChangeNotifierProvider((ref) => WalletState());
// final mgtProvider = ChangeNotifierProvider((ref) => AssignmentState());
