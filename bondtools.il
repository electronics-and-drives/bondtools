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


(defun EDbondtoolsDrawWires (cv fBallRadius fWireDiameter "gnn")
  (let (labels labelPairs)

    (if 
      (and
        (dbIsId cv)
        (equal cv~>cellViewType "maskLayout")
        (equal cv~>mode "a")
      );and
    then

      (setq labels (setof shape cv~>shapes (equal shape~>objType "label")))
      (setq labelPairs (makeTable "labelPairs" nil))

      (foreach label labels
        printf("Here\n")
        (unless (arrayref labelPairs label~>theLabel)
          (setarray labelPairs label~>theLabel (tconc nil nil))
        );unless

        (tconc (arrayref labelPairs label~>theLabel) label~>xy)
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

          (dbCreateEllipse 
            cv
            (list "BONDWIRE" "drawing")
            (list  
              (list
                (difference (xCoord (car (arrayref labelPairs label))) fBallRadius)
                (difference (yCoord (car (arrayref labelPairs label))) fBallRadius)
              );list
              (list
                (plus (xCoord (car (arrayref labelPairs label))) fBallRadius)
                (plus (yCoord (car (arrayref labelPairs label))) fBallRadius)
              );list
            );list
          );dbCreateEllipse

          (dbCreateEllipse 
            cv
            (list "BONDWIRE" "drawing")
            (list  
              (list
                (difference (xCoord (cadr (arrayref labelPairs label))) fBallRadius)
                (difference (yCoord (cadr (arrayref labelPairs label))) fBallRadius)
              );list
              (list
                (plus (xCoord (cadr (arrayref labelPairs label))) fBallRadius)
                (plus (yCoord (cadr (arrayref labelPairs label))) fBallRadius)
              );list
            );list
          );dbCreateEllipse

          (dbCreatePath
            cv
            (list "BONDWIRE" "drawing")
            (list 
              (car (arrayref labelPairs label))
              (cadr (arrayref labelPairs label))
            );list
            fWireDiameter 
          );dbCreatePath
      );foreach

      t
    else
      (error "No editable cellview is provided")
      nil
    );if
  );let
);defun EDbondtoolsDrawWires