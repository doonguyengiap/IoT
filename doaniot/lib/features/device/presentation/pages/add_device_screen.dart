import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<DeviceItem> _foundDevices = [];
  bool _isNearbySelected = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Simulate finding devices
    _startScanning();
  }

  void _startScanning() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _foundDevices.add(
          DeviceItem(
            img: Image.asset("assets/den.png"),
            name: "Smart Light",
            top: 0.15,
            left: 0.15,
          ),
        );
      });
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _foundDevices.add(
          DeviceItem(
            img: Image.asset("assets/cam.png"),
            name: "Smart Camera",
            top: 0.15,
            right: 0.15,
          ),
        );
      });
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _foundDevices.add(
          DeviceItem(
            img: Image.asset("assets/wifi.png"),
            name: "Wi-Fi Router",
            top: 0.4,
            right: 0.05,
          ),
        );
      });
    }

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _foundDevices.add(
          DeviceItem(
            img: Image.asset("assets/dhoa.png"),
            name: "Air Conditioner",
            bottom: 0.15,
            right: 0.15,
          ),
        );
      });
    }

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _foundDevices.add(
          DeviceItem(
            img: Image.asset("assets/loa.png"),
            name: "Air Conditioner",
            bottom: 0.15,
            left: 0.15,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Device',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/qrscanner.svg",
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Toggle Switch
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isNearbySelected = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isNearbySelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Nearby Devices',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isNearbySelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isNearbySelected = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isNearbySelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Add Manual',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_isNearbySelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          Text(
            'Looking for nearby devices...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInstructionChip(
                Icons.wifi,
                "Turn on your Wifi & Bluetooth to connect",
              ),
            ],
          ),

          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ripples
                CustomPaint(
                  painter: RipplePainter(_controller),
                  size: const Size(250, 250),
                ),

                // Center User Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1)),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/mandevice.png",
                      fit: BoxFit.cover,
                    ), // Using 1.png as user avatar placeholder if user.png fails/isn't preferred
                  ),
                ),

                // Found Devices
                ..._foundDevices.map(
                  (device) => Positioned(
                    top: device.top != null
                        ? MediaQuery.of(context).size.width * device.top! + 50
                        : null,
                    bottom: device.bottom != null
                        ? MediaQuery.of(context).size.width * device.bottom! +
                              50
                        : null,
                    left: device.left != null
                        ? MediaQuery.of(context).size.width * device.left!
                        : null,
                    right: device.right != null
                        ? MediaQuery.of(context).size.width * device.right!
                        : null,
                    child: _buildDeviceItem(device),
                  ),
                ),
              ],
            ),
          ),

          // Connect Button
          if (_foundDevices.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Connect to All Devices',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Can't find your devices? \nLearn more",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInstructionChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 8),
          // Also adding bluetooth icon as per design
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bluetooth, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(DeviceItem device) {
    return Column(
      children: [Container(width: 60, height: 60, child: device.img)],
    );
  }
}

class DeviceItem {
  final Image img;
  final String name;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

class DeviceItem {
  final Image img;
  final String name;
  final Alignment alignment;

  DeviceItem({
    required this.img,
    required this.name,
    required this.alignment,
  });
}

class RipplePainter extends CustomPainter {
  final Animation<double> animation;

  RipplePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
          .withOpacity(0.3) // Light blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw 3 expanding circles
    for (int i = 0; i < 3; i++) {
      final progress = (animation.value + i / 3) % 1.0;
      final radius = progress * size.width * 0.4 + 50;
      final opacity = 1.0 - progress;

      paint.color = AppColors.primary.withOpacity(opacity * 0.5); // Fade out
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
