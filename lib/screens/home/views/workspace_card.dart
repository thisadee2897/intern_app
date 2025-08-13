import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/providers/controllers/home_controller.dart';
import 'package:project/screens/home/views/insert_update_workspace_screen.dart';
import 'package:project/screens/project/views/project_screen.dart';

class WorkspaceCard extends ConsumerStatefulWidget {
  final WorkspaceModel workspace;
  final String title;
  final Color color;

  const WorkspaceCard(
    this.workspace, {
    super.key,
    required this.title,
    required this.color,
  });

  @override
  ConsumerState<WorkspaceCard> createState() => _WorkspaceCardState();
}

class _WorkspaceCardState extends ConsumerState<WorkspaceCard>
    with TickerProviderStateMixin {
  bool _hovering = false;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late AnimationController _shimmerController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation for hover effect
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    // Rotation animation for subtle 3D effect
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.02).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // Bounce animation for click effect
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Shimmer animation for elegant glow
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _bounceController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    setState(() => _hovering = true);
    _scaleController.forward();
    _rotationController.forward();
    _shimmerController.repeat(reverse: true);
  }

  void _onHoverExit() {
    setState(() => _hovering = false);
    _scaleController.reverse();
    _rotationController.reverse();
    _shimmerController.stop();
  }

  void _onTap() {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return AnimatedBuilder(
            animation: _bounceController,
            builder: (context, child) {
              return AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: (_scaleAnimation.value * _bounceAnimation.value)
                        .clamp(0.5, 2.0),
                    child: Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(_rotationAnimation.value)
                            ..rotateY(_rotationAnimation.value * 0.5),
                      child: OpenContainer(
                        closedElevation: _hovering ? 12 : 4,
                        openElevation: 0,
                        transitionType: ContainerTransitionType.fadeThrough,
                        transitionDuration: const Duration(milliseconds: 400),
                        closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        openBuilder: (context, _) {
                          String id = widget.workspace.id ?? '';
                          if (id.isEmpty) {
                            return const Center(
                              child: Text('Workspace ID is empty'),
                            );
                          }
                          return ProjectScreen(widget.workspace);
                        },
                        closedBuilder:
                            (context, openContainer) => GestureDetector(
                              onTap: () {
                                _onTap();
                                openContainer();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      widget.color.withOpacity(
                                        _hovering ? 0.9 : 0.8,
                                      ),
                                      widget.color.withOpacity(
                                        _hovering ? 0.7 : 0.6,
                                      ),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.color.withOpacity(
                                        _hovering ? 0.4 : 0.2,
                                      ),
                                      blurRadius: _hovering ? 20 : 8,
                                      offset: Offset(0, _hovering ? 8 : 4),
                                      spreadRadius: _hovering ? 2 : 0,
                                    ),
                                    if (_hovering)
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, -2),
                                        spreadRadius: -2,
                                      ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    children: [
                                      // Background pattern
                                      Positioned.fill(
                                        child: CustomPaint(
                                          painter: _PatternPainter(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Shimmer effect
                                      if (_hovering)
                                        AnimatedBuilder(
                                          animation: _shimmerController,
                                          builder: (context, child) {
                                            return Positioned.fill(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Transform.translate(
                                                  offset: Offset(
                                                    _shimmerAnimation.value *
                                                        200,
                                                    0,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment
                                                                .centerLeft,
                                                        end:
                                                            Alignment
                                                                .centerRight,
                                                        colors: [
                                                          Colors.transparent,
                                                          Colors.white
                                                              .withOpacity(0.3),
                                                          Colors.transparent,
                                                        ],
                                                        stops: const [
                                                          0.0,
                                                          0.5,
                                                          1.0,
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),

                                      // Content
                                      Positioned.fill(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Icon with animation
                                              AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(
                                                        _hovering ? 0.25 : 0.15,
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: const Icon(
                                                  Icons.work_outline_rounded,
                                                  size: 32,
                                                  color: Colors.white,
                                                ),
                                              ),

                                              const SizedBox(height: 16),

                                              // Title with subtle animation
                                              AnimatedDefaultTextStyle(
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                style: TextStyle(
                                                  fontSize: _hovering ? 18 : 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      offset: const Offset(
                                                        0,
                                                        1,
                                                      ),
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  widget.title,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),

                                              // Animated indicator
                                              AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                margin: const EdgeInsets.only(
                                                  top: 12,
                                                ),
                                                height: 3,
                                                width: _hovering ? 40 : 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            tooltip: "edit workspace",
                                            onPressed: () async {
                                              final result = await showDialog<
                                                bool
                                              >(
                                                context: context,
                                                builder:
                                                    (
                                                      context,
                                                    ) => InsertUpdateWorkspaceDialog(
                                                      workspace:
                                                          widget
                                                              .workspace, // ส่ง workspace เข้าไปเพื่อแก้ไข
                                                    ),
                                              );

                                              if (result == true) {
                                                // รีเฟรช workspace list
                                                ref.invalidate(
                                                  workspaceProvider,
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    const spacing = 30.0;
    const radius = 2.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
