# Change Log

# 1.3.11

### Fixes

1. Do not upload screenshots if SDK token has not been acquired yet.
2. Use US locale for date formatting.
3. Fix release/debug mode detection.
4. Update device after launch or install event.

# 1.3.10

### Chore

1. Remove external dependency (BSON)

# 1.3.9 (Unreleased)

### Fixes
1. Fix PermissionType issue.

# 1.3.8 (Unreleased)

### Feature

1. Add entry and exit animation from corners.
2. Remove requirement for `COOEE_SECRET_KEY`.
3. Push Notification can perform CTA action.

### Improvement

1. InAppBrowser is replaced with CustomTabsIntent.
2. InApp will have its own base property.
3. InApp will have default close CTA.
4. Update property key for duration in CTA, Foreground, Background.
5. Expose `CooeeSDK.updateUserProfile(_:)` API.

### Deprecated

1. Deprecated `CooeeSDK.updateUserData(userData:)`, `CooeeSDK.updateUserProperties(userProperties)`, 
`CooeeSDK.updateUserProfile(userData:userProperties:)`.

# 1.3.7

### Improvements
1. Expose public classes and their methods for Objective-C


# 1.3.6

### Fixes
1. App group access for user default.

### Chore

1. Remove warnings.

# 1.3.5

### Feature

1. Add ability to move In-App at any side of screen.
2. Now In-App can be of any size.

### Improvements

1. Collection of event property is now grouped and renamed.

### Fixes

1. Fix issue with Part Rendering.
2. Fix issue with view's background image & border.
3. Fix issue with Image rendering when out of viewport.
4. Fix issue with In-App entry and exit animation

### Chore

1. Remove AR support.

# 1.3.1 1.3.2, 1.3.3, 1.3.4

1. Release patch

# 1.3.0

1. Add support to notifications service
2. Add InApp and AR support

# 1.2.5

1. Explicitly setting minimum target deployment to 13.0

# 1.2.4

1. Not asking the location permission explicitly.

# 1.2.3

1. Data properties are now sent as is without converting to strings.

# 1.2.2

1. Server calls are secured internally by making sure the access token exists.
2. Renaming a few classes.
