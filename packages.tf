/*=============================================================================*
*
*   packages.tf
*
*   Purpose:    Technology File for IC-Packages
*
*   Author:     Matthias Schweikardt
*   Email:      matthias.schweikardt@reutlingen-university.de
*
*   Copyright 2022 Reutlingen University, Electronics & Drives (Germany)
*
*   Permission is hereby granted, free of charge, to any person obtaining a
*   copy of this software and associated documentation files (the "Software"),
*   to deal in the Software without restriction, including without limitation
*   the rights to use, copy, modify, merge, publish, distribute, sublicense,
*   and/or sell copies of the Software, and to permit persons to whom the
*   Software is furnished to do so, subject to the following conditions:
*
*   The above copyright notice and this permission notice shall be included in
*   all copies or substantial portions of the Software.
*
*   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
*   THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
*   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
*   DEALINGS IN THE SOFTWARE.
*
*=============================================================================*/

controls(
 techVersion("1.0")
 mfgGridResolution(
      ( 0.025000 )
 )
)

layerDefinitions(

  techLayers(
    (PACKAGE_METALIZATION 133  PKG_MET )
    (PACKAGE_LABEL        134  PKG_LBL )
    (BONDWIRE             135  BOND    )
    (BALL                 136  BALL    )
    (WEDGE                137  WEDGE   )
    (DEF_CHIP             138  DEF_CHIP)
    (DEF_PAD              139  DEF_PAD )
    (DEF_MARK             140  DEF_MARK)
    (PACKAGE_OUTLINE      141  PKG_OUT )
 )

  techLayerPurposePriorities(
    (PACKAGE_METALIZATION drawing)
    (PACKAGE_LABEL          label)
    (BONDWIRE             drawing)
    (BALL                   label)
    (WEDGE                  label)
    (DEF_CHIP             drawing)
    (DEF_PAD              drawing)
    (DEF_MARK             drawing)
    (PACKAGE_OUTLINE      drawing)
  )

  techDisplays(
    (PACKAGE_METALIZATION  drawing PKG_MET  t t t t t)
    (PACKAGE_LABEL         label   PKG_LBL  t t t t t)
    (BONDWIRE              drawing BOND     t t t t t)
    (BALL                  label   BALL     t t t t t)
    (WEDGE                 label   WEDGE    t t t t t)
    (DEF_CHIP              drawing DEF_CHIP t t t t t)
    (DEF_PAD               drawing DEF_PAD  t t t t t)
    (DEF_MARK              drawing DEF_MARK t t t t t)
    (PACKAGE_OUTLINE       drawing PKG_OUT  t t t t t)
  )
)