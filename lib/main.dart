import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:OutsourcedX/auth/bloc/auth_bloc.dart';
import 'package:OutsourcedX/auth/cubit/signup/signup_cubit.dart';
import 'package:OutsourcedX/auth/repository/auth_repository.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/core/router/app_router.dart';
import 'package:OutsourcedX/firebase_options.dart';
import 'package:OutsourcedX/message/bloc/messages_bloc.dart';
import 'package:OutsourcedX/message/repository/message_repository.dart';
import 'package:OutsourcedX/onboarding/bloc/onboarding_bloc.dart';
import 'package:OutsourcedX/onboarding/view/pages/profile_setup/bloc/bloc/category_search_bloc.dart';
import 'package:OutsourcedX/onboarding/view/pages/profile_setup/bloc/skills/bloc/skill_search_bloc.dart';
import 'package:OutsourcedX/payments/bloc/history/payment_history_bloc.dart';
import 'package:OutsourcedX/payments/bloc/payments_bloc.dart';
import 'package:OutsourcedX/payments/repository/payments_repository.dart';
import 'package:OutsourcedX/payouts/bloc/payout_bloc.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:OutsourcedX/profile/portfolio/bloc/portfolio_bloc.dart';
import 'package:OutsourcedX/profile/portfolio/repository/category_repository.dart';
import 'package:OutsourcedX/profile/portfolio/repository/portfiolio_repository.dart';
import 'package:OutsourcedX/profile/portfolio/repository/skills_repository.dart';
import 'package:OutsourcedX/profile/repository/user_respository.dart';
import 'package:OutsourcedX/projects/bloc/projects_bloc.dart';
import 'package:OutsourcedX/projects/repository/projects_repository.dart';
import 'package:OutsourcedX/proposals/bloc/proposal_bloc.dart';
import 'package:OutsourcedX/proposals/repo/proposal_repository.dart';
import 'package:OutsourcedX/search/bloc/search_bloc.dart';
import 'package:OutsourcedX/search/repository/search_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb == false) {
    await dotenv.load(fileName: ".env");
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// Clear firebase cache
  await FirebaseFirestore.instance.clearPersistence();
  //await FirebaseAuth.instance.signOut();

// Clear  Shared Preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setBool('onboarded', true);
  // await prefs.clear();

  runApp(const MyApp());
}

StreamSubscription? _sub;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    kIsWeb == false ? initPlatformState() : null;
  }

  initPlatformState() async {
    // Get the initial link (if the app was launched by a link)
    getInitialLink().then((link) {
      if (link != null) {
        handleLink(link);
      }
    });

    // Handle links that come in while the app is open
    _sub = linkStream.listen((link) {
      if (link != null) {
        handleLink(link);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

// Your handler function
  void handleLink(String link) async {
    // Parse the link
    var uri = Uri.parse(link);
    print('Link: $link');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool paymentSetupComplete = prefs.getBool('paymentSetupComplete') ?? false;
    // Use GoRouter to navigate to the path in the deep link
    if (link.contains('redirect') && paymentSetupComplete == false) {
      goRouter.go('/stripe-confirmation?${uri.query}');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository()),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider<ProposalRepository>(
          create: (context) => ProposalRepository(),
        ),
        RepositoryProvider<MessageRepository>(
          create: (context) => MessageRepository(),
        ),
        RepositoryProvider<PaymentsRepository>(
          create: (context) => PaymentsRepository()..initializeStripe(),
        ),
        RepositoryProvider<ProjectsRepository>(
          create: (context) => ProjectsRepository(),
        ),
        RepositoryProvider<SearchRepository>(
          create: (context) => SearchRepository(),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository(),
        ),
        RepositoryProvider(
          create: (context) => SkillsRepository(),
        ),
        RepositoryProvider(
          create: (context) => PortfolioRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
              create: (context) =>
                  SignupCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider<OnboardingBloc>(
            create: (context) =>
                OnboardingBloc(userRepository: context.read<UserRepository>()),
          ),
          BlocProvider(
              create: (context) => ProfileBloc(
                  userRepository: context.read<UserRepository>(),
                  authBloc: context.read<AuthBloc>())
                ..add(LoadProfile())),
          BlocProvider<PaymentHistoryBloc>(
            create: (context) => PaymentHistoryBloc()
              ..add(const FetchPaymentHistory(userId: 'userId')),
          ),
          BlocProvider<MessagesBloc>(
            create: (context) => MessagesBloc(
              messageRepository: context.read<MessageRepository>(),
            ),
          ),
          BlocProvider<ProposalBloc>(
            create: (context) => ProposalBloc(
              profileBloc: context.read<ProfileBloc>(),
              messagesBloc: context.read<MessagesBloc>(),
              proposalRepository: context.read<ProposalRepository>(),
              projectsRepository: context.read<ProjectsRepository>(),
            ),
          ),
          BlocProvider(
              lazy: false,
              create: (context) => PaymentsBloc(
                  profileBloc: context.read<ProfileBloc>(),
                  paymentsRepository: context.read<PaymentsRepository>())),
          BlocProvider(
            create: (context) => ProjectsBloc(
              projectsRepository: context.read<ProjectsRepository>(),
              profileBloc: context.read<ProfileBloc>(),
            ),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => SearchBloc(
              projectsRepository: context.read<ProjectsRepository>(),
              searchRepository: context.read<SearchRepository>(),
              profileBloc: context.read<ProfileBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => CategorySearchBloc(
              searchRepository: context.read<SearchRepository>(),
              categoryRepository: context.read<CategoryRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SkillSearchBloc(
              searchRepository: context.read<SearchRepository>(),
              skillsRepository: context.read<SkillsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PortfolioBloc(
              portfolioRepository: context.read<PortfolioRepository>(),
            )..add(LoadPortfolio(
                userId: context.read<AuthBloc>().state.user!.uid)),
          ),
          BlocProvider(
            create: (context) => PayoutBloc(
              paymentsRepository: context.read<PaymentsRepository>(),
            ),
          )
        ],
        child: Listener(
          onPointerDown: (event) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              //currentFocus.focusedChild!.unfocus();
            }
          },
          child: MaterialApp.router(
            scaffoldMessengerKey: scaffoldKey,
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
            routeInformationProvider: goRouter.routeInformationProvider,
            title: 'Honeybadger ',
            debugShowCheckedModeBanner: false,
            // Theme config for FlexColorScheme version 7.2.x. Make sure you use
            // same or higher package version, but still same major version. If you
            // use a lower package version, some properties may not be supported.
            // In that case remove them after copying this theme to your app.
            theme: FlexThemeData.light(
              colors: const FlexSchemeColor(
                primary: Color(0xFF1E2223),
                primaryContainer: Color(0xffd0e4ff),
                secondary: Color(0xffac3306),
                secondaryContainer: Color(0xff97f0ff),
                tertiary: Color(0xff006875),
                tertiaryContainer: Color(0xff95f0ff),
                appBarColor: Color(0xff97f0ff),
                error: Color(0xffb00020),
              ),
              surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
              blendLevel: 22,
              appBarStyle: FlexAppBarStyle.background,
              bottomAppBarElevation: 1.0,
              lightIsWhite: true,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 10,
                blendOnColors: false,
                useTextTheme: true,
                useM2StyleDividerInM3: true,
                splashType: FlexSplashType.inkRipple,
                defaultRadius: 16.0,
                elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
                elevatedButtonSecondarySchemeColor:
                    SchemeColor.primaryContainer,
                segmentedButtonSchemeColor: SchemeColor.primary,
                inputDecoratorUnfocusedHasBorder: false,
                fabSchemeColor: SchemeColor.tertiary,
                popupMenuRadius: 6.0,
                popupMenuElevation: 4.0,
                dialogElevation: 3.0,
                dialogRadius: 20.0,
                snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
                drawerIndicatorSchemeColor: SchemeColor.primary,
                bottomSheetRadius: 20.0,
                bottomSheetElevation: 2.0,
                bottomSheetModalElevation: 3.0,
                bottomNavigationBarMutedUnselectedLabel: false,
                bottomNavigationBarMutedUnselectedIcon: false,
                bottomNavigationBarBackgroundSchemeColor:
                    SchemeColor.surfaceVariant,
                menuRadius: 6.0,
                menuElevation: 4.0,
                menuBarRadius: 0.0,
                menuBarElevation: 1.0,
                navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
                navigationBarMutedUnselectedLabel: false,
                navigationBarSelectedIconSchemeColor: SchemeColor.background,
                navigationBarMutedUnselectedIcon: false,
                navigationBarIndicatorSchemeColor: SchemeColor.primary,
                navigationBarIndicatorOpacity: 1.00,
                navigationBarBackgroundSchemeColor: SchemeColor.background,
                navigationBarElevation: 1.0,
                navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
                navigationRailMutedUnselectedLabel: false,
                navigationRailSelectedIconSchemeColor: SchemeColor.background,
                navigationRailMutedUnselectedIcon: false,
                navigationRailIndicatorSchemeColor: SchemeColor.primary,
                navigationRailIndicatorOpacity: 1.00,
              ),
              keyColors: const FlexKeyColors(
                useTertiary: true,
                keepPrimary: true,
                keepSecondary: true,
                keepTertiary: true,
              ),
              tones: FlexTones.highContrast(Brightness.light)
                  .onMainsUseBW()
                  .onSurfacesUseBW()
                  .surfacesUseBW(),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              swapLegacyOnMaterial3: true,
              // To use the Playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            darkTheme: FlexThemeData.dark(
              scaffoldBackground: const Color.fromARGB(255, 0, 0, 0),
              background: const Color.fromARGB(255, 18, 18, 18),
              colors: const FlexSchemeColor(
                primary: Colors.white,
                primaryContainer: Color(0xffffffff),
                secondary: Color(0xff00daf1),
                secondaryContainer: Color(0xffffffff),
                tertiary: Color(0xffffffff),
                tertiaryContainer: Color(0xff004e59),
                appBarColor: Color(0xffffffff),
                error: Color(0xffb00020),
              ),
              //surface: Colors.transparent,
              surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
              blendLevel: 18,
              appBarStyle: FlexAppBarStyle.background,
              bottomAppBarElevation: 2.0,
              darkIsTrueBlack: true,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                useTextTheme: true,
                useM2StyleDividerInM3: true,
                splashType: FlexSplashType.inkRipple,
                defaultRadius: 16.0,
                elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
                elevatedButtonSecondarySchemeColor:
                    SchemeColor.primaryContainer,
                segmentedButtonSchemeColor: SchemeColor.primary,
                inputDecoratorSchemeColor: SchemeColor.primary,
                inputDecoratorBackgroundAlpha: 28,
                inputDecoratorUnfocusedHasBorder: false,
                fabSchemeColor: SchemeColor.tertiary,
                popupMenuRadius: 6.0,
                popupMenuElevation: 4.0,
                dialogElevation: 3.0,
                dialogRadius: 20.0,
                snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
                drawerIndicatorSchemeColor: SchemeColor.primary,
                bottomSheetRadius: 20.0,
                bottomSheetElevation: 2.0,
                bottomSheetModalElevation: 3.0,
                bottomNavigationBarMutedUnselectedLabel: false,
                bottomNavigationBarMutedUnselectedIcon: false,
                bottomNavigationBarBackgroundSchemeColor:
                    SchemeColor.surfaceVariant,
                menuRadius: 6.0,
                menuElevation: 4.0,
                menuBarRadius: 0.0,
                menuBarElevation: 1.0,
                navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
                navigationBarMutedUnselectedLabel: false,
                navigationBarSelectedIconSchemeColor: SchemeColor.background,
                navigationBarMutedUnselectedIcon: false,
                navigationBarIndicatorSchemeColor: SchemeColor.primary,
                navigationBarIndicatorOpacity: 1.00,
                navigationBarBackgroundSchemeColor: SchemeColor.background,
                navigationBarElevation: 1.0,
                navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
                navigationRailMutedUnselectedLabel: false,
                navigationRailSelectedIconSchemeColor: SchemeColor.background,
                navigationRailMutedUnselectedIcon: false,
                navigationRailIndicatorSchemeColor: SchemeColor.primary,
                navigationRailIndicatorOpacity: 1.00,
              ),
              keyColors: const FlexKeyColors(
                useTertiary: true,
                keepPrimary: true,
                keepTertiary: true,
                keepPrimaryContainer: true,
                keepSecondaryContainer: true,
              ),
              tones: FlexTones.highContrast(Brightness.dark)
                  .onMainsUseBW()
                  .onSurfacesUseBW(),
              //  .surfacesUseBW(),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              swapLegacyOnMaterial3: true,
              // To use the Playground font, add GoogleFonts package and uncomment
              //  fontFamily: GoogleFonts.interTight().fontFamily,
            ),
            // If you do not have a themeMode switch, uncomment this line
            // to let the device system mode control the theme mode:
            // themeMode: ThemeMode.system,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
