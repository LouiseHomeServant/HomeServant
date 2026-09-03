import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/auth/login_landlord_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/login_tenant_screen.dart';
import '../features/auth/signup_landlord1_screen.dart';
import '../features/auth/signup_landlord2_screen.dart';
import '../features/auth/signup_landlord_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/auth/signup_tenant1_screen.dart';
import '../features/auth/signup_tenant2_screen.dart';
import '../features/auth/signup_tenant_screen.dart';
import '../features/auth/verify_otp_screen.dart';
import '../features/dashboard/landlord_dashboard_screen.dart';
import '../features/dashboard/tenant_dashboard_screen.dart';
import '../features/onboarding/get_started_screen.dart';
import '../features/splash/splash_screen.dart';
import '../models/user_role.dart';
import '../state/app_state.dart';

GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(
          onExplore: () => context.push('/get-started'),
        ),
      ),
      GoRoute(
        path: '/get-started',
        builder: (context, state) => GetStartedScreen(
          onLogin: () => context.push('/login'),
          onSignUp: () => context.push('/signup'),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(
          onRoleSelected: (role) {
            context.read<AppState>().selectRole(role);
            if (role == UserRole.landlord) {
              context.push('/login-landlord');
            } else {
              context.push('/login-tenant');
            }
          },
        ),
      ),
      GoRoute(
        path: '/login-landlord',
        builder: (context, state) => LoginLandlordScreen(
          onLogin: () => context.go('/dashboard'),
          onSignUp: () => context.push('/signup-landlord'),
        ),
      ),
      GoRoute(
        path: '/login-tenant',
        builder: (context, state) => LoginTenantScreen(
          onLogin: () => context.go('/dashboard'),
          onSignUp: () => context.push('/signup'),
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignupScreen(
          onRoleSelected: (role) {
            context.read<AppState>().selectRole(role);
            if (role == UserRole.landlord) {
              context.push('/signup-landlord');
            } else {
              context.push('/signup-tenant');
            }
          },
        ),
      ),
      GoRoute(
        path: '/signup-tenant',
        builder: (context, state) => SignupTenantScreen(
          onContinue: (email) {
            context.read<AppState>().setEmail(email);
            context.push('/verify-otp');
          },
        ),
      ),
      GoRoute(
        path: '/signup-landlord',
        builder: (context, state) => SignupLandlordScreen(
          onContinue: (email) {
            context.read<AppState>().setEmail(email);
            context.push('/verify-otp');
          },
        ),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final appState = context.watch<AppState>();
          return VerifyOtpScreen(
            role: appState.role,
            email: appState.email,
            onVerified: () {
              if (appState.role == UserRole.landlord) {
                context.push('/signup-landlord-1');
              } else {
                context.push('/signup-tenant-1');
              }
            },
          );
        },
      ),
      GoRoute(
        path: '/signup-landlord-1',
        builder: (context, state) => SignupLandlord1Screen(
          onContinue: (fields) {
            context.read<AppState>().setProfileBasics(
                  name: fields['name'] ?? '',
                  phone: fields['phone'] ?? '',
                  houseAddress: fields['houseAddress'],
                );
            context.push('/signup-landlord-2');
          },
        ),
      ),
      GoRoute(
        path: '/signup-landlord-2',
        builder: (context, state) => SignupLandlord2Screen(
          onFinish: () => context.go('/dashboard'),
        ),
      ),
      GoRoute(
        path: '/signup-tenant-1',
        builder: (context, state) => SignupTenant1Screen(
          onContinue: (fields) {
            context.read<AppState>().setProfileBasics(
                  name: fields['name'] ?? '',
                  phone: fields['phone'] ?? '',
                  referralCode: fields['referral'],
                );
            context.push('/signup-tenant-2');
          },
        ),
      ),
      GoRoute(
        path: '/signup-tenant-2',
        builder: (context, state) => SignupTenant2Screen(
          onFinish: () => context.go('/dashboard'),
        ),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) {
          final role = context.watch<AppState>().role;
          return role.isLandlord ? const LandlordDashboardScreen() : const TenantDashboardScreen();
        },
      ),
    ],
  );
}
