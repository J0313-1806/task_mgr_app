import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:task_mgr_app/src/controller/taskcontroller.dart';
import 'package:task_mgr_app/src/view/addtask.dart';
import 'package:task_mgr_app/src/view/widgets/customsearch.dart';
import 'package:task_mgr_app/src/view/widgets/filterbuttons.dart';
import 'package:task_mgr_app/src/view/widgets/taskcard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final taskController = Get.put(Taskcontroller());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size(
            AppBar().preferredSize.width,
            taskController.searchButtonTap.isTrue
                ? AppBar().preferredSize.height + 50
                : AppBar().preferredSize.height,
          ),
          child: taskController.searchButtonTap.isTrue
              ? CustomSearchBar(taskController: taskController)
              : AppBar(
                  title: const Text('Tasks Manager'),
                  actions: [
                    taskController.tileSelected.isEmpty
                        ? IconButton(
                            onPressed: () {
                              taskController.onSearchTapped();
                            },
                            icon: Icon(Icons.search),
                          )
                        : SizedBox.shrink(),
                    taskController.tileSelected.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              taskController.bulkDeleteTask(
                                taskController.tileSelected,
                              );
                            },
                            icon: taskController.taskDeleteLoader.isTrue
                                ? const CircularProgressIndicator.adaptive()
                                : Icon(
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
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          // primary: false,
          shrinkWrap: true,
          slivers: [
            taskController.searchButtonTap.isTrue
                ? SliverToBoxAdapter()
                : SliverPersistentHeader(
                    delegate: FilterHeaderDelegate(),
                    pinned: true,
                  ),
            taskController.tasks.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "No tasks found.\nPlease add some tasks.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: Colors.grey),
                      ),
                    ),
                  )
                : taskController.gettingTaskLoader.isTrue
                ? SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  )
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        bottom: 50,
                      ),
                      child: ReorderableGridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        primary: false,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        onReorder: (oldIndex, newIndex) {
                          taskController.movingTask(
                            taskController.tasks[oldIndex].id!,
                            oldIndex,
                            newIndex,
                          );
                        },
                        itemCount: taskController.tasks.length,
                        itemBuilder: (context, index) => TaskCard(
                          key: ValueKey(
                            taskController.tasks[index].id.toString(),
                          ),
                          taskController: taskController,
                          task: taskController.tasks[index],
                        ),
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
      ),
    );
  }
}
