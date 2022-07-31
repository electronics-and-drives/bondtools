/*=============================================================================*
*
*   bondtools.il
*
*   Purpose:  Routing Bondwires in IC-Packages
*   Language: Cadence SKILL
*
*   Lint: IQ score is 100 (best is 100) {sklint ?file "bondtools.il"}
*
*   Author:   Matthias Schweikardt
*             (matthias.schweikardt@reutlingen-university.de)
*
*   Copyright 2021 Reutlingen University, Electronics & Drives (Germany)
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

;FUNCTION
; EDbondtoolsDrawWires
;
;Description:
; Draw bondwires in a layout cellview
;
;Parameters:
; cv               dbobj, cellview where the bonding diagram is created
; fBallRadius      float, radius of the ball in *du*
; fWireDiameter    float, diameter of bondwire in *du*
; fWedgeExtention  float, extension of the wedge in *du*
;
;Return:
; retval           bool, 't' when successful, 'nil' otherwise
;
(defun EDbondtoolsDrawWires (cv fBallRadius fWireDiameter fWedgeExtention "gnnn")
  (let (ballLabels wedgeLabels labelPairs)

    ;for lint
    fWedgeExtention

    (if 
      (and
        (dbIsId cv)
        (equal cv~>cellViewType "maskLayout")
        (equal cv~>mode "a")
      );and
    then

      (setq
        ballLabels 
        (EDbondtoolsGetLabelsFromHierarchy cv (list "BALL" "label"))
      );setq

      (setq
        wedgeLabels 
        (EDbondtoolsGetLabelsFromHierarchy cv (list "WEDGE" "label"))
      );setq
      
      (setq labelPairs (makeTable "labelPairs" nil))

      (foreach label ballLabels
        (unless (arrayref labelPairs (car label))
          (setarray labelPairs (car label) (tconc nil nil))
        );unless

        (tconc (arrayref labelPairs (car label)) (list (cadr label) "BALL"))
      );foreach

      (foreach label wedgeLabels
        (unless (arrayref labelPairs (car label))
          (setarray labelPairs (car label) (tconc nil nil))
        );unless

        (tconc (arrayref labelPairs (car label)) (list (cadr label) "WEDGE"))
      );foreach

      (foreach label labelPairs~>?

        (setarray
          labelPairs
          label
          (cdar (arrayref labelPairs label))
        );setarray

        (unless (equal (length (arrayref labelPairs label)) 2)

          (if (onep (length (arrayref labelPairs label))) then
            (warn
              "Too less pins (1) are specified for wire %L, will be ignored" 
              label
            );warn
          else
            (warn 
              "Too much pins (%L) are specified for wire %L, will be ignored" 
              (length (arrayref labelPairs label))
              label
            );warn
          );if

          (remove
            label
            labelPairs
          );remove
        );unless
      );foreach
    
      (foreach label labelPairs~>?

        (when (equal (cadar (arrayref labelPairs label)) "BALL")
          (dbCreateEllipse 
            cv
            (list "BONDWIRE" "drawing")

            (list  
              (list
                (difference (xCoord (caar (arrayref labelPairs label))) fBallRadius)
                (difference (yCoord (caar (arrayref labelPairs label))) fBallRadius)
              );list
              (list
                (plus (xCoord (caar (arrayref labelPairs label))) fBallRadius)
                (plus (yCoord (caar (arrayref labelPairs label))) fBallRadius)
              );list
            );list
          );dbCreateEllipse
        );when

        (when (equal (cadadr (arrayref labelPairs label)) "BALL")
          (dbCreateEllipse 
            cv
            (list "BONDWIRE" "drawing")

            (list  
              (list
                (difference (xCoord (caadr (arrayref labelPairs label))) fBallRadius)
                (difference (yCoord (caadr (arrayref labelPairs label))) fBallRadius)
              );list
              (list
                (plus (xCoord (caadr (arrayref labelPairs label))) fBallRadius)
                (plus (yCoord (caadr (arrayref labelPairs label))) fBallRadius)
              );list
            );list
          );dbCreateEllipse
        );when

        (dbCreatePath
          cv
          (list "BONDWIRE" "drawing")
          (list 
            (caar  (arrayref labelPairs label))
            (caadr (arrayref labelPairs label))
          );list
          fWireDiameter 
        );dbCreatePath
      );foreach

      labelPairs
    else
      (error "No editable cellview is provided")
      nil
    );if
  );let
);defun EDbondtoolsDrawWires

;FUNCTION
; EDbondtoolsGetLabelsFromHierarchy
;
;Description:
; Get the position of the bondtools labels hierarchically
;
;Parameters:
; dbobj            dbobj, database object to be searched for labels
; layer            lpp, layer purpose pair of label
;
;Return:
; labels           list, list of labels
;
(defun EDbondtoolsGetLabelsFromHierarchy (dbobj layer)

  (let ((lAccumulator (tconc nil nil)) subLabels)

    (foreach shape dbobj~>shapes
      (when
        (and
          (equal shape~>lpp layer)
          (equal shape~>objType "label")
        );and 
        (tconc lAccumulator (list shape~>theLabel shape->xy))
      );when
    );foreach

    (foreach inst dbobj~>instances

      (setq subLabels (EDbondtoolsGetLabelsFromHierarchy inst~>master layer))

      (when subLabels
        (lconc
          lAccumulator
          (foreach mapcar elem subLabels
            (list
              (car  elem)
              (dbTransformPoint (cadr elem) inst~>transform)
            );list
          );foreach
        );lconc
      );when
    );foreach

    (cdar lAccumulator)
  );let
);defun

;FUNCTION
; EDbondtoolsDrawBondWiresCallback
;
;Description:
; Callback that is triggered when the button *OK* or *Apply*
; is pushed in the GUI
;
;Return:
; t             bool, always 't'
;
(defun EDbondtoolsDrawBondWiresCallback ()
  (let (form)
    (setq form (eval (quote EDdrawBondWires)))

    (EDbondtoolsDrawWires
      (geGetWindowCellView)
      form~>ballRadius~>value
      form~>bondDiameter~>value
      form~>wedgeExtionsion~>value
    );EDbondtoolsDrawWires
    t
  );let
);defun

(let (bondDiameter ballRadius wedgeExtionsion formLayout)
  (setq
    bondDiameter
    (hiCreateFloatField
      ?name (quote bondDiameter)
      ?prompt "Bondwire Diameter"
      ?value  25.0
      ?range (list 0.01 "infinity")
    );hiCreateFloatField
  );setq

  (setq
    ballRadius
    (hiCreateFloatField
      ?name (quote ballRadius)
      ?prompt "Ball Radius"
      ?value  35.0
      ?range (list 0.01 "infinity")
    );hiCreateFloatField
  );setq

  (setq
    wedgeExtionsion
    (hiCreateFloatField
      ?name (quote wedgeExtionsion)
      ?prompt "Wedge Extension"
      ?value  0.0
      ?range (list 0.0 "infinity")
      ?editable nil
    );hiCreateFloatField
  );setq

  (setq
    formLayout
    (hiCreateFormLayout
      (quote drawBondwireFormLayout)
      ?frame "drawBondwireFormLayout"
      ?items
        (list
          bondDiameter
          ballRadius
          wedgeExtionsion
        );list
    );hiCreateFormLayout
  );setq

  (hiCreateLayoutForm
    (quote EDdrawBondWires)
    "[ED] Draw Bondwires"
    formLayout
    ?sizePolicy 'horizontalExpanding
    ?dialogStyle 'modeless
    ?buttonLayout 'OKCancelApply
    ?minSize 250:100
    ?callback
      (list
        "(EDbondtoolsDrawBondWiresCallback)"
        "nil"
      );list
    ?buttonDisabled (list 'Help)
  );hiCreateLayoutForm
);let

;FUNCTION
; EDBondtoolsCreateLayoutPulldownMenu
;
;Description:
; This function creates a pulldown menu
;
;Return:
; pulldown menu
;
(defun EDBondtoolsCreateLayoutPulldownMenu () 
  (hiCreatePulldownMenu
    (quote EDbondtoolsPulldownMenu) 
    "E&&D" 
    (list 
      (hiCreateMenuItem
        ?name (quote EDBondtoolsMenuItem)
        ?itemText "Draw Bondwires"
        ?callback "(hiDisplayForm (quote EDdrawBondWires))" 
      );hiCreateMenuItem
    );list
  );hiCreatePulldownMenu 
);defun 

;FUNCTION
; EDBondtoolsMenuBarPostInstallTrigger
;
;Description:
; This function is a trigger which added the Bondtools menu item to the VLE
;
;Return:
; t             bool, always 't'
;
(defun EDBondtoolsMenuBarPostInstallTrigger (args) 
  (when 
    (not
      (rexMatchList
        "EDbondtoolsPulldownMenu"
        (hiGetBannerMenus args->window)
      );rexMatchList
    );not

    (hiInsertBannerMenu
      args->window 
      (if (boundp (quote EDbondtoolsPulldownMenu))
        EDbondtoolsPulldownMenu
        (EDBondtoolsCreateLayoutPulldownMenu)
      );if
      (length (hiGetBannerMenus args->window)) 
    );hiInsertBannerMenu
  );when
  t
);defun

;Trigger for Layout-L
(deRegUserTriggers
  "maskLayout"
  nil
  nil
  (quote EDBondtoolsMenuBarPostInstallTrigger)
);deRegUserTriggers

;Trigger for Layout-XL
(deRegUserTriggers
  "maskLayoutXL"
  nil
  nil
  (quote EDBondtoolsMenuBarPostInstallTrigger)
);deRegUserTriggers

;Trigger for Layout-GXL
(deRegUserTriggers
  "maskLayoutGXL"
  nil
  nil
  (quote EDBondtoolsMenuBarPostInstallTrigger)
);deRegUserTriggers