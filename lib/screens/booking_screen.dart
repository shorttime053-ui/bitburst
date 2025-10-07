import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../models/turf.dart';
import '../widgets/custom_button.dart';

class BookingScreen extends StatefulWidget {
  final Turf turf;

  const BookingScreen({
    super.key,
    required this.turf,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  TimeSlot? _selectedSlot;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book ${widget.turf.name}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppConstants.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          isMobile ? AppConstants.mediumPadding : AppConstants.largePadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Turf Info Card
            _buildTurfInfoCard(isMobile),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Date Selection
            _buildDateSelection(isMobile),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Time Slot Selection
            _buildTimeSlotSelection(isMobile),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Booking Summary
            if (_selectedDate != null && _selectedSlot != null)
              _buildBookingSummary(isMobile),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Book Now Button
            CustomButton(
              text: 'Book Now',
              onPressed: _selectedDate != null && _selectedSlot != null
                  ? _confirmBooking
                  : null,
              width: double.infinity,
              height: 56,
              backgroundColor: AppConstants.primaryColor,
              textColor: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurfInfoCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.turf.name,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppConstants.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.turf.location,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.turf.rating} (${widget.turf.reviewCount} reviews)',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.mediumPadding),
          
          Text(
            '₹${widget.turf.pricePerHour.toStringAsFixed(0)} per hour',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.mediumPadding),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.mediumPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: InkWell(
            onTap: _selectDate,
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppConstants.textSecondary,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Choose a date',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: _selectedDate != null
                        ? AppConstants.textPrimary
                        : AppConstants.textHint,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppConstants.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time Slot',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.mediumPadding),
        
        if (_selectedDate == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.largePadding),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            ),
            child: Text(
              'Please select a date first',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppConstants.textHint,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 3 : 4,
              crossAxisSpacing: AppConstants.smallPadding,
              mainAxisSpacing: AppConstants.smallPadding,
              childAspectRatio: 2.5,
            ),
            itemCount: widget.turf.availableSlots.length,
            itemBuilder: (context, index) {
              final slot = widget.turf.availableSlots[index];
              final isSelected = _selectedSlot == slot;
              final isAvailable = slot.isAvailable;
              
              return GestureDetector(
                onTap: isAvailable ? () {
                  setState(() {
                    _selectedSlot = slot;
                  });
                } : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.smallPadding,
                    vertical: AppConstants.smallPadding,
                  ),
                  decoration: BoxDecoration(
                    color: !isAvailable
                        ? Colors.grey[200]
                        : isSelected
                            ? AppConstants.primaryColor
                            : Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                    border: Border.all(
                      color: !isAvailable
                          ? Colors.grey[300]!
                          : isSelected
                              ? AppConstants.primaryColor
                              : Colors.grey[300]!,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${slot.startTime.hour.toString().padLeft(2, '0')}:${slot.startTime.minute.toString().padLeft(2, '0')}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: !isAvailable
                              ? Colors.grey[400]
                              : isSelected
                                  ? Colors.white
                                  : AppConstants.textPrimary,
                        ),
                      ),
                      Text(
                        !isAvailable ? 'Booked' : 'Available',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: !isAvailable
                              ? Colors.grey[400]
                              : isSelected
                                  ? Colors.white
                                  : AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildBookingSummary(bool isMobile) {
    final duration = _selectedSlot!.endTime.difference(_selectedSlot!.startTime);
    final totalPrice = widget.turf.pricePerHour * duration.inHours;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        color: AppConstants.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        border: Border.all(color: AppConstants.accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          
          _buildSummaryRow('Date', '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
          _buildSummaryRow('Time', '${_selectedSlot!.startTime.hour.toString().padLeft(2, '0')}:${_selectedSlot!.startTime.minute.toString().padLeft(2, '0')} - ${_selectedSlot!.endTime.hour.toString().padLeft(2, '0')}:${_selectedSlot!.endTime.minute.toString().padLeft(2, '0')}'),
          _buildSummaryRow('Duration', '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}'),
          _buildSummaryRow('Rate', '₹${widget.turf.pricePerHour.toStringAsFixed(0)}/hour'),
          
          const Divider(),
          
          _buildSummaryRow(
            'Total Amount',
            '₹${totalPrice.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppConstants.textSecondary,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppConstants.textPrimary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _selectedSlot = null; // Reset time slot when date changes
      });
    }
  }

  Future<void> _confirmBooking() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate booking process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Booking Confirmed!',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Your booking has been confirmed. You will receive a confirmation email shortly.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            CustomButton(
              text: 'OK',
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              backgroundColor: AppConstants.primaryColor,
              textColor: Colors.white,
            ),
          ],
        ),
      );
    }
  }
}
