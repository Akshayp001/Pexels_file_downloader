import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';
import '../widgets/photo_list_item.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: true,
                pinned: true,
                snap: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        innerBoxIsScrolled
                            ? BorderRadius.zero
                            : const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Obx(() {
                      if (controller.isSearching.value) {
                        return Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: controller.searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Search photos...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            onChanged:
                                (value) => controller.searchPhotos(value),
                          ),
                        );
                      } else {
                        return TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Text(
                                'Pexels Gallery',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background with a shader effect
                        ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black, Colors.transparent],
                            ).createShader(
                              Rect.fromLTRB(0, 0, rect.width, rect.height),
                            );
                          },
                          blendMode: BlendMode.dstIn,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://img.freepik.com/free-vector/abstract-background-with-geometric-design_1048-2181.jpg',
                                ),
                                fit: BoxFit.cover,
                                opacity: 0.3,
                              ),
                            ),
                          ),
                        ),
                        // Logo and name at the top
                        const Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              'PEXELS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  // Search button
                  Obx(() {
                    return IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return RotationTransition(
                            turns: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child:
                            controller.isSearching.value
                                ? const Icon(
                                  Icons.close,
                                  key: ValueKey('close'),
                                  color: Colors.white,
                                )
                                : const Icon(
                                  Icons.search,
                                  key: ValueKey('search'),
                                  color: Colors.white,
                                ),
                      ),
                      onPressed: () => controller.toggleSearch(),
                    );
                  }),
                  // View toggle (Grid/List)
                  Obx(() {
                    return IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child:
                            controller.isGridView.value
                                ? const Icon(
                                  Icons.view_list,
                                  key: ValueKey('list'),
                                  color: Colors.white,
                                )
                                : const Icon(
                                  Icons.grid_view,
                                  key: ValueKey('grid'),
                                  color: Colors.white,
                                ),
                      ),
                      onPressed: () => controller.toggleViewMode(),
                    );
                  }),
                ],
              ),
            ];
          },
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.network(
                      'https://assets9.lottiefiles.com/packages/lf20_cBJ5CKUPH0.json',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Loading beautiful photos...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else if (controller.photos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.network(
                      'https://assets6.lottiefiles.com/packages/lf20_kji8ixzy.json',
                      height: 200,
                    ),
                    const Text(
                      'No photos found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Try searching for something else',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Obx(() {
                  return controller.isGridView.value
                      ? _buildGridView()
                      : _buildListView();
                }),
              );
            }
          }),
        ),
      ),
      // Floating action button for random photos
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.loadRandomPhotos(),
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.shuffle),
        elevation: 4,
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Filter logic would go here
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blueAccent.withOpacity(0.3),
        checkmarkColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildListView() {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: controller.photos.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final photo = controller.photos[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Obx(
                  () => PhotoListItem(
                    photo: photo,
                    downloadProgress: controller.downloadProgress[photo['id']],
                    onDownload: () {
                      final url = photo['src']['original']?.toString() ?? '';
                      final id = photo['id']?.toString() ?? '';

                      if (url.isEmpty) {
                        controller.showError("Invalid image URL.");
                        return;
                      }

                      int? photoId = int.tryParse(id);
                      if (photoId == null) {
                        controller.showError("Invalid photo ID.");
                        return;
                      }

                      controller.downloadFile(url, id, photoId);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView() {
    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.photos.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final photo = controller.photos[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to photo detail
                    Get.toNamed('/photo-detail', arguments: photo);
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Photo thumbnail
                        Expanded(
                          child: Hero(
                            tag: 'photo_grid_${photo['id']}',
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: photo['src']['medium'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder:
                                    (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(color: Colors.white),
                                    ),
                                errorWidget:
                                    (context, url, error) =>
                                        const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        // Photographer info and download button
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                photo['photographer'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${photo['width']}×${photo['height']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Download button with progress indicator
                              Obx(() {
                                final isDownloading = controller
                                    .downloadProgress
                                    .containsKey(photo['id']);
                                return SizedBox(
                                  width: double.infinity,
                                  height: 30,
                                  child:
                                      isDownloading
                                          ? LinearProgressIndicator(
                                            value:
                                                controller
                                                    .downloadProgress[photo['id']],
                                            backgroundColor: Colors.grey[300],
                                            color: Colors.blueAccent,
                                          )
                                          : ElevatedButton(
                                            onPressed:
                                                () => controller.downloadFile(
                                                  photo['src']['original'],
                                                  '${photo['id']}',
                                                  photo['id'],
                                                ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(
                                                double.infinity,
                                                30,
                                              ),
                                            ),
                                            child: const Text(
                                              'Download',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
