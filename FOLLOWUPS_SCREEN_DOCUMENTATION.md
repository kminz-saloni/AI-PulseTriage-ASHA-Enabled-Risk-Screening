# Follow-ups Screen Documentation

## Overview
The **Follow-ups Screen** is a critical component of the AASHA-TRIAGE app designed to help ASHA workers track and manage patient follow-up visits, ensuring no case is missed.

## Location in Project
- **File**: `lib/screens/followups_screen.dart`
- **Integration**: Integrated into `MainScreen` as a bottom navigation tab (Tab index 2)

## Navigation
### Access Points:
1. **Bottom Navigation Bar**: Tap the "Follow-ups" tab (calendar icon)
2. **Quick Action Card**: Tap "Follow-Ups" card from Home screen
3. **Direct Route**: Can be accessed programmatically via `Navigator.push()` or by setting `_currentIndex = 2` in MainScreen

## Features

### 1. Top App Bar
- **Title**: "Follow-ups" (English) / "फॉलो-अप्स" (Hindi)
- **Language Toggle**: Switch between English and Hindi
- **Home Button**: Navigate back to Home screen
- Consistent with app-wide CommonAppBar styling (teal/green theme)

### 2. Filter Section
Four filter chips to categorize follow-ups:
- **Due Today** (आज देय): Shows follow-ups scheduled for today
- **Overdue** (विलंबित): Shows follow-ups past their scheduled date
- **Upcoming** (आगामी): Shows follow-ups scheduled in the future
- **High Risk** (उच्च जोखिम): Shows only high-risk patient follow-ups

**Default Filter**: "Due Today"

### 3. Follow-up Cards
Each card displays comprehensive patient information:

#### Card Header:
- Risk indicator dot (color-coded: Red/Orange/Green)
- Patient name
- Status badge (Due Today/Overdue/Upcoming)

#### Card Details:
- **Patient Category Icon & Label**:
  - Pregnant (प्रेग्नेंट) - 👩‍🍼 icon
  - Child (बच्चा) - 👶 icon
  - Elderly (वृद्ध) - 👴 icon

- **Follow-up Reason**:
  Examples: "Postnatal check", "Fever review", "Immunization follow-up", "Blood pressure monitoring"

- **Scheduled Date**:
  - Smart formatting: "Today", "Yesterday", "Tomorrow", "2 days overdue", "In 3 days"
  - Overdue dates highlighted in RED for urgency

#### Card Actions:
1. **Mark Completed Button** (green outline)
   - Shows confirmation dialog
   - Removes follow-up from list when confirmed
   - Displays success notification

2. **View Details Button** (teal, primary)
   - Opens detailed modal with full patient information
   - Shows all follow-up details
   - Currently shows placeholder note (patient profile integration pending)

### 4. Sorting Logic
Follow-ups are automatically sorted by priority:
1. **Overdue** cases (highest priority - appear first)
2. **Due Today** cases
3. **Upcoming** cases (lowest priority - appear last)

Within each category, sorted by scheduled date (oldest first).

### 5. Empty State
When no follow-ups match the selected filter:
- Displays friendly icon (✓ task completed icon)
- Message: "No follow-ups pending today" / "आज कोई फॉलो-अप लंबित नहीं है"
- Encouraging message: "Great job! All follow-ups are up to date."

### 6. Global Persistent Elements
Both elements are provided by `FloatingActionButtonsWidget`:

1. **SOS Button** (bottom-left, draggable)
   - Red emergency button with alert icon
   - Triggers 5-second countdown emergency alert
   - Shows location sharing confirmation

2. **Voice AI Assistant Button** (bottom-right, draggable)
   - Blue microphone button
   - Voice guidance for ASHA workers
   - Helps decide next action

## Data Model

### FollowUp Class
```dart
class FollowUp {
  final String id;
  final String patientName;
  final PatientCategory category;
  final String followUpReason;
  final DateTime scheduledDate;
  final FollowUpStatus status;
  final RiskLevel riskLevel;
  bool isCompleted;
}
```

### Enums
- `FollowUpStatus`: dueToday, overdue, upcoming
- `PatientCategory`: pregnant, child, elderly
- `RiskLevel`: high, medium, low (imported from models.dart)

## Sample Data
The screen includes 6 sample follow-ups demonstrating various scenarios:
1. Sunita Devi - Pregnant, Postnatal check, Due Today, Medium Risk
2. Ravi Kumar - Child, Immunization, Overdue (2 days), High Risk
3. Laxmi Bai - Elderly, BP monitoring, Overdue (1 day), High Risk
4. Anita Sharma - Pregnant, Antenatal check, Due Today, Low Risk
5. Baby Priya - Child, Fever review, Upcoming (2 days), Medium Risk
6. Ram Singh - Elderly, Diabetes check, Upcoming (3 days), Low Risk

## Color Scheme (Consistent with AppTheme)
- **Primary Color**: Teal (#008B8B)
- **Risk High**: Red (#D32F2F)
- **Risk Medium**: Orange (#F57C00)
- **Risk Low**: Green (#388E3C)
- **Due Today Badge**: Orange
- **Overdue Badge**: Red
- **Upcoming Badge**: Light Blue
- **Success Actions**: Green

## Accessibility Features
1. **Large Cards**: Easy to read and tap
2. **Color-coded Risk Indicators**: Visual dots for quick assessment
3. **High Contrast Text**: Clear differentiation for overdue cases
4. **Bilingual Support**: Full Hindi translation
5. **Voice-readable Content**: Compatible with screen readers
6. **Large Touch Targets**: Buttons sized for easy interaction

## User Workflows

### Workflow 1: Complete a Follow-up
1. User taps "Follow-ups" tab from Home
2. Views list of follow-ups (default filter: Due Today)
3. Identifies patient card
4. Taps "Mark Completed" button
5. Confirms in dialog
6. Follow-up removed from list
7. Success notification shown

### Workflow 2: View Patient Details
1. User opens Follow-ups screen
2. Selects patient card
3. Taps "View Details" button
4. Modal dialog opens showing comprehensive info
5. Reviews patient category, reason, date, risk level
6. Closes dialog to return to list

### Workflow 3: Filter by Status
1. User taps filter chip (e.g., "Overdue")
2. List refreshes to show only overdue follow-ups
3. Sorted with most overdue cases first
4. User can switch filters anytime

### Workflow 4: Emergency Situation
1. User working on Follow-ups screen
2. Encounters emergency
3. Long-presses SOS button (bottom-left)
4. 5-second countdown dialog appears
5. Confirms or system auto-activates
6. Location shared, emergency contact called

## Integration Points

### Current:
- MainScreen bottom navigation (Tab 2)
- Home screen quick action card
- FloatingActionButtonsWidget for SOS/Voice
- CommonAppBar for consistent header
- AppTheme for consistent styling

### Future (To Be Implemented):
- Patient profile integration (via View Details)
- Backend API connection for real follow-up data
- Calendar sync for scheduled follow-ups
- Notification system for upcoming/overdue alerts
- Task completion logging and reporting
- Integration with patient visit history

## Technical Notes

### State Management
- Uses `StatefulWidget` with local state
- `_isEnglish` toggles language
- `_selectedFilter` controls active filter
- `_allFollowUps` stores sample data
- Computed `_filteredFollowUps` getter for filtered/sorted list

### Performance Considerations
- Efficient list filtering using `where()` and `toList()`
- Single-pass sorting algorithm
- Cards built on-demand in ListView.builder
- Minimal rebuilds (only on filter/language change)

### Responsive Design
- Adapts to various screen sizes
- Scrollable content for long lists
- Cards stack vertically with consistent spacing
- Bottom navigation remains fixed

## Testing Checklist

- [ ] Filter chips correctly filter follow-ups
- [ ] Default "Due Today" filter applied on load
- [ ] Overdue follow-ups appear first in list
- [ ] Risk indicator dots show correct colors
- [ ] Status badges display correct text and color
- [ ] Date formatting works for all cases
- [ ] Mark Completed removes follow-up from list
- [ ] View Details modal shows correct information
- [ ] Empty state displays when no results
- [ ] Language toggle switches all text
- [ ] SOS button functions correctly
- [ ] Voice Assistant button shows activation message
- [ ] Bottom navigation highlights Follow-ups tab
- [ ] Home button navigates back to Home
- [ ] Quick action card on Home navigates to Follow-ups tab

## Known Limitations

1. **Sample Data Only**: Currently uses hardcoded follow-ups (no backend integration)
2. **Patient Profile**: View Details shows placeholder note (full profile pending)
3. **No Persistence**: Completed follow-ups don't persist across app restarts
4. **No Notifications**: No system notifications for overdue follow-ups yet
5. **No Calendar Integration**: Doesn't sync with device calendar

## Future Enhancements

1. **Backend Integration**:
   - Fetch real follow-up data from API
   - Persist completion status to database
   - Real-time sync across devices

2. **Advanced Filtering**:
   - Date range picker
   - Village/location filter
   - Search by patient name
   - Multiple filter combinations

3. **Notifications**:
   - Push notifications for due follow-ups
   - SMS reminders to ASHA workers
   - Daily summary of pending follow-ups

4. **Analytics**:
   - Follow-up completion rate dashboard
   - Overdue trends and patterns
   - Performance metrics for ASHA workers

5. **Patient Profile Integration**:
   - Full patient history in View Details
   - Direct navigation to patient profile
   - One-tap to start new visit from follow-up

6. **Offline Support**:
   - Cache follow-ups for offline access
   - Queue completion updates for sync
   - Offline-first architecture

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  # No additional packages required beyond core Flutter
```

## Conclusion

The Follow-ups Screen is a production-ready, user-friendly interface that helps ASHA workers efficiently manage patient follow-ups. It follows the app's design system, provides excellent accessibility, and is ready for backend integration.

**Status**: ✅ Fully Functional
**Integration**: ✅ Complete
**Testing**: ⚠️ Manual Testing Recommended
**Backend**: ❌ Not Yet Connected

---

**Last Updated**: January 2026  
**Version**: 1.0.0  
**Author**: GitHub Copilot  
**Project**: AASHA-TRIAGE (AI-PulseTriage-ASHA-Enabled-Risk-Screening)
