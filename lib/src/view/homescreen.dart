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
    // return GetBuilder<Taskcontroller>(
    //   builder: (controller) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size(
          AppBar().preferredSize.width,
          AppBar().preferredSize.height,
        ),
        child: Obx(
          () => AppBar(
            title: const Text('Tasks Manager'),
            actions: [
              taskController.tileSelected.isEmpty
                  ? IconButton(onPressed: () {}, icon: Icon(Icons.search))
                  : SizedBox.shrink(),
              taskController.tileSelected.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        taskController.bulkDeleteTask(taskController.tileSelected);
                      },
                      icon: taskController.taskDeleteLoader.isTrue
                              ? const CircularProgressIndicator.adaptive()
                              :  Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.red,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
            elevation: 0.0,
            surfaceTintColor: Colors.grey.shade200,
          ),
        ),
      ),
      body: Obx(
        () => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          slivers: [
            SliverPersistentHeader(
              delegate: FilterHeaderDelegate(),
              pinned: true,
            ),

            taskController.gettingTaskLoader.isTrue
                ? SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 5.0,
                            childAspectRatio: 0.7,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => TaskCard(
                          taskController: taskController,
                          task: taskController.tasks[index],
                        ),
                        childCount: taskController.tasks.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'unique',
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 450),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const AddTask(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
