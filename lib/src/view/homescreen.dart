import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mgr_app/src/controller/taskcontroller.dart';
import 'package:task_mgr_app/src/view/addtask.dart';
import 'package:task_mgr_app/src/view/widgets/filterbuttons.dart';
import 'package:task_mgr_app/src/view/widgets/taskcard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final taskController = Get.put(Taskcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Tasks Manager'),
        elevation: 0.0,
        surfaceTintColor: Colors.grey.shade200,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          SliverPersistentHeader(
            delegate: FilterHeaderDelegate(),
            pinned: true,
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => const TaskCard(),
                childCount: 6,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'unique',
        onPressed: () {
         Navigator.push(
  context,
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animation, secondaryAnimation) => const AddTask(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.decelerate,   
        ),
        alignment: Alignment.bottomRight,
        child: child,
      );
    },
  ),
);
        },
        backgroundColor: Colors.grey.shade200,
        child: Icon(Icons.add),
      ),
    );
  }
}
