# Nature Focus App Style Guide

## Overview
This style guide defines the visual language for a productivity app that uses nature metaphors and gamification to create a calming, motivating user experience.

---

## Design Philosophy

### Core Principles
1. **Calm & Focus** - Every element should promote tranquility and concentration
2. **Growth Mindset** - Visual metaphors that represent progress and development
3. **Playful Motivation** - Gamification that encourages without overwhelming
4. **Simplicity First** - Remove cognitive load through clean, intuitive design

---

## Color Palette

### Primary Colors

**Forest Green** (Primary)
- Hex: `#4A9B8E`
- RGB: 74, 155, 142
- Usage: Headers, primary buttons, main UI elements
- Emotion: Calming, natural, growth

**Deep Teal** (Background)
- Hex: `#3D7B72`
- RGB: 61, 123, 114
- Usage: Backgrounds, cards, containers
- Emotion: Depth, focus, serenity

**Light Sage** (Secondary)
- Hex: `#7EC4B6`
- RGB: 126, 196, 182
- Usage: Secondary buttons, highlights, borders
- Emotion: Fresh, light, encouraging

### Accent Colors

**Grass Green**
- Hex: `#A8D969`
- RGB: 168, 217, 105
- Usage: Success states, growth indicators, active elements

**Golden Yellow**
- Hex: `#F4C430`
- RGB: 244, 196, 48
- Usage: Rewards, coins, achievements, positive feedback

**Soil Brown**
- Hex: `#8B6F47`
- RGB: 139, 111, 71
- Usage: Grounding elements, tree trunks, bases

**Soft Cream**
- Hex: `#F5F3E8`
- RGB: 245, 243, 232
- Usage: Content backgrounds, cards, text containers

### Utility Colors

**Pure White**
- Hex: `#FFFFFF`
- Usage: Text on dark backgrounds, highlights

**Charcoal**
- Hex: `#2D3436`
- RGB: 45, 52, 54
- Usage: Primary text, icons

**Medium Gray**
- Hex: `#636E72`
- RGB: 99, 110, 114
- Usage: Secondary text, disabled states

**Coral Red** (Sparingly)
- Hex: `#FF7675`
- RGB: 255, 118, 117
- Usage: Warnings, destructive actions (break focus)

---

## Typography

### Font Families

**Primary Font: SF Pro / Inter / Avenir Next**
- Modern, highly legible sans-serif
- Excellent readability on mobile devices
- Clean, professional appearance

**Display Font: Circular / Poppins (Optional)**
- Friendly, rounded letterforms
- Use for large headlines or special moments only

### Type Scale

**Hero Display**
- Size: 48-60pt
- Weight: Light (300)
- Usage: Large timers, major focal points
- Example: "15:00" countdown timer

**Page Title**
- Size: 28-32pt
- Weight: Semibold (600)
- Usage: Screen headers, section titles
- Example: "Focused Time Distribution"

**Section Header**
- Size: 20-24pt
- Weight: Semibold (600)
- Usage: Card headers, category labels
- Example: "Focus Trend"

**Body Large**
- Size: 17-18pt
- Weight: Regular (400)
- Usage: Primary content, descriptions
- Example: "You have focused for 30 mins today."

**Body**
- Size: 15-16pt
- Weight: Regular (400)
- Usage: Standard text, labels

**Caption**
- Size: 13-14pt
- Weight: Regular (400)
- Usage: Timestamps, metadata, hints
- Example: "Jan 14, 2026 (Today)"

**Small/Fine Print**
- Size: 11-12pt
- Weight: Regular (400)
- Usage: Legal text, minor labels

### Type Treatment

- **Line Height:** 1.4-1.6 for body text, 1.2 for headlines
- **Letter Spacing:** Default for body, slightly tighter (-0.5%) for large displays
- **Text Color on Light:** Charcoal (#2D3436)
- **Text Color on Dark:** White (#FFFFFF) or Soft Cream (#F5F3E8)

---

## Spacing & Layout

### Spacing System (8pt Grid)

- **4pt** - Minimum spacing, tight groupings
- **8pt** - Default spacing between related elements
- **16pt** - Spacing between sections within a card
- **24pt** - Spacing between unrelated groups
- **32pt** - Spacing between major sections
- **48pt** - Large breathing room, screen margins

### Safe Areas & Margins

- **Screen Edges:** 20-24pt minimum margin
- **Card Padding:** 16-20pt internal padding
- **Button Padding:** 12pt vertical, 24pt horizontal (minimum)

### Layout Grid

- **Mobile:** 4 columns with 16pt gutters
- **Tablet:** 8 columns with 20pt gutters
- **Max Content Width:** 600pt for readability

---

## Components

### Buttons

**Primary Button**
- Background: Forest Green (#4A9B8E)
- Text: White, 16pt, Semibold
- Border Radius: 12pt
- Padding: 14pt vertical, 32pt horizontal
- Shadow: 0 2pt 8pt rgba(0,0,0,0.15)
- Hover: Slightly darker green
- Example: "Plant" button

**Secondary Button**
- Background: Light Sage (#7EC4B6)
- Text: Charcoal, 16pt, Semibold
- Border Radius: 12pt
- Padding: 14pt vertical, 32pt horizontal
- Shadow: 0 1pt 4pt rgba(0,0,0,0.1)

**Ghost Button**
- Background: Transparent
- Border: 2pt solid Forest Green
- Text: Forest Green, 16pt, Semibold
- Border Radius: 12pt
- Padding: 12pt vertical, 28pt horizontal

**Tab Button (Active)**
- Background: White or Soft Cream
- Text: Charcoal, 16pt, Semibold
- Border Radius: 8pt
- Shadow: 0 2pt 6pt rgba(0,0,0,0.1)

**Tab Button (Inactive)**
- Background: Transparent
- Text: Light gray, 16pt, Regular
- No shadow

### Cards

**Standard Card**
- Background: White or Soft Cream (#F5F3E8)
- Border Radius: 16pt
- Padding: 20pt
- Shadow: 0 4pt 16pt rgba(0,0,0,0.08)
- Border: None or 1pt solid rgba(0,0,0,0.05)

**Floating Card**
- Background: White
- Border Radius: 20pt
- Padding: 24pt
- Shadow: 0 8pt 24pt rgba(0,0,0,0.12)
- Use for modals, overlays, important content

### Icons

**Style:** Line icons with rounded ends
- **Weight:** 2pt stroke
- **Size:** 24pt standard, 20pt small, 32pt large
- **Color:** Match text color or use accent colors
- Examples: Timer icon, tree icon, coin icon

**Badge Icons**
- Circular backgrounds with icon inside
- Background: Accent color (yellow, green)
- Icon: White or contrasting color
- Size: 40-48pt diameter

### Charts & Data Visualization

**Bar Charts**
- Bar Color: Forest Green (#4A9B8E) or Grass Green (#A8D969)
- Background: Light gray or white
- Grid Lines: Subtle gray, 1pt
- Border Radius: 2-4pt on bar tops
- Spacing: 4-8pt between bars

**Trend Indicators**
- Up Arrow: Grass Green
- Down Arrow: Coral Red
- Neutral: Medium Gray
- Always include numeric value with indicator

### Illustrations

**Isometric Style**
- 30° angle for depth
- Simple geometric shapes
- Soft, diffused shadows
- Nature elements: trees, grass, soil, water
- Muted, harmonious colors from palette

**3D Objects**
- Smooth gradients for dimension
- Subtle highlights and shadows
- Maintain visual weight without overwhelming
- Example: Tree in terrarium, grass blocks

**Growth Metaphors**
- Seedlings → Saplings → Trees
- Small → Medium → Large
- Use size to indicate progress

---

## Animations & Motion

### Timing Functions

**Ease-out** (Default)
- Duration: 200-300ms
- Use for: Appearing elements, growing animations

**Ease-in-out**
- Duration: 300-400ms
- Use for: State transitions, modal displays

**Spring**
- Use for: Playful interactions, rewards, celebrations

### Animation Patterns

**Focus Start**
- Tree/plant grows up from bottom
- Fade in with slight scale (0.95 → 1.0)
- Duration: 400ms

**Timer Countdown**
- Smooth, continuous animation
- No jarring jumps
- Subtle pulse on completion

**Reward Collection**
- Coin bounces and scales up
- Duration: 500ms
- Add particle effects for special achievements

**Page Transitions**
- Fade + slide (20pt movement)
- Duration: 300ms
- Direction: Left/right for lateral navigation, up for modals

### Micro-interactions

- Button press: Scale 0.97, 100ms
- Toggle switch: Smooth slide, 200ms
- Tab selection: Underline slides, 250ms
- Loading: Gentle pulse or rotating leaves

---

## States & Feedback

### Interactive States

**Default**
- Standard appearance per component guidelines

**Hover** (Desktop)
- Slight darkening or lightening (-5% brightness)
- Subtle scale (1.02x) for clickable elements

**Active/Pressed**
- Scale down (0.97x)
- Slight darkening (-10% brightness)
- Shadow reduces

**Focused** (Keyboard)
- 3pt outline in Forest Green
- Offset: 2pt

**Disabled**
- Opacity: 40%
- Cursor: not-allowed
- Remove interactivity

**Loading**
- Show spinner or pulsing animation
- Disable interaction
- Maintain layout (no shifting)

### Success States

- Color: Grass Green
- Icon: Checkmark in circle
- Animation: Quick scale pop (0.8 → 1.1 → 1.0)
- Duration: On screen for 2-3 seconds

### Error States

- Color: Coral Red
- Icon: Alert triangle or X
- Animation: Gentle shake
- Message: Clear, actionable text

---

## Gamification Elements

### Progress Indicators

**Tree Growth**
- Visual representation of focus time
- Multiple stages of growth
- Celebrate milestones with animation

**Coins/Currency**
- Golden yellow circular tokens
- Animated collection sequence
- Display current balance prominently

**Streaks**
- Use fire or leaf icons
- Show current streak number
- Celebrate maintenance with encouraging messages

### Achievements

**Badge Design**
- Circular or shield shape
- Nature-themed icons
- Metallic finishes (bronze, silver, gold)
- Unlock animation with confetti or particles

**Level System**
- Progressive difficulty
- Clear visual hierarchy
- Show progress to next level

---

## Voice & Tone

### Writing Principles

**Encouraging, not pushy**
- ✅ "You've focused for 30 mins today!"
- ❌ "Only 30 minutes? You can do better."

**Clear and simple**
- ✅ "Plant a tree to start focusing"
- ❌ "Initialize your concentration session by cultivating botanical growth"

**Celebratory for achievements**
- ✅ "Amazing! You've grown 50 trees this month 🎉"
- ❌ "Milestone reached: 50 trees planted"

**Gentle for setbacks**
- ✅ "No worries! Start fresh tomorrow"
- ❌ "You failed to maintain your streak"

### Message Types

**Greeting:** Warm and personal
- "Good morning!" / "Welcome back!"

**Instruction:** Direct and helpful
- "Tap Plant to begin" / "Select your focus time"

**Feedback:** Positive and specific
- "15 minutes of focused work completed"

**Error:** Apologetic and solutioned
- "Oops! Something went wrong. Let's try again."

**Empty State:** Encouraging to act
- "Plant your first tree to start your focus forest"

---

## Iconography

### Icon Style

- **Stroke-based** with rounded caps and joins
- **2pt line weight** for consistency
- **24×24pt** default size on 32×32pt grid
- **Rounded corners** (2pt radius minimum)
- **Optical centering** for visual balance

### Icon Categories

**Navigation**
- Home, Settings, Profile, Stats
- Simple, instantly recognizable
- Use standard conventions

**Actions**
- Play/Pause, Add, Edit, Delete, Share
- Clear call to action
- Sufficient touch target (44×44pt minimum)

**Nature/Growth**
- Tree, Leaf, Sprout, Flower, Sun
- Stylized but recognizable
- Match illustration style

**Time**
- Clock, Timer, Hourglass, Calendar
- Clean and legible
- Consider animation

**Status**
- Check, X, Warning, Info
- Use color to reinforce meaning
- Standard shapes (circle, triangle)

---

## Accessibility

### Color Contrast

- **Text on Light Background:** Minimum 4.5:1 ratio
- **Text on Dark Background:** Minimum 4.5:1 ratio
- **Large Text (18pt+):** Minimum 3:1 ratio
- **UI Components:** Minimum 3:1 ratio against adjacent colors

**Testing:** Use contrast checker tools regularly

### Text Sizing

- **Minimum body text:** 15pt
- **Support dynamic type:** Test at 200% zoom
- **Line length:** 50-75 characters optimal
- **Line height:** 1.4-1.6 for readability

### Touch Targets

- **Minimum size:** 44×44pt (iOS), 48×48dp (Android)
- **Spacing:** 8pt minimum between targets
- **Expansion:** Add invisible padding if visual element is smaller

### Focus Indicators

- **Visible focus state** for all interactive elements
- **Keyboard navigation** fully supported
- **Logical tab order** following visual flow

### Alternative Text

- **Images:** Descriptive alt text for all meaningful images
- **Icons:** Include labels or ARIA labels
- **Decorative elements:** Mark as decorative (alt="")

### Motion Sensitivity

- **Respect prefers-reduced-motion** system setting
- **Disable animations** for users who request it
- **Provide static alternatives** to animated content

### Screen Reader Support

- **Semantic HTML** with proper heading hierarchy
- **ARIA labels** for complex interactions
- **Status announcements** for dynamic content changes
- **Clear focus order** and navigation landmarks

---

## Platform Considerations

### iOS Specific

- Use SF Pro or system font
- Follow iOS Human Interface Guidelines
- Respect safe areas (notch, home indicator)
- Use native gestures (swipe back, pull to refresh)
- Status bar: Light content on dark backgrounds

### Android Specific

- Use Roboto or system font
- Follow Material Design principles (adapted)
- Navigation: Bottom nav or side drawer
- Use native patterns (FAB if appropriate)
- Status bar: Adapt color to app theme

### Cross-Platform

- Maintain brand identity across platforms
- Adapt to platform conventions where expected
- Test on multiple screen sizes
- Consider landscape orientation

---

## Do's and Don'ts

### Do's ✅

- **Use nature metaphors** throughout the experience
- **Keep interface clean** with plenty of white space
- **Celebrate small wins** with encouraging messages
- **Use soft, organic shapes** (rounded corners, curves)
- **Make data visualization beautiful** and easy to read
- **Test with real users** regularly
- **Maintain consistency** across all screens
- **Support both light and dark themes** if possible

### Don'ts ❌

- **Don't overwhelm with options** - keep it simple
- **Don't use harsh, jarring colors** - maintain calm
- **Don't skip empty states** - guide new users
- **Don't forget loading states** - set expectations
- **Don't use nature imagery inconsistently**
- **Don't make gamification feel like pressure**
- **Don't ignore accessibility** requirements
- **Don't use stock photos** - custom illustrations only

---

## Implementation Notes

### Asset Delivery

- **Vector icons:** SVG format for web, SF Symbols for iOS
- **Illustrations:** SVG with embedded styles
- **Images:** PNG with @2x and @3x versions
- **Colors:** Define in shared design tokens

### Design Tokens

Create a centralized token system:

```
colors.primary.forest-green: #4A9B8E
colors.accent.golden-yellow: #F4C430
spacing.base: 8pt
spacing.large: 24pt
border-radius.card: 16pt
typography.body.size: 16pt
```

### Handoff

- Annotate designs with measurements
- Document interactive states
- Provide animation specifications
- Include edge cases and error states
- Share Figma/Sketch files with component library

---

## Examples & Usage

### Screen Templates

**Home/Main Screen**
- Large visual element (tree, timer) centered
- Current status clearly displayed
- Primary action button prominent
- Secondary navigation accessible but not distracting

**Statistics Screen**
- Charts and graphs with clear labels
- Time period filters at top
- Summary cards for key metrics
- Scroll for detailed breakdowns

**Settings Screen**
- Grouped lists with clear sections
- Toggle switches for binary options
- Navigation to sub-screens when needed
- Save/cancel actions when appropriate

### Common Patterns

**Onboarding**
- Welcome screen with app value proposition
- 2-3 screens explaining core features
- Use illustrations to demonstrate concepts
- Clear CTA to begin

**Empty States**
- Friendly illustration
- Encouraging message
- Clear action to populate the state
- Example: "Plant your first tree!"

**Confirmation Dialogs**
- Clear question or statement
- Two options: proceed or cancel
- Destructive actions in red
- Default to safe option

---

## Version History

**v1.0** - Initial style guide creation
- Established core design system
- Defined color palette and typography
- Created component library guidelines

---

## Conclusion

This style guide provides the foundation for creating a cohesive, calming, and motivating productivity app experience. The nature-based visual language, combined with thoughtful interaction design and accessible implementation, creates an environment where users can focus and grow.

Remember: Every design decision should support the user's ability to concentrate, feel encouraged, and build healthy habits. When in doubt, choose the simpler, calmer, more natural option.

---

**Questions or suggestions?** Contact the design team for guidance on specific implementations or to propose additions to this guide.