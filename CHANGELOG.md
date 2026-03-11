## 1.0.0

*   Initial release.
*   **Project Rename**: Fixed misspelling from `searable_dropdown` to `searchable_dropdown`.
*   Added `CustomSearchDropdownWidget` for single selection.
*   Added `CustomMultiSearchDropdownWidget` for multiple selection with checkboxes.
*   Added `CustomRadioSearchDropdownWidget` for single selection with radio buttons (deprecated/removed in latest but noted in history).
*   **Refactor & Safety**:
    *   Removed `topContext` parameter requirement.
    *   Added `itemToString` parameter for custom search filtering.
    *   Implemented safe internal `itemsList` copying.
    *   Added `overlay.mounted` checks for safe disposal.
*   Implemented conditional local search (if `onSearch` is null).
*   Generic Type Support `<T>` for all widgets.
*   Added debounced search input (500ms).
*   Repository: `https://github.com/Abdul520Mannan/searchable_dropdown`.
