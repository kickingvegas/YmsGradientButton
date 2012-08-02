# YmsGradientButton v1.3

iOS UIButton subclass featuring property list (plist) configured bitmap-free gradients.

## About

**YmsGradientButton** is a subclass of UIButton which supports the rendering of a gradient background and shadow with respect its control state (`UIControlState`). Supported gradient types are linear and radial.

![](https://raw.github.com/kickingvegas/YmsGradientButton/master/Documents/images/screenshot.png)


## Change List - Many of them, all for the better.

* Added support to define multiple gradients to render per `UIControlState`.
* Added support to define shadow per `UIControlState`.
* Added support to render a radial gradient.
* YmsGradientButton property list schema more robustly [specified](Documents/Specifications/YmsGradientButtonSchema.html).
* Added version to YmsGradientButton plist specification. (Current value: 1.3)
* *New* --  `ygbutil` utility with the following features:
    - Upgrade previous plist file to current version
    - Convert plist file to JSON for easier editing via text-editor
    - Convert JSON file back to plist
* Improved error messaging and validation of plist file.
* Fixed bug to render gradient before the start location point and after the end location point.
* Support for Retina display.

## Quickstart

* From the folder `YmsGradientButton`, copy `YmsGradientButton.[hm]`, `YmsStyleSheet.h` and `YmsGradientButton.plist` to 
  your project.
* Add the `QuartzCore.framework` to your project.
* Instantiate a `UIButton` in Interface Builder. With the identity inspector, 
  set the custom class to `YmsGradientButton`.
* Configure the gradients of the button for the different `UIControlStates`
  *normal*, *highlighted*, *disabled*, and *selected* in the file `YmsGradientButton.plist`.
* You can subclass `YmsGradientButton` and create a plist with the subclass
  name to create your own custom button.
* `YmsGradientButton` can also be instantiated programmatically.

[YmsGradient Button Property List Specification v1.3](Documents/Specifications/YmsGradientButtonSchema.html)


## Upgrading plist files

Previous releases of plist files must be upgraded to version 1.3 to work with this code release. 
To upgrade, use `ygbutil` in the following fashion:

        $ ygutil -i YmsGradientButton.plist upgrade


### `ygbutil` Installation

1. From the command line, enter the directory `ygbutil`.
2. Modify the `Makefile` to define the installation directory `INSTALL_DIR`, if necessary. By default it is set to `$HOME/bin`.
3. Run `make install`.
4. Help for `ygbutil` can be invoked with the `-h` flag.

## Editing plist files via JSON

With `ygbutil` one can edit the property list files by converting it to a JSON file. When editing the JSON file, color values are represented as a string in the format `#AARRGGBB` where:

* `AA` is the alpha channel value in hexadecimal form
* `RR` is the red color component in hexadecimal form
* `GG` is the green color component in hexadecimal form
* `BB` is the blue color component in hexadecimal form

To convert a plist file to JSON, invoke the following command:

        $ ygbutil -i YmsGradientButton.plist convert
    
To convert a JSON file back to a property list, invoke the following command:

        $ ygbutil -i YmsGradientButton.js convert


## Notes

This code is written using ARC. 

## Acknowledgements

Modifications for supporting multiple gradients are taken from a [fork of this project](https://github.com/rchampourlier/YmsGradientButton) maintained by [Romain Champourlier](https://github.com/rchampourlier).

## License

Copyright 2012 Yummy Melon Software LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Author: Charles Y. Choi <charles.choi@yummymelon.com>
