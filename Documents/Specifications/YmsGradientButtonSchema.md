<style>
body { margin: 0pt;
       padding: 0.5in;
       font-family: Helvetica;
       font-size: 12pt; }
       
h1 { font-size: 1.333em; }
h2 { font-size: 1.167em; page-break-before: always }
h3 { font-size: 1em; }

table {
   border-style: solid;
   border-width: 1px;
   border-color: grey;
   width: 80%;
   }
   
td {
   border-bottom: 1px solid grey;
   border-right: 1px solid grey;
}

th {
   border-bottom: 3px solid black;
   border-right: 1px solid grey;
}

pre {
     background-color: #ECECEC
}

</style>

# YmsGradientButton Property List Schema

### Changelist

* Initial Entry

---

## Schemas

| All Schemas | Description | 
|:--|:--|
|[YmsGradientButton]|Top-level schema for YmsGradientButton property list|
|[ControlState]|ControlState schema|
|[Gradient]|Gradient schema|
|[Shadow]|Shadow schema|
|[ARGB]|Alpha color schema|


### Notes
* Inherited properties listed in tables are italicized.

---

## YmsGradientButton [YmsGradientButton]

Top-level schema for YmsGradientButton property list.

### Properties

| Property | Type | Definition | Required |
|:--|:--:|:--|:--:|
|version|float|YMSGradientButton schema version | &bull; | 
|normal|[ControlState]| Configuration for UIControlStateNormal |&bull; | 
|highlighted|[ControlState]| Configuration for UIControlStateHighlighted | | 
|disabled|[ControlState]| Configuration for UIControlStateDisabled |&bull; | 
|selected|[ControlState]| Configuration for UIControlStateSelected | | 


---

## ARGB [ARGB]

Color schema to overlay {Alpha, Red, Green, Blue} components into subfields of a 32-bit little-endian integer.

### Fields

| Field | Bit Slice | Definition (all values pre-normalized with range between 0 and 255) |
|:--|:--:|:--|
|Alpha|24:31| Alpha value |
|Red|16:23| Red component value |
|Green|8:15| Green component value |
|Blue|0:7| Blue component value |

---

## ControlState [ControlState]

Schema to define a gradient.

### Properties

| Property | Type | Definition |
|:--|:--:|:--|
|borderWidth|float| The width of the receiver's border. |
|borderColor|[ARGB]| The color of the receiver's border. |
|cornerRadius|float| Specifies a radius used to draw the rounded corners of the receiver's background. |
|textColor|[ARGB]| The color of the text. |
|gradients|[Gradient] \[1..*n*\]{ordered}|Array of *n* gradients to be rendered on top of each other from the lowest index to the highest. |
|shadow|[Shadow]| Configuration for button shadow |

---

## Gradient [Gradient]

Schema to define a gradient.

### Properties

| Property | Type | Definition | Required |
|:--|:--:|:--|:--:|
|type|enum {linear, radial}|Gradient type to render.| &bull; |
|colors|[ARGB] \[1..*N*\]{ordered}| A size *N* array of colors defining the color of each graident stop. | &bull; |
|locations|float[1..*N*]{ordered}| A size *N* array of locations defining the location of each gradient stop. Each element must be bounded within the interval [0.0, 1.0]. Note that size *N* must be the same for colors and locations.|&bull; |
|startPoint|float[1..2]{ordered}| The start point of the gradient when drawn in the layer's coordinate space for a *linear* type. | linear |
|endPoint|float[1..2]{ordered}|  The end point of the gradient when drawn in the layer's coordinate space for a *linear* type. | linear | 
|startCenter|float[1..2]{ordered}| The coordinate that defines the center of the starting circle for a *radial* type. The coodinate values are normalized between [0.0, 1.0]  | radial | 
|startRadius|string | The radius of the starting circle for a *radial* type. The radius can be either specified by 1) a percentage of half the width of the button's bounding box; or 2) a floating point value.| radial |
|endCenter|float[1..2]{ordered}|  The coordinate that defines the center of the ending circle for a *radial* type. | radial |
|endRadius|string | The radius of the ending circle for a radial type. The radius can be either specified by 1) a percentage of half the width of the button's bounding box; or 2) a floating point value. | radial | 

---

## Shadow [Shadow]

Schema to define a shadow for the button.

### Properties

| Property | Type | Definition |
|:--|:--:|:--|
|enable|boolean| |
|shadowColor|[ARGB]| Specifies the color of the receiver's shadow. |
|shadowOpacity|float| Specifies the opacity of the receiver's shadow. |
|shadowRadius|float| Specifies the blur radius of the receiver's shadow. |
|shadowOffset|float [1..2]{ordered}| Specifies the offset of the receiver's shadow. |
|anchorPoint|float [1..2]{ordered}| Specifies the anchor point of the layer's bounds rectangle. |

---

Copyright &copy; 2012 Yummy Melon Software LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0] (http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
imitations under the License.

