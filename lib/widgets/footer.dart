// footer.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/responsive.dart';

class Footer extends StatefulWidget {
  final double screenWidth;

  Footer (this.screenWidth);

  @override
  State<Footer> createState() => _FooterState();

  static void _launchMap() {
    // Implement map launch functionality
  }

  static void _launchWhatsApp() {
    // Implement WhatsApp launch functionality
  }

  static void _launchInstagram() {
    // Implement Instagram launch functionality
  }

  static void _launchTwitter() {
    // Implement Twitter launch functionality
  }

  static void _launchFacebook() {
    // Implement Facebook launch functionality
  }
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    double fontSize = Responsive.getFontSize(widget.screenWidth, 16);
    double iconSize = widget.screenWidth * 0.075;
    double titleSize = Responsive.getFontSize(widget.screenWidth, 20);
    double shubaFontSize = Responsive.getFontSize(widget.screenWidth, 28);

    return Container(
      color: const Color(0xff191B1C),
      padding: EdgeInsets.symmetric(
        vertical: widget.screenWidth * 0.05,
        horizontal: widget.screenWidth * 0.08,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/shubha.png',
              width: shubaFontSize * 6,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: widget.screenWidth * 0.03),
          Text(
            "address",
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            "#1,HSR Sector 1, Bangalore, Karnataka-560049",
            style: GoogleFonts.openSans(
              color: const Color(0xff606062),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: widget.screenWidth * 0.03),
          GestureDetector(
            onTap: Footer._launchMap,
            child: Text(
              "View in Map",
              style: GoogleFonts.openSans(
                color: const Color(0xff606062),
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: widget.screenWidth * 0.06),
          Text(
            "Contact Us",
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: widget.screenWidth * 0.015),
          Text(
            "+91 1234567890 || www.shubaexample.com",
            style: GoogleFonts.openSans(
              color: const Color(0xff606062),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: widget.screenWidth * 0.07),
          Text(
            "our website",
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: widget.screenWidth * 0.07),
          Text(
            "Report",
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: widget.screenWidth * 0.07),
          Center(
            child: Text(
              "connect with us",
              style: GoogleFonts.openSans(
                color: const Color(0xff606062),
                fontSize: titleSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: widget.screenWidth * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon('assets/whatsapp.png', iconSize, Footer._launchWhatsApp),
              SizedBox(width: 18),
              _buildSocialIcon('assets/insta.png', iconSize, Footer._launchInstagram),
              SizedBox(width: 18),
              _buildSocialIcon('assets/x.png', iconSize, Footer._launchTwitter),
              SizedBox(width: 18),
              _buildSocialIcon('assets/fb.png', iconSize, Footer._launchFacebook),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, double size, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size * 0.2),
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
