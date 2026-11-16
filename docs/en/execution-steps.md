# Execution Steps

[中文](../execution-steps.md)

Five phases: (1) Xcode skeleton, ClipboardItem/Store/ImageHelper and JSON CRUD; (2) 0.5 s clipboard monitoring, text/image capture, deduplication and pause/resume; (3) menu-bar/popover/list/cards/empty state and monitor coordination; (4) search, pin, delete, copy-back and clear search on reopening; (5) retention settings, periodic cleanup, light/dark appearance and full-flow review.

Verify each phase before progressing: no crash, persisted/read/deleted records, image files, no duplicate captures, working popover/empty state, correct manual pasting and synchronized persistence. Final checks cover all P0/P1/P2 features, retention cleanup, appearance/menu icon and stability. Original checkboxes are historical planning artifacts; this translation does not mark them newly passed. Code changes still follow the repository's existing staged workflow.
