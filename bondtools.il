/*=============================================================================*
*
*   bondtools
*
*
*   Purpose  : Routing Bondwires in IC-Packages
*   Authors  : Matthias Schweikardt
*
*   Language : Cadence Skill
*   Lint     : IQ score is 99 (best is 100) {sklint ?file "bondtools.il"}
*  
*   Globals  :
*    - Functions :
*       o EDbondtoolsDrawWires
*       o EDbondtoolsGetLabelsFromHierarchy
*       o EDbondtoolsOpenUserInterface
*       o EDbondtoolsDrawBondWiresCallback
*       o EDbondtoolsEnableLogfileCallback
*       o EDBondtoolsCreateLayoutPulldownMenu
*       o EDBondtoolsMenuBarPostInstallTrigger
*    - Symbols   : none
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


;FUNCTION
; EDbondtoolsDrawWires
;
;Description:
; Draw bondwires in a layout cellview
;
;Parameters:
; cv               dbobj,  cellview where the bonding diagram is created
; fBallRadius      float,  radius of the ball in *du*
; fWireDiameter    float,  diameter of bondwire in *du*
; fWedgeExtention  float,  extension of the wedge in *du*
; sLogfile         string, path to logfile (provide nil when no logfile is cretaed)
;
;Return:
; retval           bool, 't' when successful, 'nil' otherwise
;
(defun EDbondtoolsDrawWires (cv fBallRadius fWireDiameter 
                               fWedgeExtention sLogfile "gnnng")
  (let (ballLabels wedgeLabels labelPairs (port nil))

    ;for lint
    fWedgeExtention

    (if 
      (and
        (dbIsId cv)
        (equal cv~>cellViewType "maskLayout")
        (equal cv~>mode "a")
      );and
    then

      (when (stringp sLogfile)
        (setq port (outfile sLogfile "w"))
        (fprintf port "type1,type2,x1,y1,x2,y2")
      );when

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

        (if (equal (cadar (arrayref labelPairs label)) "BALL") then
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

          (when (portp port)
            (fprintf
              port
              "\nball"
            );fprintf
          );when
        else
          (when (portp port)
            (fprintf
              port
              "\nwedge"
            );fprintf
          );when
        );if

        (if (equal (cadadr (arrayref labelPairs label)) "BALL") then
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

          (when (portp port)
            (fprintf
              port
              ",ball"
            );fprintf
          );when
        else
          (when (portp port)
            (fprintf
              port
              ",wedge"
            );fprintf
          );when
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

        (when (portp port)
          (fprintf
            port
            ",%L,%L,%L,%L"
             (xCoord (caar  (arrayref labelPairs label)))
             (yCoord (caar  (arrayref labelPairs label)))
             (xCoord (caadr (arrayref labelPairs label))) 
             (yCoord (caadr (arrayref labelPairs label)))
          );fprintf
        );when
      );foreach

      (when (portp port)
        (close port)
      );when

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
; EDbondtoolsOpenUserInterface
;
;Description:
; This function open the user interface of the software bondtools
;
;Return:
; always 't'
;
(defun EDbondtoolsOpenUserInterface ()
  (let (form cv (logfile "./bondtools.log"))

    (setq form (eval (quote EDdrawBondWires)))

    (when
      (and
        (setq cv (geGetWindowCellView))
        (equal cv~>cellViewType "maskLayout")
      );and

      (setq
        logfile
        (lsprintf
          "./bondtools_%s_%s_%s.log"
          cv~>libName
          cv~>cellName
          cv~>viewName                    
        );lsprintf
      );setq
    );when

    (putpropq 
      form~>logfile
      logfile 
      value
    );putpropq

    (hiDisplayForm (quote EDdrawBondWires))
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
  (let (form cv)

    (setq form (eval (quote EDdrawBondWires)))

    (if 
      (and
        (setq cv (geGetWindowCellView))
        (equal cv~>cellViewType "maskLayout")
        (or
          (equal cv~>mode "w")
          (equal cv~>mode "a")
        );or
      );and
    then
      (EDbondtoolsDrawWires
        cv
        form~>ballRadius~>value
        form~>bondDiameter~>value
        form~>wedgeExtionsion~>value
        (when form~>enableLogfile~>value
          form~>logfile~>value
        );when
      );EDbondtoolsDrawWires

      (when form~>enableLogfile~>value
        (hiViewTextFile form~>logfile~>value)
      );when
    else
      (error "No editable layout cellview available")
    );if

    t
  );let
);defun


;FUNCTION
; EDbondtoolsEnableLogfileCallback
;
;Description:
; Callback that is triggered when the boolean button "Enable Logfile"
; is pushed in the Draw Bondwire form
;
;Return:
; t             bool, always 't'
;
(defun EDbondtoolsEnableLogfileCallback ()
  (let (form)

    (setq form (eval (quote EDdrawBondWires)))

    (putpropq 
      form~>logfile
      form~>enableLogfile~>value 
      enabled 
    );putpropq

    t
  );let
);defun EDbondtoolsEnableLogfileCallback


(let (bondDiameter ballRadius wedgeExtionsion enableLogfile logfile formLayout)
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
    enableLogfile
    (hiCreateBooleanButton
      ?name (quote enableLogfile)
      ?buttonText "Enable Logfile"
      ?defValue nil
      ?callback "(EDbondtoolsEnableLogfileCallback)"
    );hiCreateBooleanButton
  );setq

  (setq 
    logfile
    (hiCreateFileSelectorField
      ?name (quote logfile)
      ?mode (quote anyFile)
      ?prompt "Logfile"
      ?enabled nil
      ?value ""
    );hiCreateFileSelectorField
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
          enableLogfile
          logfile
        );list
    );hiCreateFormLayout
  );setq

  (hiCreateLayoutForm
    (quote EDdrawBondWires)
    "[ED] Draw Bondwires"
    formLayout
    ?sizePolicy (quote horizontalExpanding)
    ?dialogStyle (quote modeless)
    ?buttonLayout (quote OKCancelApply)
    ?minSize 300:100
    ?callback
      (list
        "(EDbondtoolsDrawBondWiresCallback)"
        "nil"
      );list
    ;?buttonDisabled (list 'Help)
  );hiCreateLayoutForm

  (putpropq
    (quote EDdrawBondWires)
    "(hiLaunchBrowser \"https://github.com/matthschw/bondtools\")"
    hiHelpAction
  );putpropq
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
    "Bondtools" 
    (list 
      (hiCreateMenuItem
        ?name (quote EDBondtoolsMenuItem)
        ?itemText "Draw Bondwires"
        ?callback "(EDbondtoolsOpenUserInterface)" 
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
        (eval EDbondtoolsPulldownMenu)
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