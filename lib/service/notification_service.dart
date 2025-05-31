import 'package:flutter/material.dart';

class NotificationOverlay extends StatefulWidget {
  final Widget child;
  const NotificationOverlay({Key? key, required this.child}) : super(key: key);

  @override
  State<NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<NotificationOverlay>
    with TickerProviderStateMixin {
  bool _showNotification = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Simulasi delay seperti loading app, lalu tampilkan notifikasi
    Future.delayed(Duration(seconds: 2), () {
      _showAppNotification();
    });
  }

  void _showAppNotification() {
    if (mounted) {
      setState(() {
        _showNotification = true;
      });
      _animationController.forward();

      // Auto hide setelah 4 detik
      Future.delayed(Duration(seconds: 4), () {
        _hideNotification();
      });
    }
  }

  void _hideNotification() {
    if (mounted) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showNotification = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          if (_showNotification)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildNotificationCard(),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Color(0xffCEAB93),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon notifikasi
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xffCEAB93),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          
          // Content notifikasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selamat Datang! 🎉',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffAD8B73),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Jangan lupa cek fitur convert mata uang terbaru kami!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Close button
          GestureDetector(
            onTap: _hideNotification,
            child: Container(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                color: Colors.grey[400],
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}