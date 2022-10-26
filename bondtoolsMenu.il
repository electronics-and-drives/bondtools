/*=============================================================================*
*
*   bondtools
*
*
*   Purpose  : Create Menu in Layout Editor
*   Authors  : Matthias Schweikardt
*
*   Language : Cadence Skill
*   Lint     : IQ score is 96 (best is 100) {sklint ?file "bondtools.il"}
*  
*   Globals  :
*    - Functions :
*       o EDBondtoolsCreateLayoutPulldownMenu
*       o EDBondtoolsMenuBarPostInstallTrigger
*    - Symbols   : EDbondtoolsPulldownMenu
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