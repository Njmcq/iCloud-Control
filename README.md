![](Docs/iCloud%20Control%201280x200%20transparent.png)

---

### Adds a menu to the Finder that allows control over files stored in iCloud, providing user-controlled selective synchronisation.

![](Docs/1.7.0-Extension-Menu.png)

# :warning: Future iCloud Control support
As of March 10 2023, support for iCloud Control will be winding down. I initially planned on discontinuing the project entirely, but there are some more additions which I would like to make before I abandon the project. However, majority of the app's features are now native in macOS. Please refer to the instructions below to learn how to use the native macOS features in the Finder:

### Remove selected items locally:
This can be accomplished by selecting files in the Finder, control- or right-clicking the selection, and selecting **Remove Download**. In a selection of files with both local and non-local files, you can hold the **Option** key in the menu to bring up the same action.

### Download selected items:
This is available through the same Control- or right-click method as the **Remove selected item locally** option.

### Publish public link:
This can be achieved through the **Share** option on macOS Ventura and later, and the **Share File** option in macOS Monterey and older, through the Control-click menu.

#### In macOS Ventura and later:
Select **Collaborate** from the menu, and choose **Anyone with the link can edit** below it (this is a little difficult to see, but it should bring up additional sharing options. Choose **Anyone with the link** and manage permissions as you wish. Then select **Invite with Link** in the Sharing options. This will copy the public link to your clipboard.
#### In macOS Monterey and earlier:
Once **Share File** has been selected, a new window will appear. Select **Copy Link**, and adjust the settings to **Anyone with the link can edit**. Manage your preferred permission settings and press **Share** when you are done. This will copy the public link to your clipboard.

### Exclude selected items from iCloud:
Go to the Finder item in the menu bar, and select Settings (or Preferences on older versions of macOS). In the Advanced panel, enable **Show all filename extensions**. Then, with the files you wish to exclude, go to rename the file and add **.nosync** to the end of the filename.

### Restore selected items:
Simply remove **.nosync** from the filename. Make sure to retain the original file type extension.

---

## Installation & Help

1. Download the latest version of iCloud Control from the [GitHub releases page](https://github.com/Njmcq/iCloud-Control/releases/latest).
2. Move iCloud Control from your Downloads to the Applications folder.
3. Because iCloud Control isn't notarised as of yet, Gatekeeper flags the app as unknown and potentially malicious. iCloud Control is not in any way malicious, and if you are concerned, you are more than welcome to review the source code in the repository. To bypass Gatekeeper, Control-click or right-click on the app in the Applications folder, and select "Open". This will bring up a similar alert, but you will be able to select "Open" to run the app.
4. When iCloud Control first opens, you may be prompted to enable notifications. It is highly recommended to enable notifications as they deliver important alerts when using the **Publish public link** feature, and if an error occurs.
5. iCloud Control will open with a window welcoming you! As per the instructions in that window, you need to select Open System Settings (or System Preferences on older versions of macOS) to bring up the Extensions panel.
6. In the panel, select "Added Extensions" and enable iCloud Control's Finder extension (you may have to scroll down if multiple other apps appear here).
7. Once you have done this, you can safely close System Settings/Preferences and the iCloud Control app.
8. Open a Finder window. In the Toolbar at the top, you may see the iCloud Control icon appear. If you don't, control- or right-click the Toolbar and select "Customise Toolbar". A new window will open with a selection of Toolbar extensions. Drag iCloud Control into the Toolbar (the other extensions will be bouncing around). Some may easily confuse the default Toolbar preset at the bottom of the window for the place to drag the extension, so ensure that it's the one which has bouncing icons.
9. Select "Done".

## Usage

The following actions are provided through a toolbar item in the Finder:

- **Remove selected item locally**: the selected item(s) will be removed from your device, while remaining in iCloud.
- **Download selected item**: download previously removed files from iCloud.
- **Publish public link**: places a link to the selected file in your clipboard.
- **Exclude selected item from iCloud**: using the .nosync file extension, files in an iCloud-based directory will not sync with the service.
- **Restore selected items**: removes the .nosync extension from files, reverting them to their original file type.
- **Manage iCloud on the web**: includes quick links to both iCloud.com and appleid.apple.com.

## Compatibility
iCloud Control 1.3 and above is compatible with macOS 10.13 and above, and runs natively on both Intel and Apple silicon Macs. Users who wish to use iCloud Control on 10.12 or below may do so with version 1.2.0 published by [@Obbut](https://github.com/Obbut), found at https://github.com/Obbut/iCloud-Control/releases

## Known Issues
### Optimise Mac Storage may interfere with iCloud Control's features
**Issue:** If Optimise Mac Storage is enabled in your iCloud settings, it may override some of the operations of iCloud Control (such as reversing "Remove selected items locally").

**Workaround:** Unfortunately, there is no way to easily overcome this issue. As a result, you may have to select the action a couple of times if the file reverts to its original state, to force iCloud Control's operation. Otherwise, if this continues to cause issues, consider disabling Optimise Mac Storage.

### Available releases before 1.6.0 do not abide by Semantic Versioning
**Issue:** Because I was unaware of the concept of Semantic Versioning, every release of iCloud Control between 1.3 and 1.6.0 (1.5.0 was technically the first corrected release, but it has since been pulled due to unrelated issues) does not abide by the Semantic Versioning guidelines. As such, every release version from 1.3 follows a broken versioning system and does not reflect the nature of the release.

**Workaround:** 1.6.0 is the first available update which follows Semantic Versioning 2.0.0. Users should update to the [latest release](https://github.com/Njmcq/iCloud-Control/releases/latest) as soon as possible.

### Check For Updates does not work on pre-release versions of the latest release
**Issue:** For example, if a user has 1.6.0-rc.2 installed on their Mac and the latest published release is 1.6.0, the code will compare the version number in the installed version (**1.6.0**-rc.2) and the published version (**1.6.0**) and think that it's the same version, thus making it assume that the latest version is already installed. This does not apply if the installed number is different to the latest release (for example, if the user has a hypothetical **1.5.9**-rc.1 installed, and the latest release is **1.6.0**, it will see the latest update as per usual and prompt the user with the appropriate alert.

**Workaround:** Check the [Releases page](https://github.com/Njmcq/iCloud-Control/releases) for the latest stable release if you are running a pre-release version of iCloud Control.

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

