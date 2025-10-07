import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';

class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? retryText;

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          isMobile ? AppConstants.mediumPadding : AppConstants.largePadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: isMobile ? 80 : 100,
              color: AppConstants.errorColor,
            ),
            
            const SizedBox(height: AppConstants.largePadding),
            
            Text(
              'Oops! Something went wrong',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppConstants.mediumPadding),
            
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 14 : 16,
                color: AppConstants.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.largePadding),
              
              CustomButton(
                text: retryText ?? 'Try Again',
                onPressed: onRetry,
                width: isMobile ? double.infinity : 200,
                height: 48,
                backgroundColor: AppConstants.primaryColor,
                textColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          isMobile ? AppConstants.mediumPadding : AppConstants.largePadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.search_off,
              size: isMobile ? 80 : 100,
              color: Colors.grey[400],
            ),
            
            const SizedBox(height: AppConstants.largePadding),
            
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppConstants.mediumPadding),
            
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 14 : 16,
                color: AppConstants.textHint,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (onAction != null) ...[
              const SizedBox(height: AppConstants.largePadding),
              
              CustomButton(
                text: actionText ?? 'Get Started',
                onPressed: onAction,
                width: isMobile ? double.infinity : 200,
                height: 48,
                backgroundColor: AppConstants.primaryColor,
                textColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppConstants.primaryColor,
            strokeWidth: 3,
          ),
          
          if (message != null) ...[
            const SizedBox(height: AppConstants.mediumPadding),
            
            Text(
              message!,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
