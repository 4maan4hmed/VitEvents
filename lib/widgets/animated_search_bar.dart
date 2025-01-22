import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(PointerDownEvent) onTapOutside;
  final String hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Color? overlayColor;
  final Color? shadowColor;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final Widget? leading;
  final List<Widget>? trailing;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  const AnimatedSearchBar({
    super.key,
    required this.controller,
    required this.onTapOutside,
    required this.hintText,
    this.hintStyle,
    this.textStyle,
    this.overlayColor,
    this.shadowColor,
    this.backgroundColor = Colors.blue,
    required this.padding,
    this.leading,
    this.trailing,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isInteracting = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _focusNode.addListener(_handleFocusChange);
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  void _handleFocusChange() {
    setState(() {
      _isInteracting = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => _focusNode.requestFocus(),
                splashColor: widget.backgroundColor?.withOpacity(0.3),
                highlightColor: widget.backgroundColor?.withOpacity(0.2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: _isInteracting
                        ? (widget.backgroundColor ?? Colors.white)
                            .withOpacity(0.15 * _fadeAnimation.value)
                        : Colors.transparent,
                    border: Border.all(
                      color: _isInteracting
                          ? (widget.backgroundColor ?? Colors.white)
                              .withOpacity(0.3 * _fadeAnimation.value)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: _isInteracting
                        ? [
                            BoxShadow(
                              color: (widget.backgroundColor ?? Colors.white)
                                  .withOpacity(0.1 * _fadeAnimation.value),
                              blurRadius: 8 * _fadeAnimation.value,
                              spreadRadius: 1 * _fadeAnimation.value,
                            ),
                          ]
                        : [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SearchBar(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      onTapOutside: widget.onTapOutside,
                      hintText: widget.hintText,
                      hintStyle: WidgetStateProperty.all(widget.hintStyle),
                      textStyle: WidgetStateProperty.all(widget.textStyle),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      shadowColor: WidgetStateProperty.all(Colors.transparent),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      padding:
                          WidgetStatePropertyAll<EdgeInsets>(widget.padding),
                      leading: widget.leading,
                      trailing: widget.trailing,
                      onSubmitted: widget.onSubmitted,
                      onChanged: widget.onChanged,
                      constraints: const BoxConstraints(
                        minHeight: 48,
                        maxHeight: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
