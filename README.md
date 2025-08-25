# Clarke Engineering

An iOS application for creating comprehensive engineering inspection reports, specifically designed for anchor testing and structural assessments.

## Overview

Clarke Engineering is a SwiftUI-based iOS app that streamlines the process of creating detailed engineering inspection reports. The app guides users through a structured workflow to collect all necessary information and generates professional PDF reports for anchor testing and structural assessments.

## Features

### Multi-Step Workflow
- **General Information**: Collect basic project details including address, client name, date, inspector, and test type
- **Anchor Details**: Capture specific anchor information including base material, strength, adhesive type, and drill direction
- **Additional Data**: Add supplementary information and notes
- **Report Generation**: Review and generate final PDF reports

### Key Capabilities
- **Professional PDF Generation**: Create high-quality, formatted PDF reports
- **Data Persistence**: Automatically save progress using UserDefaults
- **Form Validation**: Ensure all required fields are completed before report generation
- **Custom Branding**: Integrated Clarke Engineering logo and branding
- **Responsive Design**: Optimized for various iOS device sizes

### User Interface
- Clean, intuitive SwiftUI interface
- Step-by-step navigation with visual progress indicators
- Custom text fields with proper validation
- Haptic feedback for enhanced user experience
- Professional color scheme and typography

## Technical Details

### Architecture
- **Framework**: SwiftUI
- **Language**: Swift
- **Minimum iOS Version**: iOS 14.0+
- **Architecture Pattern**: MVVM with ObservableObject

### Core Components
- `DashboardContentView`: Main app interface with tab navigation
- `PDFManager`: Handles data management and PDF generation
- `UserInfo`: Data model for user and project information
- `WorkExperience`: Model for additional work experience data
- Custom tab views for each workflow step

### PDF Generation
- High-resolution PDF output (2.9x scale factor for print quality)
- U.S. Letter size format (8.5" x 11")
- Professional formatting and layout
- Automatic file saving to Documents directory

## Installation

### Prerequisites
- Xcode 12.0 or later
- iOS 14.0+ deployment target
- macOS 11.0+ (for development)

### Setup
1. Clone the repository
2. Open `ClarkeEngineering.xcodeproj` in Xcode
3. Select your development team in project settings
4. Build and run on your target device or simulator

## Usage

### Getting Started
1. Launch the app
2. Navigate through the four main tabs:
   - **General**: Enter basic project information
   - **Anchor**: Specify anchor and material details
   - **Add**: Include additional data and notes
   - **Done**: Review and generate your report

### Creating a Report
1. Fill in all required fields in the General tab
2. Complete anchor-specific information
3. Add any additional notes or data
4. Review your information in the Done tab
5. Generate and save your PDF report

### Data Management
- All data is automatically saved as you progress
- Information persists between app sessions
- Clear validation ensures complete reports

## Project Structure

```
ClarkeEngineering/
├── ClarkeEngineeringApp.swift      # Main app entry point
├── DashboardContentView.swift      # Primary UI controller
├── PDFManager.swift               # PDF generation and data management
├── UserInfo.swift                 # User data model
├── WorkExperience.swift           # Work experience data model
├── CustomTextField.swift          # Custom text input component
├── Tabs/                          # Tab view components
│   ├── GeneralTabView.swift       # General information form
│   ├── AnchorTabView.swift        # Anchor details form
│   ├── AddTabView.swift           # Additional data form
│   └── DoneTabView.swift          # Report review and generation
├── Assets.xcassets/               # App icons and images
└── Clarke_Logo.jpg               # Company branding
```

## Configuration

### App Settings
- PDF page size: 8.5" x 11" (U.S. Letter)
- Scale factor: 2.9x for high-quality output
- Debug mode available for PDF location tracking

### Customization
- Modify `AppConfig` class for PDF settings
- Update `UserInfo` model for additional fields
- Customize UI components in respective SwiftUI views

## Development

### Adding New Features
1. Extend the `UserInfo` model for new data fields
2. Update corresponding tab views for data entry
3. Modify PDF generation logic in `PDFManager`
4. Test validation and data persistence

### Code Style
- Follow SwiftUI best practices
- Use MVVM architecture pattern
- Implement proper error handling
- Maintain consistent naming conventions

## Support

For technical support or feature requests, please contact the development team.

## License

This project is proprietary software developed for Clarke Engineering.

---

**Version**: 1.0  
**Last Updated**: 2024  
**Developer**: Max Rome
