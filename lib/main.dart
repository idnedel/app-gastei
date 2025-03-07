import 'package:flutter/cupertino.dart';
import 'screens/expense_selection_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'GASTEI',
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('GASTEI')),
      child: Center(
        child: AnimatedEntranceButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ExpenseSelectionScreen(),
              ),
            );
          },
          size: 220,
          color: CupertinoColors.systemGreen,
          child: Text(
            'GASTEI',
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedEntranceButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double size;
  final Color color;

  const AnimatedEntranceButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = 120,
    this.color = CupertinoColors.systemGreen,
  });

  @override
  AnimatedEntranceButtonState createState() => AnimatedEntranceButtonState();
}

class AnimatedEntranceButtonState extends State<AnimatedEntranceButton>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _entranceScaleAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // animação de entrada
    _entranceController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );
    _entranceScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );

    // animação de pulsação
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ordem de animações
    _entranceController.forward().then((_) {
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _entranceScaleAnimation,
        child: ScaleTransition(
          scale: _pulseAnimation,
          child: PaidButtonStyle(
            onPressed: widget.onPressed,
            size: widget.size,
            color: widget.color,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class PaidButtonStyle extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double size;
  final Color color;

  const PaidButtonStyle({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = 120,
    this.color = CupertinoColors.systemGreen,
  });

  @override
  PaidButtonStyleState createState() => PaidButtonStyleState();
}

class PaidButtonStyleState extends State<PaidButtonStyle> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _pressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _pressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _pressed ? 0.85 : 1.0,
        duration: Duration(milliseconds: 110),
        child: ClipOval(
          child: Container(
            width: widget.size,
            height: widget.size,
            color: widget.color,
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
