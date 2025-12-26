import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:doaniot/features/device/presentation/pages/add_device_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedRoom = "All Rooms";
  String _selectedHome = "My Home";

  final List<String> _rooms = [
    "All Rooms",
    "Living Room",
    "Bedroom",
    "Kitchen",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PopupMenuButton<String>(
                          onSelected: (String result) {
                            setState(() {
                              _selectedHome = result;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          offset: const Offset(0, 48),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'My Home',
                                  child: Text('My Home'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Office',
                                  child: Text('Office'),
                                ),
                              ],
                          child: Row(
                            children: [
                              // giá trị phụ thuộc vào giá trị được chọn
                              Text(
                                _selectedHome,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            // robot
                            InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(30),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                child: Image.asset("assets/robot.png"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // notification icon
                            InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(30),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                child: Stack(
                                  children: [
                                    SvgPicture.asset("assets/bellico.svg"),
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Weather Card (Reduced padding/height)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ), // Reduced vertical padding
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3D5AFE),
                            Color(0xFF536DFE),
                          ], // Blue gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3D5AFE).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '20',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      '°C',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 8),
                              Text(
                                'New York City, USA',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Today Cloudy',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _weatherDetail(Icons.air, "AQI 92"),
                                  const SizedBox(width: 16),
                                  _weatherDetail(
                                    Icons.water_drop_outlined,
                                    "78.2%",
                                  ),
                                  const SizedBox(width: 16),
                                  _weatherDetail(Icons.speed, "2.0 m/s"),
                                ],
                              ),
                            ],
                          ),
                          // Cloud/Sun Icon
                          Image.asset(
                            "assets/cloudsun.png",
                            width: 60,
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // All Devices Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Devices',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const Icon(
                          Icons.more_vert,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _rooms
                            .map(
                              (room) => Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: _buildFilterChip(
                                  room,
                                  _selectedRoom == room,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Empty State
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            child: Image.asset("assets/task.png"),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Devices',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "You haven't added a device yet.",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 24),
                          // Resized Add Device Button
                          SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddDeviceScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add Device'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                          // Add enough space for FABs at the bottom
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating Action Buttons
            Positioned(
              bottom: 24,
              right:
                  90, // Positioned to the left of the add button (24 + 56 + 10 spacing)
              child: FloatingActionButton(
                heroTag: "mic_fab",
                onPressed: () {},
                backgroundColor: AppColors.secondary,
                shape: CircleBorder(),
                elevation: 0,
                child: SvgPicture.asset(
                  "assets/micico.svg",
                  color: AppColors.primary,
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                heroTag: "add_fab",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddDeviceScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: CircleBorder(), // Ensure circular
                elevation: 0,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      // Removed Scaffold FAB to use custom Positioned in Stack for dual FABs
    );
  }

  Widget _weatherDetail(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRoom = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
