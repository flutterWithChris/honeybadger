import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:honeybadger/auth/bloc/auth_bloc.dart';
import 'package:honeybadger/auth/cubit/signup/signup_cubit.dart';
import 'package:honeybadger/auth/repository/auth_repository.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/router/app_router.dart';
import 'package:honeybadger/firebase_options.dart';
import 'package:honeybadger/message/bloc/messages_bloc.dart';
import 'package:honeybadger/message/repository/message_repository.dart';
import 'package:honeybadger/onboarding/bloc/onboarding_bloc.dart';
import 'package:honeybadger/payments/bloc/history/payment_history_bloc.dart';
import 'package:honeybadger/payments/bloc/payments_bloc.dart';
import 'package:honeybadger/payments/repository/payments_repository.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/proposals/bloc/proposal_bloc.dart';
import 'package:honeybadger/proposals/repo/proposal_repository.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SB_CALLBACK_URL']!,
    anonKey: dotenv.env['SB_PUB_MAG']!,
    debug: true,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAuth.instance.signOut();
  StreamChatClient client = StreamChatClient(
    dotenv.get('STREAM_API_KEY'),
    logLevel: Level.INFO,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository()),
        RepositoryProvider<ProposalRepository>(
          create: (context) => ProposalRepository(),
        ),
        RepositoryProvider<MessageRepository>(
          create: (context) => MessageRepository(),
        ),
        RepositoryProvider<PaymentsRepository>(
          create: (context) => PaymentsRepository()..initializeStripe(),
        ),
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
            create: (context) => OnboardingBloc(),
          ),
          BlocProvider(
              lazy: false,
              create: (context) => ProfileBloc()..add(LoadProfile())),
          BlocProvider<PaymentHistoryBloc>(
            create: (context) => PaymentHistoryBloc()
              ..add(const FetchPaymentHistory(userId: 'userId')),
          ),
          BlocProvider<MessagesBloc>(
            create: (context) => MessagesBloc(
              messageRepository: context.read<MessageRepository>(),
            )..add(LoadMessages()),
          ),
          BlocProvider<ProposalBloc>(
            create: (context) => ProposalBloc(
                messagesBloc: context.read<MessagesBloc>(),
                proposalRepository: context.read<ProposalRepository>()),
          ),
          BlocProvider(
            create: (context) => PaymentsBloc(
                paymentsRepository: context.read<PaymentsRepository>())
              ..add(
                LoadPayments(),
              ),
          )
        ],
        child: MaterialApp.router(
          scaffoldMessengerKey: scaffoldKey,
          routeInformationParser: goRouter.routeInformationParser,
          routerDelegate: goRouter.routerDelegate,
          routeInformationProvider: goRouter.routeInformationProvider,

          title: 'Honeybadger ',
          builder: (context, child) => StreamChat(
              client: StreamChatClient(
                dotenv.env['STREAM_API_KEY']!,
                logLevel: Level.INFO,
              ),
              child: child),
          debugShowCheckedModeBanner: false,
          // Theme config for FlexColorScheme version 7.1.x. Make sure you use
          // same or higher package version, but still same major version. If you
          // use a lower package version, some properties may not be supported.
          // In that case remove them after copying this theme to your app.
          theme: FlexThemeData.light(
            scheme: FlexScheme.flutterDash,
            surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
            blendLevel: 1,
            appBarStyle: FlexAppBarStyle.background,
            bottomAppBarElevation: 2.0,
            subThemesData: FlexSubThemesData(
              cardElevation: 0.618,
              defaultRadius: 24.0,
              buttonMinSize: const Size(200, 40),
              filledButtonTextStyle: MaterialStatePropertyAll(
                  Theme.of(context).textTheme.titleMedium),
              blendOnLevel: 6,
              blendOnColors: false,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              adaptiveElevationShadowsBack:
                  const FlexAdaptive.excludeWebAndroidFuchsia(),
              adaptiveAppBarScrollUnderOff:
                  const FlexAdaptive.excludeWebAndroidFuchsia(),
              defaultRadiusAdaptive: 10.0,
              adaptiveRadius: const FlexAdaptive.all(),
              elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
              elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
              outlinedButtonOutlineSchemeColor: SchemeColor.primary,
              toggleButtonsBorderSchemeColor: SchemeColor.primary,
              segmentedButtonSchemeColor: SchemeColor.primary,
              segmentedButtonBorderSchemeColor: SchemeColor.primary,
              unselectedToggleIsColored: true,
              sliderValueTinted: true,
              inputDecoratorSchemeColor: SchemeColor.primary,
              inputDecoratorBackgroundAlpha: 19,
              inputDecoratorUnfocusedHasBorder: false,
              inputDecoratorFocusedBorderWidth: 1.0,
              inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
              fabUseShape: true,
              fabAlwaysCircular: true,
              fabSchemeColor: SchemeColor.tertiary,
              cardRadius: 24.0,
              popupMenuRadius: 6.0,
              popupMenuElevation: 3.0,
              dialogRadius: 18.0,
              datePickerDialogRadius: 18.0,
              timePickerDialogRadius: 18.0,
              appBarScrolledUnderElevation: 1.0,
              drawerElevation: 1.0,
              drawerIndicatorSchemeColor: SchemeColor.primary,
              bottomSheetRadius: 18.0,
              bottomSheetElevation: 2.0,
              bottomSheetModalElevation: 4.0,
              bottomNavigationBarMutedUnselectedLabel: false,
              bottomNavigationBarMutedUnselectedIcon: false,
              menuRadius: 6.0,
              menuElevation: 3.0,
              menuBarRadius: 0.0,
              menuBarElevation: 1.0,
              menuBarShadowColor: const Color(0x00000000),
              navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
              navigationBarMutedUnselectedLabel: false,
              navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
              navigationBarMutedUnselectedIcon: false,
              navigationBarIndicatorSchemeColor: SchemeColor.primary,
              navigationBarIndicatorOpacity: 1.00,
              navigationBarElevation: 1.0,
              navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
              navigationRailMutedUnselectedLabel: false,
              navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
              navigationRailMutedUnselectedIcon: false,
              navigationRailIndicatorSchemeColor: SchemeColor.primary,
              navigationRailIndicatorOpacity: 1.00,
              navigationRailBackgroundSchemeColor: SchemeColor.surface,
            ),
            useMaterial3ErrorColors: true,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            // To use the Playground font, add GoogleFonts package and uncomment
            // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.flutterDash,
            surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
            blendLevel: 2,
            appBarStyle: FlexAppBarStyle.background,
            bottomAppBarElevation: 2.0,
            subThemesData: const FlexSubThemesData(
              cardElevation: 0.618,
              defaultRadius: 24.0,
              cardRadius: 24.0,
              buttonMinSize: Size(200, 40),
              blendOnLevel: 8,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              adaptiveElevationShadowsBack: FlexAdaptive.all(),
              adaptiveAppBarScrollUnderOff:
                  FlexAdaptive.excludeWebAndroidFuchsia(),
              defaultRadiusAdaptive: 10.0,
              adaptiveRadius: FlexAdaptive.all(),
              elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
              elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
              outlinedButtonOutlineSchemeColor: SchemeColor.primary,
              toggleButtonsBorderSchemeColor: SchemeColor.primary,
              segmentedButtonSchemeColor: SchemeColor.primary,
              segmentedButtonBorderSchemeColor: SchemeColor.primary,
              unselectedToggleIsColored: true,
              sliderValueTinted: true,
              inputDecoratorSchemeColor: SchemeColor.primary,
              inputDecoratorBackgroundAlpha: 22,
              inputDecoratorUnfocusedHasBorder: false,
              inputDecoratorFocusedBorderWidth: 1.0,
              inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
              fabUseShape: true,
              fabAlwaysCircular: true,
              fabSchemeColor: SchemeColor.tertiary,
              popupMenuRadius: 6.0,
              popupMenuElevation: 3.0,
              dialogRadius: 18.0,
              datePickerDialogRadius: 18.0,
              timePickerDialogRadius: 18.0,
              appBarScrolledUnderElevation: 3.0,
              drawerElevation: 1.0,
              drawerIndicatorSchemeColor: SchemeColor.primary,
              bottomSheetRadius: 18.0,
              bottomSheetElevation: 2.0,
              bottomSheetModalElevation: 4.0,
              bottomNavigationBarMutedUnselectedLabel: false,
              bottomNavigationBarMutedUnselectedIcon: false,
              menuRadius: 6.0,
              menuElevation: 3.0,
              menuBarRadius: 0.0,
              menuBarElevation: 1.0,
              menuBarShadowColor: Color(0x00000000),
              navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
              navigationBarMutedUnselectedLabel: false,
              navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
              navigationBarMutedUnselectedIcon: false,
              navigationBarIndicatorSchemeColor: SchemeColor.primary,
              navigationBarIndicatorOpacity: 1.00,
              navigationBarElevation: 1.0,
              navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
              navigationRailMutedUnselectedLabel: false,
              navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
              navigationRailMutedUnselectedIcon: false,
              navigationRailIndicatorSchemeColor: SchemeColor.primary,
              navigationRailIndicatorOpacity: 1.00,
              navigationRailBackgroundSchemeColor: SchemeColor.surface,
            ),
            useMaterial3ErrorColors: true,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            // To use the Playground font, add GoogleFonts package and uncomment
            // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          // If you do not have a themeMode switch, uncomment this line
          // to let the device system mode control the theme mode:
          // themeMode: ThemeMode.system,
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
