import 'dart:async'; // Cần thêm để dùng StreamSubscription
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const LocationStep({super.key, required this.onNext, required this.onSkip});

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  bool _isLocationEnabled = false;
  final TextEditingController _addressController = TextEditingController();
  final MapController _mapController = MapController();
  StreamSubscription? _mapEventSubscription;

  // Default location (e.g., Manhattan, NY)
  LatLng _currentCenter = const LatLng(40.7580, -73.9855);
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    // Lắng nghe sự kiện từ bản đồ để xử lý khi người dùng DỪNG kéo
    _mapEventSubscription = _mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveStart) {
        setState(() {
          _isMoving = true;
          // Khi bắt đầu kéo, hiển thị trạng thái đang tìm
          if (_isLocationEnabled) {
            _addressController.text = "Locating...";
          }
        });
      } else if (event is MapEventMoveEnd) {
        setState(() {
          _isMoving = false;
          _currentCenter = event.camera.center;
        });
        // Khi dừng kéo, cập nhật địa chỉ
        if (_isLocationEnabled) {
          _updateAddressFromCoordinates(_currentCenter);
        }
      }
    });
  }

  @override
  void dispose() {
    _mapEventSubscription?.cancel();
    _mapController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _enableLocation() async {
    // Giả lập loading tìm vị trí hiện tại
    setState(() {
      _addressController.text = "Locating...";
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLocationEnabled = true;
      // Di chuyển map đến vị trí mặc định (hoặc vị trí thực tế nếu có GPS)
      _mapController.move(_currentCenter, 15);
      _updateAddressFromCoordinates(_currentCenter);
    });
  }

  // Hàm giả lập Reverse Geocoding (Tọa độ -> Địa chỉ)
  void _updateAddressFromCoordinates(LatLng point) {
    // Trong thực tế, bạn sẽ gọi API Google Maps hoặc Geocoding tại đây
    // Ví dụ giả lập:
    final lat = point.latitude.toStringAsFixed(4);
    final lng = point.longitude.toStringAsFixed(4);

    // Giả lập độ trễ mạng nhẹ cho cảm giác thật
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _addressController.text = "701 7th Ave, New York ($lat, $lng)";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Content Layer (Map + Inputs)
        Column(
          children: [
            const SizedBox(height: 24),
            // ... (Phần Header giữ nguyên)
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Set Home ',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                children: const [
                  TextSpan(
                    text: 'Location',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Pin your home's location to enhance location-based features. Privacy is our priority.",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),

            // Map Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Interactive Map
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _currentCenter,
                          initialZoom: 15.0,
                          // Chỉ cho phép tương tác khi đã Enable Location
                          interactionOptions: InteractionOptions(
                            flags: _isLocationEnabled
                                ? InteractiveFlag.all
                                : InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            // 1. SỬ DỤNG MAP CARTO LIGHT ĐỂ GIỐNG HÌNH (TRẮNG/XÁM)
                            urlTemplate:
                                'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.doaniot.app',
                          ),
                        ],
                      ),

                      // 2. CENTER PIN (GHIM VỊ TRÍ) GIỐNG HÌNH
                      if (_isLocationEnabled)
                        Center(
                          child: Padding(
                            // Đẩy icon lên trên một chút để đầu nhọn trúng tâm màn hình
                            padding: const EdgeInsets.only(bottom: 35),
                            child: _buildCustomMarker(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Address Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Address Details",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressController,
                    readOnly: true,
                    // Hiển thị icon loading ở prefix nếu đang kéo map
                    decoration: InputDecoration(
                      prefixIcon: _isMoving
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primary,
                            ),
                      hintText: 'Address will appear here...',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Actions (Giữ nguyên)
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onSkip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F5F7),
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      // Nút Continue chỉ enable khi đã có Location và không đang di chuyển
                      onPressed: (_isLocationEnabled && !_isMoving)
                          ? widget.onNext
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Blur & Dialog Overlay (Giữ nguyên logic cũ)
        if (!_isLocationEnabled)
          Positioned.fill(
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Enable Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Please activate the location feature, so we can find your home address.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _enableLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Enable Location',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: widget.onSkip,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 52),
                            backgroundColor: const Color(0xFFEFF1F8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: const Text(
                            'Not Now',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Widget tạo Marker tùy chỉnh giống hình mẫu
  Widget _buildCustomMarker() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Bóng đổ bên dưới chân ghim
        Container(
          margin: const EdgeInsets.only(top: 40),
          width: 20,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 10)),
          ),
        ),
        // Thân ghim (Màu xanh)
        const Icon(
          Icons.location_on_rounded,
          size: 60,
          color: AppColors.primary,
        ),
        // Icon người dùng bên trong (Màu trắng)
        const Positioned(
          top: 10, // Căn chỉnh vị trí để nằm lọt vào vòng tròn của ghim
          child: Icon(Icons.person, size: 24, color: Colors.white),
        ),
      ],
    );
  }
}
