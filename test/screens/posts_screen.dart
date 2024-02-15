import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';
import 'package:hollychat/auth/services/auth_repository.dart';
import 'package:hollychat/models/minimal_post.dart';
import 'package:hollychat/posts/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'package:hollychat/posts/bloc/posts_bloc/posts_bloc.dart';
import 'package:hollychat/posts/screens/post_details_screen.dart';
import 'package:hollychat/posts/screens/posts_screen.dart';
import 'package:hollychat/posts/widgets/post_preview.dart';

void main() {
  group('PostsScreen Widget Tests', () {
    late AuthBloc authBloc;
    late PostsBloc postsBloc;
    late DeletePostBloc deletePostBloc;

    late AuthRepository authRepository;

    setUp(() {
      authRepository = AuthRepository(authDataSource: null);
      authBloc = AuthBloc(authRepository: authRepository);
      postsBloc = PostsBloc(postsRepository: null);
      deletePostBloc = DeletePostBloc(postsRepository: null);
    });

    testWidgets('Floating action button visible when authenticated',
        (WidgetTester tester) async {
      authBloc.emit(AuthState(
        status: AuthStatus.success,
      )); // Simulate authenticated state
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authBloc,
            child: BlocProvider.value(
              value: postsBloc,
              child: BlocProvider.value(
                value: deletePostBloc,
                child: PostsScreen(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Floating action button not visible when not authenticated',
        (WidgetTester tester) async {
      authBloc.emit(AuthState(
        status: AuthStatus.initial,
      )); // Simulate unauthenticated state
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authBloc,
            child: BlocProvider.value(
              value: postsBloc,
              child: BlocProvider.value(
                value: deletePostBloc,
                child: PostsScreen(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('AppBar action changes when authenticated',
        (WidgetTester tester) async {
      authBloc.emit(AuthState(
        status: AuthStatus.success,
      ));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authBloc,
            child: BlocProvider.value(
              value: postsBloc,
              child: BlocProvider.value(
                value: deletePostBloc,
                child: PostsScreen(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(PopupMenuButton), findsOneWidget);
    });

    testWidgets('AppBar action changes when not authenticated',
        (WidgetTester tester) async {
      authBloc.emit(AuthState(
        status: AuthStatus.initial,
      ));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authBloc,
            child: BlocProvider.value(
              value: postsBloc,
              child: BlocProvider.value(
                value: deletePostBloc,
                child: PostsScreen(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('Post preview tap navigates to post details',
        (WidgetTester tester) async {
      authBloc.emit(AuthState(
        status: AuthStatus.success,
      ));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authBloc,
            child: BlocProvider.value(
              value: postsBloc,
              child: BlocProvider.value(
                value: deletePostBloc,
                child: PostsScreen(),
              ),
            ),
          ),
        ),
      );

      final post = MinimalPost(
          id: null,
          originalText: '',
          image: null,
          linksPreviews: [],
          links: [],
          author: null,
          content: [],
          commentsCount: null,
          linkImages: []);

      // Find the post preview widget and tap on it
      await tester.tap(find.byWidgetPredicate(
        (widget) => widget is PostPreview && widget.post == post,
      ));

      // Wait for the navigation to complete
      await tester.pumpAndSettle();

      // Ensure the navigation pushed the PostDetailsScreen
      expect(find.byType(PostDetailsScreen), findsOneWidget);
    });

    // You can write more tests to cover different scenarios and edge cases
  });
}
