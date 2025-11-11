import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/../core/theme/app_pallet.dart';
import '/../data/models/user.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';
import '../widgets/user_list_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = ModalRoute.of(context)?.settings.arguments as User?;
    return Scaffold(
      appBar: AppBar(
        // Trả về tiêu đề động dựa trên người dùng đã xác thực
        title: Text(authenticatedUser != null
        ? 'Welcome ${authenticatedUser.username}'
        : 'Home',
            style: TextStyle(
              color: AppPallet.gradient1,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        backgroundColor: AppPallet.greyColor,
        foregroundColor: AppPallet.gradient1,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:  const EdgeInsets.only(top: 50),
            child: Text(
              'List of Users',
              style: TextStyle(
                color: AppPallet.gradient1,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),),),
          const SizedBox(height: 30),
          Expanded(
            child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              //Đang tải
              if (state is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              //Tải thành công
              if (state is UserSuccess) {
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return UserListItem(user: user);
                  },
                );
              }

              // Tải thất bại
              if (state is UserError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: AppPallet.errorColor, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return const Center(child: Text('Đang khởi tạo...'));
            },
          ),)
        ],
      ),    
    );
  }
}