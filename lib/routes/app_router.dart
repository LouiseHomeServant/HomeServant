import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/onboarding_step1_screen.dart';
import '../features/auth/onboarding_step2_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/auth/verify_otp_screen.dart';
import '../features/dashboard/landlord_dashboard_screen.dart';
import '../features/dashboard/tenant_dashboard_screen.dart';
import '../features/onboarding/get_started_screen.dart';
import '../features/splash/splash_screen.dart';
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
          onRoleSelected: (role) {
            context.read<AppState>().selectRole(role);
            context.push('/login');
          },
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final role = context.watch<AppState>().role;
          return LoginScreen(
            role: role,
            onLogin: () => context.go('/dashboard'),
            onSignUp: () => context.push('/signup'),
          );
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          final role = context.watch<AppState>().role;
          return SignupScreen(
            role: role,
            onContinue: (email) {
              context.read<AppState>().setEmail(email);
              context.push('/verify-otp');
            },
          );
        },
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final appState = context.watch<AppState>();
          return VerifyOtpScreen(
            role: appState.role,
            email: appState.email,
            onVerified: () => context.push('/onboarding-1'),
          );
        },
      ),
      GoRoute(
        path: '/onboarding-1',
        builder: (context, state) {
          final role = context.watch<AppState>().role;
          return OnboardingStep1Screen(
            role: role,
            onContinue: (fields) {
              context.read<AppState>().setProfileBasics(
                    name: fields['name'] ?? '',
                    phone: fields['phone'] ?? '',
                  );
              context.push('/onboarding-2');
            },
          );
        },
      ),
      GoRoute(
        path: '/onboarding-2',
        builder: (context, state) {
          final role = context.watch<AppState>().role;
          return OnboardingStep2Screen(
            role: role,
            onFinish: () => context.go('/dashboard'),
          );
        },
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
