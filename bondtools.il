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

(defun EDbondtoolsDrawBondWiresCallback ()
  (let (form)
    (setq form (eval (quote EDdrawBondWires)))

    (EDbondtoolsDrawWires
      (geGetWindowCellView)
      form~>ballRadius~>value
      form~>bondDiameter~>value
      form~>wedgeExtionsion~>value
    );EDbondtoolsDrawWires
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

