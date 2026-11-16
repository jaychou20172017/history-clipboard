# Design Guidelines

[中文](../design-guidelines.md)

Use simple native macOS semantic colors and intuitive interaction. Panel width 320 pt, height 200–500 pt, radius 12 pt. Fixed top search height 36 pt with magnifyingglass symbol. Cards use 12 pt horizontal/10 pt vertical padding, 6 pt spacing and 8 pt radius. Preview up to two text lines or 44×44 pt image thumbnail; time top-right, hover pin/delete bottom-right. Empty state uses clipboard symbol and explanatory text.

Use AppKit semantic window/fill/label/accent/separator colors; SF Symbols list.clipboard, magnifyingglass, pin/pin.fill, trash, gearshape, clipboard, doc.text and photo. Card/search text 13 pt, time 11, empty heading 15 medium, empty subtext 12 and settings 13.

Icon toggles popover; outside click closes it. Clicking a card copies and closes; pinning reorders; deletion requires no extra confirmation; search filters immediately; retention changes apply to cleanup. Standard popover animation, no card-entry/search animation and 0.2 s ease-out removal. Documentation only; no UI changes or new visual acceptance claims.
