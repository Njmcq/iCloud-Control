<p align="center">
  <img width="250" height="250" src="Docs/iCloud-Control-1.8.0-Icon-1024.png">
</p>

iCloud Control is a macOS Finder extension that offers enhanced control over files stored in iCloud Drive, allowing selective synchronisation based on user preferences.

## :warning: Future iCloud Control Support
As of March 10, 2023, my availability to provide support for iCloud Control may be limited. While I plan to continue working on the project and implementing additional features and improvements, my ability to respond promptly may be impacted.

Please note that macOS natively integrates a significant portion of iCloud Control's functionality. For most tasks, it is recommended to use the built-in macOS features in Finder. Refer to the instructions below to leverage these native functionalities:

- **Remove selected items locally**: Control- or right-click files in the Finder, then select **Remove Download**.
- **Download selected items**: Available through the same Control- or right-click method as **Remove selected item locally**.
- **Publish public link**: Achieve this through the **Share** option on macOS Ventura and later, or **Share File** option on macOS Monterey and older, via the Control-click menu.

To exclude items from iCloud, rename the file and add **.nosync** to the end of the filename. To restore items, simply remove **.nosync** from the filename, ensuring to retain the original file type extension.

## Installation & Help

1. Download the latest version of iCloud Control from the [GitHub releases page](https://github.com/Njmcq/iCloud-Control/releases/latest).
2. Move iCloud Control from your Downloads to the Applications folder.
3. When iCloud Control first opens, enable notifications for important alerts when using the **Publish public link** feature or in case of errors. (Note: Notifications are not available on macOS 10.13).
4. Open System Settings (or System Preferences on older macOS versions) and navigate to the Extensions panel. Enable iCloud Control's Finder extension under "Added Extensions."
5. Close System Settings/Preferences and the iCloud Control app.
6. Open a Finder window and, if necessary, customize the Toolbar to add the iCloud Control icon.

### Having Issues with the Toolbar Extension?

If you encounter display issues with the Toolbar extension, try logging out and back in, or restarting your Mac.

## Usage

The Finder toolbar provides the following actions:

- **Remove selected item locally**: Removes selected item(s) from your device while keeping them in iCloud.
- **Download selected item**: Downloads previously removed files from iCloud.
- **Publish public link**: Copies a link to the selected file to your clipboard.
- **Exclude selected items**: Prevents files in an iCloud-based directory from syncing by adding the .nosync file extension.
- **Restore selected items**: Removes the .nosync extension from files, restoring them to their original file type.
- **Manage iCloud on the web**: Includes quick links to iCloud.com, appleid.apple.com, and privacy.apple.com.

## Compatibility
iCloud Control 1.3.0 and above is compatible with macOS 10.13 and above, and runs natively on both Intel and Apple silicon Macs. Users who wish to use iCloud Control on macOS 10.12 or below can use version 1.2.0 published by [@Obbut](https://github.com/Obbut), found at [https://github.com/Obbut/iCloud-Control/releases](https://github.com/Obbut/iCloud-Control/releases).

## License

[View the LICENSE.md file](https://github.com/Njmcq/iCloud-Control/blob/master/LICENSE.md)

MIT License

Copyright (c) 2016 Robbert Brandsma  
Copyright (c) 2022-2023 Nick McQuade

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
