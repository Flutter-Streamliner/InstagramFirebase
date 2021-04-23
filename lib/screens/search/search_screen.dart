import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/search/cubit/search_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/widgets/widgets.dart';

import '../screens.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none,
              hintText: 'Search Users',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear), 
                onPressed: () {
                  context.read<SearchCubit>().clearSearch();
                  _searchController.clear();
                },
              ),
            ),
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context.read<SearchCubit>().searchUsers(value.trim());
              }
            },
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:
                return CentredText(
                  text: state.failure.message
                );
              case SearchStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case SearchStatus.loaded:
                return state.users.isNotEmpty 
                  ? ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = state.users[index];
                      return ListTile(
                        leading: UserProfileImage(radius: 22.0, profileImageUrl: user.profileImageUrl),
                        title: Text(user.username, style: const TextStyle(fontSize: 16.0)),
                        onTap: () => Navigator.of(context).pushNamed(
                          ProfileScreen.routeName, 
                          arguments: ProfileScreenArgs(userId: user.id),
                        ),
                      );
                    },
                  )
                  : CentredText(text: 'No Users Found');
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
