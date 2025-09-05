import 'package:flutter/material.dart';
import 'dart:math' as math;


/// Interactive TechTips Command Center Onboarding
class OnboardingPage extends StatefulWidget {
  final VoidCallback? onOnboardingComplete;

  const OnboardingPage({super.key, this.onOnboardingComplete});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _terminalController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  late AnimationController _completionController;
  late AnimationController _fireworksController;
  late AnimationController _textRevealController;
  late AnimationController _hologramController;
  late AnimationController _matrixController;
  late AnimationController _orbitController;
  
  late Animation<double> _backgroundOpacity;
  late Animation<double> _terminalScale;
  late Animation<double> _terminalOpacity;
  late Animation<double> _glowIntensity;
  late Animation<double> _particleRotation;
  late Animation<double> _completionScale;
  late Animation<double> _completionOpacity;
  late Animation<double> _textSlide;



  final TextEditingController _commandController = TextEditingController();
  final FocusNode _commandFocus = FocusNode();
  final List<String> _terminalHistory = [];
  final List<CommandZone> _zones = [];
  
  int _currentZoneIndex = 0;
  bool _isTyping = false;
  String _currentCommand = '';

  bool _showCompletion = false;


  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeCommandZones();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _terminalController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );

                  _completionController = AnimationController(
                duration: const Duration(milliseconds: 2500),
                vsync: this,
              );
            
              _fireworksController = AnimationController(
                duration: const Duration(milliseconds: 3000),
                vsync: this,
              );
            
              _textRevealController = AnimationController(
                duration: const Duration(milliseconds: 2000),
                vsync: this,
              );

    _hologramController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _matrixController = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    );

    _orbitController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );

    _backgroundOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeOutCubic,
    ));

    _terminalScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _terminalController,
      curve: Curves.elasticOut,
    ));

    _terminalOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _terminalController,
      curve: Curves.easeOut,
    ));

    _glowIntensity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _particleRotation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));

                  _completionScale = Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: _completionController,
                curve: Curves.easeOutCubic,
              ));
            
              _completionOpacity = Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: _completionController,
                curve: Curves.easeInOut,
              ));
            
              _textSlide = Tween<double>(
                begin: 60.0,
                end: 0.0,
              ).animate(CurvedAnimation(
                parent: _textRevealController,
                curve: Curves.easeOutCubic,
              ));




  }

  void _initializeCommandZones() {
    _zones.addAll([
      CommandZone(
        name: 'WINDOWS_MASTERY',
        displayName: 'Windows Mastery',
        description: 'Unlock powerful Windows shortcuts',
        command: 'unlock windows',
        shortcuts: [
          'Win + Tab: Task View',
          'Win + D: Show Desktop',
          'Win + L: Lock Computer',
          'Win + V: Clipboard History',
          'Win + .: Emoji Panel',
        ],
        color: Colors.blue,
        icon: Icons.computer,
      ),
      CommandZone(
        name: 'MAC_PRODUCTIVITY',
        displayName: 'Mac Productivity',
        description: 'Master macOS efficiency',
        command: 'unlock mac',
        shortcuts: [
          'Cmd + Space: Spotlight',
          'Cmd + Tab: App Switcher',
          'Cmd + Q: Quit App',
          'Cmd + Shift + 4: Screenshot',
          'Cmd + Option + D: Dock Toggle',
        ],
        color: Colors.grey,
        icon: Icons.apple,
      ),
      CommandZone(
        name: 'LINUX_POWER',
        displayName: 'Linux Power',
        description: 'Harness terminal commands',
        command: 'unlock linux',
        shortcuts: [
          'Ctrl + Alt + T: Terminal',
          'Ctrl + L: Clear Terminal',
          'Ctrl + R: Search History',
          'Ctrl + A: Select All',
          'Ctrl + K: Cut Line',
        ],
        color: Colors.orange,
        icon: Icons.terminal,
      ),
    ]);
  }

  void _startAnimationSequence() async {
    _backgroundController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _terminalController.forward();
    _glowController.repeat(reverse: true);
    _particleController.repeat();
    
    // Start typing animation
    await Future.delayed(const Duration(milliseconds: 800));
    _startTypingAnimation();
  }

  void _startTypingAnimation() async {
    setState(() {
      _isTyping = true;
    });

    final command = _zones[_currentZoneIndex].command;
    for (int i = 0; i < command.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _currentCommand = command.substring(0, i + 1);
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));
    _executeCommand();
  }

  void _executeCommand() {
    setState(() {
      _isTyping = false;
      _terminalHistory.add('> $_currentCommand');
      _terminalHistory.add('Unlocking ${_zones[_currentZoneIndex].displayName}...');
      _terminalHistory.add('Access granted! 🚀');
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_currentZoneIndex < _zones.length - 1) {
        setState(() {
          _currentZoneIndex++;
          _currentCommand = '';
        });
        _startTypingAnimation();
      } else {
        _completeOnboarding();
      }
    });
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _showCompletion = true;
    });

    // Stagger animations for smooth flow
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Start completion scale and opacity
    _completionController.forward();
    
    // Wait for completion to start, then reveal text
    await Future.delayed(const Duration(milliseconds: 800));
    _textRevealController.forward();

    // Wait for all animations to complete
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      widget.onOnboardingComplete?.call();
    }
  }



  @override
  void dispose() {
    _backgroundController.dispose();
    _terminalController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    _completionController.dispose();
    _fireworksController.dispose();
    _textRevealController.dispose();
    _hologramController.dispose();
    _matrixController.dispose();
    _orbitController.dispose();
    _commandController.dispose();
    _commandFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1200;
    final isDesktop = size.width >= 1200;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Opacity(
            opacity: _backgroundOpacity.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark 
                    ? [
                        Colors.black,
                        Color(0xFF0A0A0A),
                        Color(0xFF1A1A2E),
                        Colors.black,
                      ]
                    : [
                        Colors.white,
                        Color(0xFFF8F9FA),
                        Color(0xFFE9ECEF),
                        Color(0xFFF1F3F4),
                      ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  // Animated background particles
                  _buildParticleBackground(isDark),
                  
                  // Main content with responsive padding
                  SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : isTablet ? 40 : 60,
                          vertical: isMobile ? 20 : isTablet ? 40 : 60,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Header
                            _buildHeader(isDark, isMobile, isTablet, isDesktop),
                            
                            SizedBox(height: isMobile ? 30 : isTablet ? 40 : 50),
                            
                            // Terminal interface
                            _buildTerminal(isDark, isMobile, isTablet, isDesktop),
                            
                            SizedBox(height: isMobile ? 30 : isTablet ? 40 : 50),
                            
                            // Progress indicator
                            _buildProgressIndicator(isDark, isMobile, isTablet, isDesktop),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Completion overlay
                  if (_showCompletion) _buildCompletionOverlay(isDark, isMobile, isTablet, isDesktop),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isMobile, bool isTablet, bool isDesktop) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + _glowIntensity.value * 0.05,
          child: Column(
            children: [
              Text(
                'TECHTIPS',
                style: TextStyle(
                  fontSize: isMobile ? 32 : isTablet ? 40 : 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                  letterSpacing: isMobile ? 4 : isTablet ? 6 : 8,
                  shadows: [
                    Shadow(
                        color: Colors.cyan.withValues(alpha: 0.8),
                      blurRadius: 20 + _glowIntensity.value * 10,
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 12 : isTablet ? 14 : 16),
              Text(
                'COMMAND CENTER',
                style: TextStyle(
                  fontSize: isMobile ? 14 : isTablet ? 16 : 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.cyan.withValues(alpha: 0.7),
                  letterSpacing: isMobile ? 2 : isTablet ? 3 : 4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTerminal(bool isDark, bool isMobile, bool isTablet, bool isDesktop) {
    return AnimatedBuilder(
      animation: _terminalController,
      builder: (context, child) {
        return Transform.scale(
          scale: _terminalScale.value,
          child: Opacity(
            opacity: _terminalOpacity.value,
            child: Container(
              width: isMobile ? double.infinity : isTablet ? 500 : 600,
              height: isMobile ? 300 : isTablet ? 350 : 400,
              decoration: BoxDecoration(
                color: isDark 
                  ? Colors.black.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.cyan.withValues(alpha: 0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                      ? Colors.cyan.withValues(alpha: 0.3)
                      : Colors.cyan.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Terminal header
                  Container(
                    padding: EdgeInsets.all(isMobile ? 12 : isTablet ? 14 : 16),
                    decoration: BoxDecoration(
                      color: isDark 
                        ? Colors.cyan.withValues(alpha: 0.1)
                        : Colors.cyan.withValues(alpha: 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'TechTips Terminal',
                          style: TextStyle(
                            color: isDark 
                              ? Colors.cyan.withValues(alpha: 0.8)
                              : Colors.cyan.withValues(alpha: 0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Terminal content
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 16 : isTablet ? 18 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Terminal history
                          Expanded(
                            child: ListView.builder(
                              itemCount: _terminalHistory.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    _terminalHistory[index],
                                    style: TextStyle(
                                      color: isDark 
                                      ? Colors.green.withValues(alpha: 0.8)
                                      : Colors.green.withValues(alpha: 0.8),
                                      fontSize: 14,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          // Current command line
                          Row(
                            children: [
                              Text(
                                '> ',
                                style: TextStyle(
                                  color: Colors.cyan,
                                  fontSize: 16,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _currentCommand,
                                  style: TextStyle(
                                    color: isDark 
                                      ? Colors.white
                                      : Colors.black.withValues(alpha: 0.8),
                                    fontSize: 16,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              if (_isTyping)
                                Container(
                                  width: 8,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: isDark 
                                      ? Colors.cyan
                                      : Colors.cyan.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(bool isDark, bool isMobile, bool isTablet, bool isDesktop) {
    return Column(
      children: [
        // Futuristic progress header with tech styling
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                    ? [
                        Colors.black.withValues(alpha: 0.8),
                        Color(0xFF0A0A0A).withValues(alpha: 0.9),
                        Colors.black.withValues(alpha: 0.8),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.9),
                        Color(0xFFF0F0F0).withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.9),
                      ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.cyan.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tech icon
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyan, Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.memory,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Progress text with tech styling
                  Text(
                    'SYSTEM INITIALIZATION: ${_currentZoneIndex + 1}/${_zones.length}',
                    style: TextStyle(
                      color: isDark 
                        ? Colors.cyan.withValues(alpha: 0.95)
                        : Colors.cyan.withValues(alpha: 1.0),
                      fontSize: isMobile ? 12 : isTablet ? 13 : 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: isMobile ? 1.2 : isTablet ? 1.5 : 2,
                      fontFamily: 'monospace',
                      shadows: [
                        Shadow(
                          color: Colors.cyan.withValues(alpha: 0.5 + _glowIntensity.value * 0.4),
                          blurRadius: 12 + _glowIntensity.value * 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        SizedBox(height: isMobile ? 24 : isTablet ? 28 : 32),
        
        // Ultra modern tech progress bar
        SizedBox(
          width: isMobile ? 340 : isTablet ? 400 : 460,
          height: isMobile ? 24 : isTablet ? 28 : 32,
          child: Stack(
            children: [
              // Outer tech glow with multiple layers
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isMobile ? 20 : isTablet ? 24 : 28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withValues(alpha: 0.4),
                      blurRadius: 25,
                      spreadRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
              
              // Main tech container with metallic look
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                      ? [
                          Color(0xFF1A1A1A),
                          Color(0xFF0D0D0D),
                          Color(0xFF1A1A1A),
                        ]
                      : [
                          Color(0xFFF8F9FA),
                          Color(0xFFE9ECEF),
                          Color(0xFFF8F9FA),
                        ],
                  ),
                  borderRadius: BorderRadius.circular(isMobile ? 20 : isTablet ? 24 : 28),
                  border: Border.all(
                    color: Colors.cyan.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    // Tech circuit pattern background
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(isMobile ? 20 : isTablet ? 24 : 28),
                        child: CustomPaint(
                          painter: TechCircuitPainter(
                            isDark: isDark,
                            animation: _glowController,
                          ),
                        ),
                      ),
                    ),
                    
                                                              // Advanced tech progress fill with precise step filling
                     Builder(
                       builder: (context) {
                         final progressBarWidth = isMobile ? 340.0 : isTablet ? 400.0 : 460.0;
                         return AnimatedContainer(
                           duration: const Duration(milliseconds: 1500),
                           curve: Curves.easeOutCubic,
                           width: progressBarWidth * ((_currentZoneIndex + 1) / _zones.length),
                           height: double.infinity,
                           child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(isMobile ? 20 : isTablet ? 24 : 28),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.cyan,
                                  Colors.cyan.withValues(alpha: 0.95),
                                  Colors.blue.withValues(alpha: 0.9),
                                  Colors.purple.withValues(alpha: 0.85),
                                  Colors.indigo.withValues(alpha: 0.8),
                                  Colors.cyan.withValues(alpha: 0.9),
                            ],
                            stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Advanced tech shine effect
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(isMobile ? 20 : isTablet ? 24 : 28),
                                child: CustomPaint(
                                  painter: AdvancedTechShinePainter(
                                    animation: _glowController,
                                  ),
                                ),
                              ),
                            ),
                            
                            // Tech circuit overlay
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(isMobile ? 20 : isTablet ? 24 : 28),
                                child: CustomPaint(
                                  painter: TechCircuitOverlayPainter(
                                    animation: _glowController,
                                  ),
                                ),
                              ),
                            ),
                            
                            // Enhanced floating tech particles
                            ...List.generate(16, (index) {
                              return Positioned(
                                left: (index * 25.0) % (isMobile ? 340.0 : isTablet ? 400.0 : 460.0),
                                top: 4 + (index % 4) * 5,
                                child: AnimatedBuilder(
                                  animation: _glowController,
                                  builder: (context, child) {
                                    final particleType = index % 4;
                                    final size = particleType == 0 ? 4.0 : particleType == 1 ? 3.0 : particleType == 2 ? 5.0 : 2.0;
                                    final color = particleType == 0 
                                        ? Colors.cyan 
                                        : particleType == 1 
                                            ? Colors.blue 
                                            : particleType == 2 
                                                ? Colors.purple 
                                                : Colors.white;
                                    
                                    return Transform.translate(
                                      offset: Offset(
                                        math.sin(_glowController.value * 2 * math.pi + index) * 5,
                                        math.cos(_glowController.value * 2 * math.pi + index) * 4,
                                      ),
                                      child: Container(
                                        width: size,
                                        height: size,
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.9),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: color.withValues(alpha: 0.7),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                            
                            // Tech data stream effect with multiple streams
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: SizedBox(
                                width: 6,
                                child: CustomPaint(
                                  painter: AdvancedDataStreamPainter(
                                    animation: _glowController,
                                  ),
                                ),
                              ),
                            ),
                            
                            // Tech energy pulses
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: SizedBox(
                                width: 8,
                                child: CustomPaint(
                                  painter: TechEnergyPulsePainter(
                                    animation: _glowController,
                                  ),
                                ),
                              ),
                            ),
                            
                            // Tech scanning lines
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(isMobile ? 20 : isTablet ? 24 : 28),
                                child: CustomPaint(
                                  painter: TechScanningLinesPainter(
                                    animation: _glowController,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                    
                                                             // Living tech organism progress bar
                     Positioned.fill(
                       child: CustomPaint(
                         painter: LivingTechOrganismPainter(
                           currentProgress: _getExactProgress(),
                           animation: _glowController,
                         ),
                       ),
                     ),
                    

                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticleBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _particleRotation.value,
          child: Stack(
            children: List.generate(20, (index) {
              final random = math.Random(index);
              final size = 2 + random.nextDouble() * 4;
              final opacity = 0.1 + random.nextDouble() * 0.3;
              
              return Positioned(
                left: random.nextDouble() * MediaQuery.of(context).size.width,
                top: random.nextDouble() * MediaQuery.of(context).size.height,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: isDark 
                      ? Colors.cyan.withValues(alpha: opacity)
                      : Colors.cyan.withValues(alpha: opacity * 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildCompletionOverlay(bool isDark, bool isMobile, bool isTablet, bool isDesktop) {
    return AnimatedBuilder(
      animation: _completionController,
      builder: (context, child) {
        return Container(
          color: isDark ? Colors.black : Colors.white.withValues(alpha: 0.98),
          child: Center(
            child: Transform.scale(
              scale: _completionScale.value,
              child: Opacity(
                opacity: _completionOpacity.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Premium tech icon with smooth fade-in
                    AnimatedBuilder(
                      animation: _completionController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _completionOpacity.value,
                          child: Container(
                            width: isMobile ? 100 : isTablet ? 130 : 150,
                            height: isMobile ? 100 : isTablet ? 130 : 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.cyan.withValues(alpha: 0.4 * _completionOpacity.value),
                                  Colors.cyan.withValues(alpha: 0.1 * _completionOpacity.value),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.power_settings_new,
                              size: isMobile ? 50 : isTablet ? 65 : 80,
                              color: Colors.cyan,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: isMobile ? 40 : isTablet ? 50 : 60),
                    
                    // Main title - premium tech style
                    AnimatedBuilder(
                      animation: _textRevealController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _textSlide.value),
                          child: Column(
                            children: [
                              Text(
                                'SYSTEM',
                                style: TextStyle(
                                  fontSize: isMobile ? 28 : isTablet ? 32 : 36,
                                  fontWeight: FontWeight.w300,
                                  color: isDark 
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : Colors.black.withValues(alpha: 0.6),
                                  letterSpacing: isMobile ? 6 : isTablet ? 8 : 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              SizedBox(height: isMobile ? 8 : isTablet ? 10 : 12),
                              
                              Text(
                                'ONLINE',
                                style: TextStyle(
                                  fontSize: isMobile ? 48 : isTablet ? 56 : 64,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.cyan,
                                  letterSpacing: isMobile ? 8 : isTablet ? 12 : 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              SizedBox(height: isMobile ? 30 : isTablet ? 35 : 40),
                              
                              // Status line with smooth scale
                              AnimatedBuilder(
                                animation: _textRevealController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scaleX: _textRevealController.value,
                                    child: Container(
                                      width: isMobile ? 150 : isTablet ? 180 : 200,
                                      height: isMobile ? 1.5 : isTablet ? 1.8 : 2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.cyan,
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              SizedBox(height: isMobile ? 30 : isTablet ? 35 : 40),
                              
                              // Tech specs
                              Text(
                                'TECHTIPS v1.0',
                                style: TextStyle(
                                  fontSize: isMobile ? 16 : isTablet ? 18 : 20,
                                  color: isDark 
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : Colors.black.withValues(alpha: 0.4),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: isMobile ? 2 : isTablet ? 2.5 : 3,
                                ),
                              ),
                              
                              SizedBox(height: isMobile ? 8 : isTablet ? 10 : 12),
                              
                              Text(
                                'All modules loaded',
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : isTablet ? 16 : 18,
                                  color: isDark 
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : Colors.black.withValues(alpha: 0.3),
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: isMobile ? 1 : isTablet ? 1.5 : 2,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }










  
  /// Returns exact 1/3 step progress for perfect filling
  double _getExactProgress() {
    // Ensure we have exactly 3 zones
    if (_zones.length != 3) return 0.0;
    
    // Return exact 1/3, 2/3, or 3/3 based on current zone
    switch (_currentZoneIndex) {
      case 0:
        return 1.0 / 3.0; // Exactly 33.33%
      case 1:
        return 2.0 / 3.0; // Exactly 66.67%
      case 2:
        return 3.0 / 3.0; // Exactly 100%
      default:
        return 0.0;
    }
  }
}

class CommandZone {
  final String name;
  final String displayName;
  final String description;
  final String command;
  final List<String> shortcuts;
  final Color color;
  final IconData icon;

  CommandZone({
    required this.name,
    required this.displayName,
    required this.description,
    required this.command,
    required this.shortcuts,
    required this.color,
    required this.icon,
  });
}

class Firework {
  final double x;
  final double y;
  final double targetX;
  final double targetY;
  final Color color;
  final double delay;

  Firework({
    required this.x,
    required this.y,
    required this.targetX,
    required this.targetY,
    required this.color,
    required this.delay,
  });
}

class MatrixRain {
  final double x;
  final double y;
  final double speed;
  final double opacity;

  MatrixRain({
    required this.x,
    required this.y,
    required this.speed,
    required this.opacity,
  });
}

class OrbitingParticle {
  final double radius;
  final double speed;
  final double offset;
  final Color color;
  final double size;

  OrbitingParticle({
    required this.radius,
    required this.speed,
    required this.offset,
    required this.color,
    required this.size,
  });
}

class HolographicGridPainter extends CustomPainter {
  final double opacity;
  final double animation;

  HolographicGridPainter({required this.opacity, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withValues(alpha: opacity * 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final spacing = 50.0;
    final offset = animation * spacing;

    // Vertical lines
    for (double x = offset; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = offset; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter for tech circuit pattern background
class TechCircuitPainter extends CustomPainter {
  final bool isDark;
  final Animation<double> animation;

  TechCircuitPainter({
    required this.isDark,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark 
        ? Colors.cyan.withValues(alpha: 0.08)
        : Colors.cyan.withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw tech circuit pattern
    final spacing = 30.0;
    final offset = animation.value * spacing;

    // Vertical circuit lines
    for (double x = offset; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      
      // Horizontal connections
      for (double y = 0; y < size.height; y += spacing) {
        if (x < size.width - spacing) {
          canvas.drawLine(Offset(x, y), Offset(x + spacing, y), paint);
        }
      }
    }

    // Diagonal tech connections
    for (int i = 0; i < 8; i++) {
      final startX = (i * 50.0 + offset) % size.width;
      final startY = (i * 30.0) % size.height;
      final endX = (startX + 40) % size.width;
      final endY = (startY + 40) % size.height;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(TechCircuitPainter oldDelegate) => true;
}

/// Custom painter for tech shine effect on progress bar
class TechShinePainter extends CustomPainter {
  final Animation<double> animation;

  TechShinePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.4),
          Colors.cyan.withValues(alpha: 0.6),
          Colors.blue.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0.4),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.15, 0.4, 0.6, 0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Tech shine sweep with multiple passes
    final shineOffset1 = animation.value * size.width * 2 - size.width;
    final shineOffset2 = (animation.value + 0.5) * size.width * 2 - size.width;
    
    canvas.drawRect(
      Rect.fromLTWH(shineOffset1, 0, size.width * 0.25, size.height),
      paint,
    );
    
    canvas.drawRect(
      Rect.fromLTWH(shineOffset2, 0, size.width * 0.2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(TechShinePainter oldDelegate) => true;
}

/// Advanced custom painter for tech shine effect
class AdvancedTechShinePainter extends CustomPainter {
  final Animation<double> animation;

  AdvancedTechShinePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.5),
          Colors.cyan.withValues(alpha: 0.7),
          Colors.blue.withValues(alpha: 0.6),
          Colors.purple.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0.4),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Multiple tech shine sweeps
    final shineOffset1 = animation.value * size.width * 2 - size.width;
    final shineOffset2 = (animation.value + 0.3) * size.width * 2 - size.width;
    final shineOffset3 = (animation.value + 0.7) * size.width * 2 - size.width;
    
    canvas.drawRect(
      Rect.fromLTWH(shineOffset1, 0, size.width * 0.2, size.height),
      paint,
    );
    
    canvas.drawRect(
      Rect.fromLTWH(shineOffset2, 0, size.width * 0.15, size.height),
      paint,
    );
    
    canvas.drawRect(
      Rect.fromLTWH(shineOffset3, 0, size.width * 0.18, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(AdvancedTechShinePainter oldDelegate) => true;
}

/// Custom painter for tech circuit overlay
class TechCircuitOverlayPainter extends CustomPainter {
  final Animation<double> animation;

  TechCircuitOverlayPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw advanced circuit pattern
    final spacing = 25.0;
    final offset = animation.value * spacing;

    // Vertical circuit lines with connections
    for (double x = offset; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      
      // Horizontal connections with varying lengths
      for (double y = 0; y < size.height; y += spacing) {
        if (x < size.width - spacing) {
          final connectionLength = spacing * (0.5 + (y / size.height) * 0.5);
          canvas.drawLine(Offset(x, y), Offset(x + connectionLength, y), paint);
        }
      }
    }

    // Diagonal tech connections with varying angles
    for (int i = 0; i < 12; i++) {
      final startX = (i * 40.0 + offset) % size.width;
      final startY = (i * 25.0) % size.height;
      final endX = (startX + 35 + (i % 3) * 10) % size.width;
      final endY = (startY + 35 + (i % 2) * 8) % size.height;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }

    // Tech nodes at intersections
    for (double x = offset; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(TechCircuitOverlayPainter oldDelegate) => true;
}

/// Advanced custom painter for data stream effect
class AdvancedDataStreamPainter extends CustomPainter {
  final Animation<double> animation;

  AdvancedDataStreamPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    // Multiple data streams with different colors
    final colors = [Colors.cyan, Colors.blue, Colors.purple, Colors.indigo];
    
    for (int i = 0; i < 8; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: 0.6 + (i % 3) * 0.1)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      final y = (i * 6.0 + animation.value * 25) % size.height;
      final opacity = 0.4 + (0.6 * (1 - (i / 8.0)));
      
      paint.color = paint.color.withValues(alpha: opacity);
      
      // Draw data stream with varying lengths
      final streamLength = size.width * (0.7 + (i % 3) * 0.1);
      canvas.drawLine(
        Offset(0, y),
        Offset(streamLength, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AdvancedDataStreamPainter oldDelegate) => true;
}

/// Custom painter for tech energy pulses
class TechEnergyPulsePainter extends CustomPainter {
  final Animation<double> animation;

  TechEnergyPulsePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw energy pulses from left side
    for (int i = 0; i < 5; i++) {
      final y = (i * 12.0 + animation.value * 30) % size.height;
      final opacity = 0.3 + (0.7 * (1 - (i / 5.0)));
      
      paint.color = Colors.cyan.withValues(alpha: opacity);
      
      // Draw pulse wave
      final pulseWidth = 8.0 + (i % 2) * 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(pulseWidth, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(TechEnergyPulsePainter oldDelegate) => true;
}

/// Custom painter for tech scanning lines
class TechScanningLinesPainter extends CustomPainter {
  final Animation<double> animation;

  TechScanningLinesPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw scanning lines that move across the progress bar
    for (int i = 0; i < 6; i++) {
      final x = (i * 60.0 + animation.value * 120) % size.width;
      final opacity = 0.1 + (0.2 * (1 - (i / 6.0)));
      
      paint.color = Colors.cyan.withValues(alpha: opacity);
      
      // Draw scanning line
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(TechScanningLinesPainter oldDelegate) => true;
}

/// Custom painter for data stream effect (keeping for compatibility)
class DataStreamPainter extends CustomPainter {
  final Animation<double> animation;

  DataStreamPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw animated data stream
    for (int i = 0; i < 6; i++) {
      final y = (i * 8.0 + animation.value * 20) % size.height;
      final opacity = 0.3 + (0.7 * (1 - (i / 6.0)));
      
      paint.color = Colors.cyan.withValues(alpha: opacity);
      
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DataStreamPainter oldDelegate) => true;
}

/// Custom painter for electrical circuit pattern - no circles, only straight lines
class ElectricalCircuitPainter extends CustomPainter {
  final bool isCompleted;
  final bool isCurrent;
  final Animation<double> animation;

  ElectricalCircuitPainter({
    required this.isCompleted,
    required this.isCurrent,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    if (isCompleted) {
      // Completed state - active cyan electrical circuits
      paint.color = Colors.cyan.withValues(alpha: 0.8);
      
      // Main electrical grid - horizontal and vertical lines
      canvas.drawLine(
        Offset(center.dx - 18, center.dy - 18),
        Offset(center.dx + 18, center.dy - 18),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx - 18, center.dy + 18),
        Offset(center.dx + 18, center.dy + 18),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx - 18, center.dy - 18),
        Offset(center.dx - 18, center.dy + 18),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx + 18, center.dy - 18),
        Offset(center.dx + 18, center.dy + 18),
        paint,
      );
      
      // Inner electrical connections - cross pattern
      paint.color = Colors.blue.withValues(alpha: 0.6);
      canvas.drawLine(
        Offset(center.dx - 12, center.dy - 12),
        Offset(center.dx + 12, center.dy + 12),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx - 12, center.dy + 12),
        Offset(center.dx + 12, center.dy - 12),
        paint,
      );
      
      // Electrical connection points - small rectangles
      paint.color = Colors.purple.withValues(alpha: 0.7);
      paint.style = PaintingStyle.fill;
      
      // Corner connection points
      final connectionSize = 3.0;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(center.dx - 18, center.dy - 18),
          width: connectionSize,
          height: connectionSize,
        ),
        paint,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(center.dx + 18, center.dy - 18),
          width: connectionSize,
          height: connectionSize,
        ),
        paint,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(center.dx - 18, center.dy + 18),
          width: connectionSize,
          height: connectionSize,
        ),
        paint,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(center.dx + 18, center.dy + 18),
          width: connectionSize,
          height: connectionSize,
        ),
        paint,
      );
      
    } else if (isCurrent) {
      // Current state - pulsing cyan electrical circuits
      paint.color = Colors.cyan.withValues(alpha: 0.6 + animation.value * 0.4);
      
      // Pulsing electrical grid
      final pulseSize = 16 + animation.value * 4;
      canvas.drawLine(
        Offset(center.dx - pulseSize, center.dy - pulseSize),
        Offset(center.dx + pulseSize, center.dy - pulseSize),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx - pulseSize, center.dy + pulseSize),
        Offset(center.dx + pulseSize, center.dy + pulseSize),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx - pulseSize, center.dy - pulseSize),
        Offset(center.dx - pulseSize, center.dy + pulseSize),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx + pulseSize, center.dy - pulseSize),
        Offset(center.dx + pulseSize, center.dy + pulseSize),
        paint,
      );
      
      // Pulsing cross connection
      paint.color = Colors.blue.withValues(alpha: 0.6);
      canvas.drawLine(
        Offset(center.dx - 8, center.dy - 8),
        Offset(center.dx + 8, center.dy + 8),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx - 8, center.dy + 8),
        Offset(center.dx + 8, center.dy - 8),
        paint,
      );
      
    } else {
      // Pending state - subtle grey electrical circuits
      paint.color = Colors.grey.withValues(alpha: 0.4);
      
      // Basic electrical grid
      canvas.drawLine(
        Offset(center.dx - 16, center.dy - 16),
        Offset(center.dx + 16, center.dy - 16),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx - 16, center.dy + 16),
        Offset(center.dx + 16, center.dy + 16),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx - 16, center.dy - 16),
        Offset(center.dx - 16, center.dy + 16),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx + 16, center.dy - 16),
        Offset(center.dx + 16, center.dy + 16),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ElectricalCircuitPainter oldDelegate) => true;
}

/// Custom painter for living tech organism progress bar
class LivingTechOrganismPainter extends CustomPainter {
  final double currentProgress;
  final Animation<double> animation;

  LivingTechOrganismPainter({
    required this.currentProgress,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw living tech organism interface (NO GRIDS!)
    final barHeight = size.height;
    final barWidth = size.width;
    
    // Main horizontal circuit lines (top and bottom)
    paint.color = Colors.cyan.withValues(alpha: 0.8);
    canvas.drawLine(
      Offset(0, 2),
      Offset(barWidth, 2),
      paint,
    );
    canvas.drawLine(
      Offset(0, barHeight - 2),
      Offset(barWidth, barHeight - 2),
      paint,
    );
    
    // Flowing energy streams (NO GRIDS!)
    paint.strokeWidth = 2.0;
    
    // Primary energy stream
    paint.color = Colors.cyan.withValues(alpha: 0.8);
    final primaryStream = Path();
    primaryStream.moveTo(0, barHeight / 2);
    
    for (int i = 0; i <= 20; i++) {
      final x = (i * barWidth / 20);
      final y = barHeight / 2 + math.sin((i + animation.value * 5) * 0.3) * 8;
      primaryStream.lineTo(x, y);
    }
    canvas.drawPath(primaryStream, paint);
    
    // Secondary energy streams
    paint.color = Colors.blue.withValues(alpha: 0.6);
    for (int j = 0; j < 3; j++) {
      final streamOffset = j * (barHeight / 4);
      final streamPath = Path();
      streamPath.moveTo(0, streamOffset);
      
      for (int i = 0; i <= 15; i++) {
        final x = (i * barWidth / 15);
        final y = streamOffset + math.sin((i + animation.value * 3 + j * 2) * 0.4) * 6;
        streamPath.lineTo(x, y);
      }
      canvas.drawPath(streamPath, paint);
    }
    
    // Floating geometric shapes
    paint.style = PaintingStyle.fill;
    
    // Floating triangles
    for (int i = 0; i < 8; i++) {
      final x = (i * 45.0 + animation.value * 30) % barWidth;
      final y = (i * 20.0 + animation.value * 20) % barHeight;
      final size = 4.0 + (i % 2) * 2.0;
      final rotation = animation.value * 360 + (i * 45);
      
      paint.color = Colors.purple.withValues(alpha: 0.7);
      _drawRotatedTriangle(canvas, Offset(x, y), size, rotation, paint);
    }
    
    // Floating diamonds
    for (int i = 0; i < 6; i++) {
      final x = (i * 60.0 + animation.value * 40) % barWidth;
      final y = (i * 25.0 + animation.value * 15) % barHeight;
      final size = 3.0 + (i % 2) * 1.5;
      final rotation = animation.value * 180 + (i * 60);
      
      paint.color = Colors.cyan.withValues(alpha: 0.8);
      _drawRotatedDiamond(canvas, Offset(x, y), size, rotation, paint);
    }
    
    // Dynamic particle clusters
    for (int i = 0; i < 25; i++) {
      final x = (i * 18.0 + animation.value * 25) % barWidth;
      final y = (i * 12.0 + animation.value * 18) % barHeight;
      final size = 1.0 + (i % 4) * 0.5;
      final opacity = 0.4 + (0.6 * (1 - (i / 25.0)));
      
      paint.color = Colors.cyan.withValues(alpha: opacity);
      canvas.drawCircle(
        Offset(x, y),
        size,
        paint,
      );
    }
    
    // Progress-based organism activation
    final activeWidth = barWidth * currentProgress;
    if (activeWidth > 0) {
      // Active circuit area with enhanced glow
      paint.color = Colors.cyan.withValues(alpha: 0.9);
      paint.strokeWidth = 2.0;
      
      // Enhanced main lines in active area
      canvas.drawLine(
        Offset(0, 2),
        Offset(activeWidth, 2),
        paint,
      );
      canvas.drawLine(
        Offset(0, barHeight - 2),
        Offset(activeWidth, barHeight - 2),
        paint,
      );
      
      // Enhanced vertical connections in active area
      paint.color = Colors.blue.withValues(alpha: 0.8);
      for (int i = 0; i <= activeWidth / 20; i++) {
        final x = i * 20.0;
        if (x <= activeWidth) {
          canvas.drawLine(
            Offset(x, 2),
            Offset(x, barHeight - 2),
            paint,
          );
        }
      }
      
      // Enhanced horizontal connections in active area
      paint.color = Colors.purple.withValues(alpha: 0.7);
      for (int i = 1; i < barHeight / 8; i++) {
        final y = i * 8.0;
        if (y < barHeight) {
          canvas.drawLine(
            Offset(0, y),
            Offset(activeWidth, y),
            paint,
          );
        }
      }
    }
    
    // Animated electrical pulse effect
    paint.color = Colors.cyan.withValues(alpha: 0.4 + (0.3 * animation.value));
    paint.strokeWidth = 1.0;
    
    // Pulsing horizontal lines that move across the bar
    final pulseOffset = (animation.value * 40) % barWidth;
    canvas.drawLine(
      Offset(pulseOffset, 4),
      Offset(pulseOffset + 20, 4),
      paint,
    );
    canvas.drawLine(
      Offset(pulseOffset, barHeight - 4),
      Offset(pulseOffset + 20, barHeight - 4),
      paint,
    );
    
    // Circuit connection points (small rectangles) at intersections
    paint.style = PaintingStyle.fill;
    paint.color = Colors.cyan.withValues(alpha: 0.8);
    
    for (int i = 0; i <= barWidth / 20; i++) {
      final x = i * 20.0;
      if (x <= barWidth) {
        // Top connection point
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, 2),
            width: 3,
            height: 3,
          ),
          paint,
        );
        // Bottom connection point
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, barHeight - 2),
            width: 3,
            height: 3,
          ),
          paint,
        );
      }
    }
    
    // Horizontal connection points
    for (int i = 1; i < barHeight / 8; i++) {
      final y = i * 8.0;
      if (y < barHeight) {
        // Left connection point
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(0, y),
            width: 3,
            height: 3,
          ),
          paint,
        );
        // Right connection point (only in active area)
        if (currentProgress > 0) {
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(activeWidth, y),
              width: 3,
              height: 3,
            ),
            paint,
          );
        }
      }
    }
  }
  
  void _drawRotatedTriangle(Canvas canvas, Offset center, double size, double rotation, Paint paint) {
    final path = Path();
    final angle = rotation * (3.14159 / 180);
    
    for (int i = 0; i < 3; i++) {
      final pointAngle = angle + (i * 120 * (3.14159 / 180));
      final x = center.dx + size * math.cos(pointAngle);
      final y = center.dy + size * math.sin(pointAngle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  
  void _drawRotatedDiamond(Canvas canvas, Offset center, double size, double rotation, Paint paint) {
    final path = Path();
    final angle = rotation * (3.14159 / 180);
    
    for (int i = 0; i < 4; i++) {
      final pointAngle = angle + (i * 90 * (3.14159 / 180));
      final x = center.dx + size * math.cos(pointAngle);
      final y = center.dy + size * math.sin(pointAngle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LivingTechOrganismPainter oldDelegate) => true;
}
