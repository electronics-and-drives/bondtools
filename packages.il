/*=============================================================================*
*
*   packages.il
*
*   Purpose:  Layout PCells of IC-Packages
*   Language: Cadence SKILL
*
*   Lint: IQ score is 100 (best is 100) {sklint ?file "packages.il"}
*
*   Author:   Matthias Schweikardt
*             (matthias.schweikardt@reutlingen-university.de)
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

(pcDefinePCell
 (list (ddGetObj "PACKAGES") "JLCC_44_PB_F86315" "layout")
 (
    (scale       float   1.0)
    (grid        float 0.025)
    (labelSize   float 150.0)
    (labelOffset int       0)
  )

  (let 
    (
      cv 
      fGetRectWithRadius 
      (cavity_in_inch 0.34) 
      (bridge_inner_in_inch 0.42)
      (bridge_outer_in_inch 0.505)

      (lead_width_in_inch 0.01)
      (lead_pitch_in_inch 0.022)
      (dist_pitch_cavity_in_inch 0.005)

      (inch_to_um 25400) 
      (radius_cavity_in_inch 0.02)
      (radius_bridge_in_inch 0.02)
      (metalization (list "PACKAGE_METALIZATION" "drawing") )
      (label (list "PACKAGE_LABEL" "label") )

      (pin_idx_l 1)
      (pin_idx_u 44)
      fDrawLead
      bridgeInnerRect
      bridgeOuterRect
    )

    (setq cv pcCellView)

    (setq 
      fGetRectWithRadius
      (lambda (x y radius grid)
        (let (points fInner)

          ;fInner
          (setq 
            fInner
            (lambda (x y radius grid)
              (let (steps points xLocal yLocal)

                ;   A-----------B
                ;  /             \
                ; B               G
                ; |               |
                ; |               |
                ; C               F
                ;  \             /
                ;   D-----------E

                (setq points (tconc nil nil))
                (setq steps (floor (quotient radius grid)))

                ;A
                (tconc
                  points
                  (list
                    (difference radius (quotient x 2))
                    (quotient y 2)
                  );list
                );tconc

                (for i 1 (sub1 steps)

                  (setq
                    xLocal
                    (minus (times grid i))
                  );setq

                  (setq
                    yLocal
                    (sqrt (difference (pow radius 2) (pow xLocal 2)))
                  );setq

                  (setq
                    xLocal
                    (plus (difference radius (quotient x 2)) xLocal)
                  );setq

                  (setq
                    yLocal
                    (plus (difference (quotient y 2) radius) yLocal)
                  );setq

                  (tconc points (list xLocal yLocal))
                );for

                ;B
                (tconc
                  points
                  (list
                    (minus (quotient x 2))
                    (difference (quotient y 2) radius)
                  );list
                );tconc
                ;C
                (tconc
                  points
                  (list
                    (minus (quotient x 2))
                    (difference radius (quotient y 2) )
                  );list
                );tconc         
                
                (for i 1 (sub1 steps)

                  (setq xLocal (times grid i))

                  (setq
                    yLocal
                    (minus (sqrt (difference (pow radius 2) (pow (difference radius xLocal) 2))))
                  );setq
                
                  (setq
                    xLocal
                    (plus (minus (quotient x 2)) xLocal)
                  );setq

                  (setq
                    yLocal
                    (plus (difference radius (quotient y 2)) yLocal)
                  );setq
                  
                  (tconc points (list xLocal yLocal))
                );for

                ;D
                (tconc
                  points
                  (list
                    (plus (minus (quotient x 2)) radius)
                    (minus (quotient y 2))
                  );list
                );tconc

                ;E
                (tconc
                  points
                  (list
                    (difference (quotient x 2) radius)
                    (minus (quotient y 2))
                  );list
                );tconc 

                (for i 1 (sub1 steps)

                  (setq xLocal (times grid i))

                  (setq
                    yLocal
                    (minus (sqrt (difference (pow radius 2) (pow xLocal 2))))
                  );setq

                  (setq
                    xLocal
                    (plus (difference (quotient x 2) radius) xLocal)
                  );setq

                  (setq
                    yLocal
                    (plus (difference radius (quotient y 2)) yLocal)
                  );setq
                  
                  (tconc points (list xLocal yLocal))
                );for 

                ;F
                (tconc
                  points
                  (list
                    (quotient x 2)
                    (difference radius (quotient y 2))
                  );list
                );tconc 
                ;G
                (tconc
                  points
                  (list
                    (quotient x 2)
                    (difference (quotient y 2) radius)
                  );list
                );tconc

                (for i 1 (sub1 steps)

                  (setq xLocal (times grid i))

                  (setq
                    yLocal
                    (sqrt (difference (pow radius 2) (pow (difference radius xLocal) 2)))
                  );setq

                  (setq
                    xLocal
                    (difference (quotient x 2)  xLocal)
                  );setq

                  (setq
                    yLocal
                    (plus (difference (quotient y 2) radius) yLocal)
                  );setq
                  
                  (tconc points (list xLocal yLocal))
                );for 

                ;H
                (tconc
                  points
                  (list
                    (difference (quotient x 2) radius)
                    (quotient y 2)
                  );list
                );tconc     
                
                (cdar points)
              );let
            );lambda
          );setq

          (setq
            points 
            (funcall
              fInner
              (times (round (quotient x grid))      grid)
              (times (round (quotient y grid))      grid)
              (times (round (quotient radius grid)) grid)
              grid
            );funcall
          );setq

          (while (geqp (length points) 4000)
            (setq grid (times grid 2))
            (setq
              points 
              (funcall
                fInner
                (times (round (quotient x grid))      grid)
                (times (round (quotient y grid))      grid)
                (times (round (quotient radius grid)) grid)
                grid
              );funcall
            );setq
          );while
          points
        );let
      );lambda
    );setq

    ;draw cavity
    (dbCreatePolygon 
      cv
      metalization 
      (funcall
        fGetRectWithRadius
        (times cavity_in_inch        inch_to_um scale)
        (times cavity_in_inch        inch_to_um scale)
        (times radius_cavity_in_inch inch_to_um scale)
        grid         
      );funcall
    );dbCreatePolygon

    ;draw outer bridge
    (setq
      bridgeOuterRect
      (dbCreateRect
        cv
        metalization
        (list
          (list
            (times (round (quotient (minus (quotient (times bridge_outer_in_inch inch_to_um scale) 2)) grid)) grid)
            (times (round (quotient (minus (quotient (times bridge_outer_in_inch inch_to_um scale) 2)) grid)) grid)
          );list
          (list
            (times (round (quotient (quotient (times bridge_outer_in_inch inch_to_um scale) 2) grid)) grid)
            (times (round (quotient (quotient (times bridge_outer_in_inch inch_to_um scale) 2) grid)) grid)
          );list  
        );list
      );dbCreateRect
    );setq

    ;draw inner bridge
    (setq
      bridgeInnerRect
      (dbCreatePolygon 
        cv
        metalization
        (funcall
          fGetRectWithRadius
          (times bridge_inner_in_inch   inch_to_um scale)
          (times bridge_inner_in_inch   inch_to_um scale)
          (times radius_bridge_in_inch  inch_to_um scale)
          grid         
        );funcall
      );dbCreatePolygon
    );setq

    ;draw bridge
    (dbLayerAndNot
      cv 
      metalization
      (list bridgeOuterRect)
      (list bridgeInnerRect)
      4000
      grid
    );dbLayerAndNot

    (dbDeleteObject bridgeOuterRect)
    (dbDeleteObject bridgeInnerRect)

    (setq 
      fDrawLead
      (lambda (cv x x1 x2 pitch width grid idx num_of_pins labelSize labelOffset)
        (let (i lead y)

          (setq
            i
            (difference
              (mod 
                (plus idx (sub1 (quotient num_of_pins 8))) 
                (quotient num_of_pins 4)
              );mod
              (quotient num_of_pins 8)
            );difference
          );setq

          (setq y (times pitch i))

          (if (onep idx) then
            (setq
              lead
              (dbCreatePolygon
                cv
                metalization
                (list
                  (list 
                    (times (round (quotient (plus (difference x1 x) width) grid)) grid)
                    (times (round (quotient (quotient width 2)             grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x1 x) grid))   grid)
                    (times (round (quotient (minus (quotient width 2)) grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x2 x)          grid)) grid)
                    (times (round (quotient (minus (quotient width 2)) grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x2 x) grid)) grid)
                    (times (round (quotient (quotient width 2) grid)) grid)
                  );list
                );list
              );dbCreateRect
            );setq
          else
            (setq
              lead
              (dbCreatePolygon
                cv
                metalization
                (list
                  (list 
                    (times (round (quotient (difference x1 x) grid)) grid)
                    (times (round (quotient (plus y (quotient width 2)) grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x1 x) grid)) grid)
                    (times (round (quotient (difference y (quotient width 2)) grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x2 x) grid)) grid)
                    (times (round (quotient (difference (quotient (times y x2) x1) (quotient width 2)) grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x2 x) grid)) grid)
                    (times (round (quotient (plus (quotient (times y x2) x1) (quotient width 2)) grid)) grid)
                  );list
                );list
              );dbCreateRect
            );setq
          );if



          (when 
            (and
              (greaterp idx (add1 (quotient num_of_pins 8)))
              (leqp idx (plus (add1 (quotient num_of_pins 8)) (quotient num_of_pins 4)))
            );and

            (dbMoveFig lead nil (list 0:0 "R90"))
          );when

          (when 
            (and
              (greaterp idx (plus (add1 (quotient num_of_pins 8)) (quotient num_of_pins 4)))
              (leqp idx (plus (add1 (quotient num_of_pins 8)) (times 2 (quotient num_of_pins 4))))
            );and

            (dbMoveFig lead nil (list 0:0 "R180"))
          );when 

          (when 
            (and
              (greaterp idx (plus (add1 (quotient num_of_pins 8)) (times 2 (quotient num_of_pins 4))))
              (leqp idx (plus (add1 (quotient num_of_pins 8)) (times 3 (quotient num_of_pins 4))))
            );and

            (dbMoveFig lead nil (list 0:0 "R270"))
          );when 

          (list
            lead
            (dbCreateLabel 
              cv 
              label
              (centerBox lead~>bBox) 
              (lsprintf 
                "%L" 
                (if (geqp labelOffset 0)
                  (add1 (mod (sub1 (plus idx labelOffset)) num_of_pins))
                  (add1 (mod (sub1 (plus idx (difference num_of_pins (abs (mod labelOffset -num_of_pins))))) num_of_pins))
                );if
              );lsprintf
              "centerCenter"
              "R0"
              "roman"
              labelSize
            );dbCreateLabel
          );list
        );let
      );lambda
    );setq

    (for idx pin_idx_l pin_idx_u
      (funcall
        fDrawLead
        cv
        (times (quotient cavity_in_inch 2) inch_to_um scale)
        (times (plus cavity_in_inch dist_pitch_cavity_in_inch) inch_to_um scale)
        (difference (times (quotient (plus cavity_in_inch bridge_inner_in_inch) 2.0) inch_to_um scale) grid)
        (times lead_pitch_in_inch inch_to_um scale)
        (times lead_width_in_inch inch_to_um scale)
        grid
        idx
        pin_idx_u
        labelSize
        labelOffset
      );funcall
    );for
  );let
);pcDefinePCell

(pcDefinePCell
 (list (ddGetObj "PACKAGES") "JLCC_68_PB_F86764" "layout")
 (
    (scale       float   1.0)
    (grid        float 0.025)
    (labelSize   float 150.0)
    (labelOffset int       0)
  )

  (let 
    (
      cv 
      fGetRectWithRadius 
      (cavity_in_inch 0.4) 
      (bridge_inner_in_inch 0.49+0.07)
      (bridge_outer_in_inch 0.624)

      (lead_width_in_inch 0.01)
      (lead_pitch_in_inch 0.022)
      (dist_pitch_cavity_in_inch 0.005)

      (inch_to_um 25400) 
      (radius_cavity_in_inch 0.02)
      (radius_bridge_in_inch 0.02)
      (metalization (list "PACKAGE_METALIZATION" "drawing") )
      (label (list "PACKAGE_LABEL" "label") )

      (pin_idx_l 1)
      (pin_idx_u 68)
      fDrawLead
      bridgeInnerRect
      bridgeOuterRect
    )

    (setq cv pcCellView)

    (setq 
      fGetRectWithRadius
      (lambda (x y radius grid)
        (let (points fInner)

          ;fInner
          (setq 
            fInner
            (lambda (x y radius grid)
              (let (steps points xLocal yLocal)

                ;   A-----------B
                ;  /             \
                ; B               G
                ; |               |
                ; |               |
                ; C               F
                ;  \             /
                ;   D-----------E

                (setq points (tconc nil nil))
                (setq steps (floor (quotient radius grid)))

                ;A
                (tconc
                  points
                  (list
                    (difference radius (quotient x 2))
                    (quotient y 2)
                  );list
                );tconc

                (for i 1 (sub1 steps)

                  (setq
                    xLocal
                    (minus (times grid i))
                  );setq

                  (setq
                    yLocal
                    (sqrt (difference (pow radius 2) (pow xLocal 2)))
                  );setq

                  (setq
                    xLocal
                    (plus (difference radius (quotient x 2)) xLocal)
                  );setq

                  (setq
                    yLocal
                    (plus (difference (quotient y 2) radius) yLocal)
                  );setq

                  (tconc points (list xLocal yLocal))
                );for

                ;B
                (tconc
                  points
                  (list
                    (minus (quotient x 2))
                    (difference (quotient y 2) radius)
                  );list
                );tconc
                ;C
                (tconc
                  points
                  (list
                    (minus (quotient x 2))
                    (difference radius (quotient y 2) )
                  );list
                );tconc         
                
                (for i 1 (sub1 steps)

                  (setq xLocal (times grid i))

                  (setq
                    yLocal
                    (minus (sqrt (difference (pow radius 2) (pow (difference radius xLocal) 2))))
                  );setq
                
                  (setq
                    xLocal
                    (plus (minus (quotient x 2)) xLocal)
                  );setq

                  (setq
                    yLocal
                    (plus (difference radius (quotient y 2)) yLocal)
                  );setq
                  
                  (tconc points (list xLocal yLocal))
                );for

                ;D
                (tconc
                  points
                  (list
                    (plus (minus (quotient x 2)) radius)
                    (minus (quotient y 2))
                  );list
                );tconc

                ;E
                (tconc
                  points
                  (list
                    (difference (quotient x 2) radius)
                    (minus (quotient y 2))
                  );list
                );tconc 

                (for i 1 (sub1 steps)

                  (setq xLocal (times grid i))

                  (setq
                    yLocal
                    (minus (sqrt (difference (pow radius 2) (pow xLocal 2))))
                  );setq

                  (setq
                    xLocal
                    (plus (difference (quotient x 2) radius) xLocal)
                  );setq

                  (setq
                    yLocal
                    (plus (difference radius (quotient y 2)) yLocal)
                  );setq
                  
                  (tconc points (list xLocal yLocal))
                );for 

                ;F
                (tconc
                  points
                  (list
                    (quotient x 2)
                    (difference radius (quotient y 2))
                  );list
                );tconc 
                ;G
                (tconc
                  points
                  (list
                    (quotient x 2)
                    (difference (quotient y 2) radius)
                  );list
                );tconc

                (for i 1 (sub1 steps)

                  (setq xLocal (times grid i))

                  (setq
                    yLocal
                    (sqrt (difference (pow radius 2) (pow (difference radius xLocal) 2)))
                  );setq

                  (setq
                    xLocal
                    (difference (quotient x 2)  xLocal)
                  );setq

                  (setq
                    yLocal
                    (plus (difference (quotient y 2) radius) yLocal)
                  );setq
                  
                  (tconc points (list xLocal yLocal))
                );for 

                ;H
                (tconc
                  points
                  (list
                    (difference (quotient x 2) radius)
                    (quotient y 2)
                  );list
                );tconc     
                
                (cdar points)
              );let
            );lambda
          );setq

          (setq
            points 
            (funcall
              fInner
              (times (round (quotient x grid))      grid)
              (times (round (quotient y grid))      grid)
              (times (round (quotient radius grid)) grid)
              grid
            );funcall
          );setq

          (while (geqp (length points) 4000)
            (setq grid (times grid 2))
            (setq
              points 
              (funcall
                fInner
                (times (round (quotient x grid))      grid)
                (times (round (quotient y grid))      grid)
                (times (round (quotient radius grid)) grid)
                grid
              );funcall
            );setq
          );while
          points
        );let
      );lambda
    );setq

    ;draw cavity
    (dbCreatePolygon 
      cv
      metalization 
      (funcall
        fGetRectWithRadius
        (times cavity_in_inch        inch_to_um scale)
        (times cavity_in_inch        inch_to_um scale)
        (times radius_cavity_in_inch inch_to_um scale)
        grid         
      );funcall
    );dbCreatePolygon

    ;draw outer bridge
    (setq
      bridgeOuterRect
      (dbCreateRect
        cv
        metalization
        (list
          (list
            (times (round (quotient (minus (quotient (times bridge_outer_in_inch inch_to_um scale) 2)) grid)) grid)
            (times (round (quotient (minus (quotient (times bridge_outer_in_inch inch_to_um scale) 2)) grid)) grid)
          );list
          (list
            (times (round (quotient (quotient (times bridge_outer_in_inch inch_to_um scale) 2) grid)) grid)
            (times (round (quotient (quotient (times bridge_outer_in_inch inch_to_um scale) 2) grid)) grid)
          );list  
        );list
      );dbCreateRect
    );setq

    ;draw inner bridge
    (setq
      bridgeInnerRect
      (dbCreatePolygon 
        cv
        metalization
        (funcall
          fGetRectWithRadius
          (times bridge_inner_in_inch   inch_to_um scale)
          (times bridge_inner_in_inch   inch_to_um scale)
          (times radius_bridge_in_inch  inch_to_um scale)
          grid         
        );funcall
      );dbCreatePolygon
    );setq

    ;draw bridge
    (dbLayerAndNot
      cv 
      metalization
      (list bridgeOuterRect)
      (list bridgeInnerRect)
      4000
      grid
    );dbLayerAndNot

    (dbDeleteObject bridgeOuterRect)
    (dbDeleteObject bridgeInnerRect)

    (setq 
      fDrawLead
      (lambda (cv x x1 x2 pitch width grid idx num_of_pins labelSize labelOffset)
        (let (i lead y)

          (setq
            i
            (difference
              (mod 
                (plus idx (sub1 (quotient num_of_pins 8))) 
                (quotient num_of_pins 4)
              );mod
              (quotient num_of_pins 8)
            );difference
          );setq

          (setq y (times pitch i))

          (if (onep idx) then
            (setq
              lead
              (dbCreatePolygon
                cv
                metalization
                (list
                  (list 
                    (times (round (quotient (plus (difference x1 x) width) grid)) grid)
                    (times (round (quotient (quotient width 2)             grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x1 x) grid))   grid)
                    (times (round (quotient (minus (quotient width 2)) grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x2 x)          grid)) grid)
                    (times (round (quotient (minus (quotient width 2)) grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x2 x) grid)) grid)
                    (times (round (quotient (quotient width 2) grid)) grid)
                  );list
                );list
              );dbCreateRect
            );setq
          else
            (setq
              lead
              (dbCreatePolygon
                cv
                metalization
                (list
                  (list 
                    (times (round (quotient (difference x1 x) grid)) grid)
                    (times (round (quotient (plus y (quotient width 2)) grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x1 x) grid)) grid)
                    (times (round (quotient (difference y (quotient width 2)) grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x2 x) grid)) grid)
                    (times (round (quotient (difference (quotient (times y x2) x1) (quotient width 2)) grid)) grid)
                  );list
                  (list 
                    (times (round (quotient (difference x2 x) grid)) grid)
                    (times (round (quotient (plus (quotient (times y x2) x1) (quotient width 2)) grid)) grid)
                  );list
                );list
              );dbCreateRect
            );setq
          );if



          (when 
            (and
              (greaterp idx (add1 (quotient num_of_pins 8)))
              (leqp idx (plus (add1 (quotient num_of_pins 8)) (quotient num_of_pins 4)))
            );and

            (dbMoveFig lead nil (list 0:0 "R90"))
          );when

          (when 
            (and
              (greaterp idx (plus (add1 (quotient num_of_pins 8)) (quotient num_of_pins 4)))
              (leqp idx (plus (add1 (quotient num_of_pins 8)) (times 2 (quotient num_of_pins 4))))
            );and

            (dbMoveFig lead nil (list 0:0 "R180"))
          );when 

          (when 
            (and
              (greaterp idx (plus (add1 (quotient num_of_pins 8)) (times 2 (quotient num_of_pins 4))))
              (leqp idx (plus (add1 (quotient num_of_pins 8)) (times 3 (quotient num_of_pins 4))))
            );and

            (dbMoveFig lead nil (list 0:0 "R270"))
          );when 

          (list
            lead
            (dbCreateLabel 
              cv 
              label
              (centerBox lead~>bBox) 
              (lsprintf 
                "%L" 
                (if (geqp labelOffset 0)
                  (add1 (mod (sub1 (plus idx labelOffset)) num_of_pins))
                  (add1 (mod (sub1 (plus idx (difference num_of_pins (abs (mod labelOffset -num_of_pins))))) num_of_pins))
                );if
              );lsprintf
              "centerCenter"
              "R0"
              "roman"
              labelSize
            );dbCreateLabel
          );list
        );let
      );lambda
    );setq

    (for idx pin_idx_l pin_idx_u
      (funcall
        fDrawLead
        cv
        (times (quotient cavity_in_inch 2) inch_to_um scale)
        (times (plus cavity_in_inch dist_pitch_cavity_in_inch) inch_to_um scale)
        (difference (times (quotient (plus cavity_in_inch bridge_inner_in_inch) 2.0) inch_to_um scale) grid)
        (times lead_pitch_in_inch inch_to_um scale)
        (times lead_width_in_inch inch_to_um scale)
        grid
        idx
        pin_idx_u
        labelSize
        labelOffset
      );funcall
    );for
  );let
);pcDefinePCell


(let (cv label)

  cv = dbOpenCellViewByType("PACKAGES" "ED60_V1" "layout"
                          "maskLayout" "w")
  cv~>DBUPerUU = 1000.000000

  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:-1.195075e+03 -2.700975e+03:-1.185300e+03 
         -2.702875e+03:-1.175675e+03 -2.705725e+03:-1.166275e+03 
         -2.709500e+03:-1.157200e+03 -2.714125e+03:-1.148525e+03 
         -2.719575e+03:-1.140350e+03 -2.725825e+03:-1.132775e+03 
         -2.732775e+03:-1.125825e+03 -2.740350e+03:-1.119575e+03 
         -2.748525e+03:-1.114125e+03 -2.757200e+03:-1.109500e+03 
         -2.766275e+03:-1.105725e+03 -2.775675e+03:-1.102875e+03 
         -2.785300e+03:-1.100975e+03 -2.795075e+03:-1.100000e+03 
         -3.700000e+03:-1.100000e+03 -3.700000e+03:-1.300000e+03 
         -2.795075e+03:-1.300000e+03 -2.785300e+03:-1.299025e+03 
         -2.775675e+03:-1.297125e+03 -2.766275e+03:-1.294275e+03 
         -2.757200e+03:-1.290500e+03 -2.748525e+03:-1.285875e+03 
         -2.740350e+03:-1.280425e+03 -2.732775e+03:-1.274175e+03 
         -2.725825e+03:-1.267225e+03 -2.719575e+03:-1.259650e+03 
         -2.714125e+03:-1.251475e+03 -2.709500e+03:-1.242800e+03 
         -2.705725e+03:-1.233725e+03 -2.702875e+03:-1.224325e+03 
         -2.700975e+03:-1.214700e+03 -2.700000e+03:-1.204925e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:9.049250e+02 -2.700975e+03:9.147000e+02 
         -2.702875e+03:9.243250e+02 -2.705725e+03:9.337250e+02 
         -2.709500e+03:9.428000e+02 -2.714125e+03:9.514750e+02 
         -2.719575e+03:9.596500e+02 -2.725825e+03:9.672250e+02 
         -2.732775e+03:9.741750e+02 -2.740350e+03:9.804250e+02 
         -2.748525e+03:9.858750e+02 -2.757200e+03:9.905000e+02 
         -2.766275e+03:9.942750e+02 -2.775675e+03:9.971250e+02 
         -2.785300e+03:9.990250e+02 -2.795075e+03:1.000000e+03 
         -3.700000e+03:1.000000e+03 -3.700000e+03:8.000000e+02 
         -2.795075e+03:8.000000e+02 -2.785300e+03:8.009750e+02 
         -2.775675e+03:8.028750e+02 -2.766275e+03:8.057250e+02 
         -2.757200e+03:8.095000e+02 -2.748525e+03:8.141250e+02 
         -2.740350e+03:8.195750e+02 -2.732775e+03:8.258250e+02 
         -2.725825e+03:8.327750e+02 -2.719575e+03:8.403500e+02 
         -2.714125e+03:8.485250e+02 -2.709500e+03:8.572000e+02 
         -2.705725e+03:8.662750e+02 -2.702875e+03:8.756750e+02 
         -2.700975e+03:8.853000e+02 -2.700000e+03:8.950750e+02))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:6.049250e+02 -2.700975e+03:6.147000e+02 
         -2.702875e+03:6.243250e+02 -2.705725e+03:6.337250e+02 
         -2.709500e+03:6.428000e+02 -2.714125e+03:6.514750e+02 
         -2.719575e+03:6.596500e+02 -2.725825e+03:6.672250e+02 
         -2.732775e+03:6.741750e+02 -2.740350e+03:6.804250e+02 
         -2.748525e+03:6.858750e+02 -2.757200e+03:6.905000e+02 
         -2.766275e+03:6.942750e+02 -2.775675e+03:6.971250e+02 
         -2.785300e+03:6.990250e+02 -2.795075e+03:7.000000e+02 
         -3.700000e+03:7.000000e+02 -3.700000e+03:5.000000e+02 
         -2.795075e+03:5.000000e+02 -2.785300e+03:5.009750e+02 
         -2.775675e+03:5.028750e+02 -2.766275e+03:5.057250e+02 
         -2.757200e+03:5.095000e+02 -2.748525e+03:5.141250e+02 
         -2.740350e+03:5.195750e+02 -2.732775e+03:5.258250e+02 
         -2.725825e+03:5.327750e+02 -2.719575e+03:5.403500e+02 
         -2.714125e+03:5.485250e+02 -2.709500e+03:5.572000e+02 
         -2.705725e+03:5.662750e+02 -2.702875e+03:5.756750e+02 
         -2.700975e+03:5.853000e+02 -2.700000e+03:5.950750e+02))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:4.925000e+00 -2.700975e+03:1.470000e+01 
         -2.702875e+03:2.432500e+01 -2.705725e+03:3.372500e+01 
         -2.709500e+03:4.280000e+01 -2.714125e+03:5.147500e+01 
         -2.719575e+03:5.965000e+01 -2.725825e+03:6.722500e+01 
         -2.732775e+03:7.417500e+01 -2.740350e+03:8.042500e+01 
         -2.748525e+03:8.587500e+01 -2.757200e+03:9.050000e+01 
         -2.766275e+03:9.427500e+01 -2.775675e+03:9.712500e+01 
         -2.785300e+03:9.902500e+01 -2.795075e+03:1.000000e+02 
         -3.700000e+03:1.000000e+02 -3.700000e+03:-1.000000e+02 
         -2.795075e+03:-1.000000e+02 -2.785300e+03:-9.902500e+01 
         -2.775675e+03:-9.712500e+01 -2.766275e+03:-9.427500e+01 
         -2.757200e+03:-9.050000e+01 -2.748525e+03:-8.587500e+01 
         -2.740350e+03:-8.042500e+01 -2.732775e+03:-7.417500e+01 
         -2.725825e+03:-6.722500e+01 -2.719575e+03:-5.965000e+01 
         -2.714125e+03:-5.147500e+01 -2.709500e+03:-4.280000e+01 
         -2.705725e+03:-3.372500e+01 -2.702875e+03:-2.432500e+01 
         -2.700975e+03:-1.470000e+01 -2.700000e+03:-4.925000e+00))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:-2.950750e+02 -2.700975e+03:-2.853000e+02 
         -2.702875e+03:-2.756750e+02 -2.705725e+03:-2.662750e+02 
         -2.709500e+03:-2.572000e+02 -2.714125e+03:-2.485250e+02 
         -2.719575e+03:-2.403500e+02 -2.725825e+03:-2.327750e+02 
         -2.732775e+03:-2.258250e+02 -2.740350e+03:-2.195750e+02 
         -2.748525e+03:-2.141250e+02 -2.757200e+03:-2.095000e+02 
         -2.766275e+03:-2.057250e+02 -2.775675e+03:-2.028750e+02 
         -2.785300e+03:-2.009750e+02 -2.795075e+03:-2.000000e+02 
         -3.700000e+03:-2.000000e+02 -3.700000e+03:-4.000000e+02 
         -2.795075e+03:-4.000000e+02 -2.785300e+03:-3.990250e+02 
         -2.775675e+03:-3.971250e+02 -2.766275e+03:-3.942750e+02 
         -2.757200e+03:-3.905000e+02 -2.748525e+03:-3.858750e+02 
         -2.740350e+03:-3.804250e+02 -2.732775e+03:-3.741750e+02 
         -2.725825e+03:-3.672250e+02 -2.719575e+03:-3.596500e+02 
         -2.714125e+03:-3.514750e+02 -2.709500e+03:-3.428000e+02 
         -2.705725e+03:-3.337250e+02 -2.702875e+03:-3.243250e+02 
         -2.700975e+03:-3.147000e+02 -2.700000e+03:-3.049250e+02))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:-1.495075e+03 -2.700975e+03:-1.485300e+03 
         -2.702875e+03:-1.475675e+03 -2.705725e+03:-1.466275e+03 
         -2.709500e+03:-1.457200e+03 -2.714125e+03:-1.448525e+03 
         -2.719575e+03:-1.440350e+03 -2.725825e+03:-1.432775e+03 
         -2.732775e+03:-1.425825e+03 -2.740350e+03:-1.419575e+03 
         -2.748525e+03:-1.414125e+03 -2.757200e+03:-1.409500e+03 
         -2.766275e+03:-1.405725e+03 -2.775675e+03:-1.402875e+03 
         -2.785300e+03:-1.400975e+03 -2.795075e+03:-1.400000e+03 
         -3.700000e+03:-1.400000e+03 -3.700000e+03:-1.600000e+03 
         -2.795075e+03:-1.600000e+03 -2.785300e+03:-1.599025e+03 
         -2.775675e+03:-1.597125e+03 -2.766275e+03:-1.594275e+03 
         -2.757200e+03:-1.590500e+03 -2.748525e+03:-1.585875e+03 
         -2.740350e+03:-1.580425e+03 -2.732775e+03:-1.574175e+03 
         -2.725825e+03:-1.567225e+03 -2.719575e+03:-1.559650e+03 
         -2.714125e+03:-1.551475e+03 -2.709500e+03:-1.542800e+03 
         -2.705725e+03:-1.533725e+03 -2.702875e+03:-1.524325e+03 
         -2.700975e+03:-1.514700e+03 -2.700000e+03:-1.504925e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:-8.950750e+02 -2.700975e+03:-8.853000e+02 
         -2.702875e+03:-8.756750e+02 -2.705725e+03:-8.662750e+02 
         -2.709500e+03:-8.572000e+02 -2.714125e+03:-8.485250e+02 
         -2.719575e+03:-8.403500e+02 -2.725825e+03:-8.327750e+02 
         -2.732775e+03:-8.258250e+02 -2.740350e+03:-8.195750e+02 
         -2.748525e+03:-8.141250e+02 -2.757200e+03:-8.095000e+02 
         -2.766275e+03:-8.057250e+02 -2.775675e+03:-8.028750e+02 
         -2.785300e+03:-8.009750e+02 -2.795075e+03:-8.000000e+02 
         -3.700000e+03:-8.000000e+02 -3.700000e+03:-1.000000e+03 
         -2.795075e+03:-1.000000e+03 -2.785300e+03:-9.990250e+02 
         -2.775675e+03:-9.971250e+02 -2.766275e+03:-9.942750e+02 
         -2.757200e+03:-9.905000e+02 -2.748525e+03:-9.858750e+02 
         -2.740350e+03:-9.804250e+02 -2.732775e+03:-9.741750e+02 
         -2.725825e+03:-9.672250e+02 -2.719575e+03:-9.596500e+02 
         -2.714125e+03:-9.514750e+02 -2.709500e+03:-9.428000e+02 
         -2.705725e+03:-9.337250e+02 -2.702875e+03:-9.243250e+02 
         -2.700975e+03:-9.147000e+02 -2.700000e+03:-9.049250e+02))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:-5.950750e+02 -2.700975e+03:-5.853000e+02 
         -2.702875e+03:-5.756750e+02 -2.705725e+03:-5.662750e+02 
         -2.709500e+03:-5.572000e+02 -2.714125e+03:-5.485250e+02 
         -2.719575e+03:-5.403500e+02 -2.725825e+03:-5.327750e+02 
         -2.732775e+03:-5.258250e+02 -2.740350e+03:-5.195750e+02 
         -2.748525e+03:-5.141250e+02 -2.757200e+03:-5.095000e+02 
         -2.766275e+03:-5.057250e+02 -2.775675e+03:-5.028750e+02 
         -2.785300e+03:-5.009750e+02 -2.795075e+03:-5.000000e+02 
         -3.700000e+03:-5.000000e+02 -3.700000e+03:-7.000000e+02 
         -2.795075e+03:-7.000000e+02 -2.785300e+03:-6.990250e+02 
         -2.775675e+03:-6.971250e+02 -2.766275e+03:-6.942750e+02 
         -2.757200e+03:-6.905000e+02 -2.748525e+03:-6.858750e+02 
         -2.740350e+03:-6.804250e+02 -2.732775e+03:-6.741750e+02 
         -2.725825e+03:-6.672250e+02 -2.719575e+03:-6.596500e+02 
         -2.714125e+03:-6.514750e+02 -2.709500e+03:-6.428000e+02 
         -2.705725e+03:-6.337250e+02 -2.702875e+03:-6.243250e+02 
         -2.700975e+03:-6.147000e+02 -2.700000e+03:-6.049250e+02))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:-1.795075e+03 -2.700975e+03:-1.785300e+03 
         -2.702875e+03:-1.775675e+03 -2.705725e+03:-1.766275e+03 
         -2.709500e+03:-1.757200e+03 -2.714125e+03:-1.748525e+03 
         -2.719575e+03:-1.740350e+03 -2.725825e+03:-1.732775e+03 
         -2.732775e+03:-1.725825e+03 -2.740350e+03:-1.719575e+03 
         -2.748525e+03:-1.714125e+03 -2.757200e+03:-1.709500e+03 
         -2.766275e+03:-1.705725e+03 -2.775675e+03:-1.702875e+03 
         -2.785300e+03:-1.700975e+03 -2.795075e+03:-1.700000e+03 
         -3.700000e+03:-1.700000e+03 -3.700000e+03:-1.900000e+03 
         -2.795075e+03:-1.900000e+03 -2.785300e+03:-1.899025e+03 
         -2.775675e+03:-1.897125e+03 -2.766275e+03:-1.894275e+03 
         -2.757200e+03:-1.890500e+03 -2.748525e+03:-1.885875e+03 
         -2.740350e+03:-1.880425e+03 -2.732775e+03:-1.874175e+03 
         -2.725825e+03:-1.867225e+03 -2.719575e+03:-1.859650e+03 
         -2.714125e+03:-1.851475e+03 -2.709500e+03:-1.842800e+03 
         -2.705725e+03:-1.833725e+03 -2.702875e+03:-1.824325e+03 
         -2.700975e+03:-1.814700e+03 -2.700000e+03:-1.804925e+03))
  dbCreatePolygon(cv list(133 -1)
    list(1.000000e+03:-2.795075e+03 9.990250e+02:-2.785300e+03 
         9.971250e+02:-2.775675e+03 9.942750e+02:-2.766275e+03 
         9.905000e+02:-2.757200e+03 9.858750e+02:-2.748525e+03 
         9.804250e+02:-2.740350e+03 9.741750e+02:-2.732775e+03 
         9.672250e+02:-2.725825e+03 9.596500e+02:-2.719575e+03 
         9.514750e+02:-2.714125e+03 9.428000e+02:-2.709500e+03 
         9.337250e+02:-2.705725e+03 9.243250e+02:-2.702875e+03 
         9.147000e+02:-2.700975e+03 9.049250e+02:-2.700000e+03 
         8.950750e+02:-2.700000e+03 8.853000e+02:-2.700975e+03 
         8.756750e+02:-2.702875e+03 8.662750e+02:-2.705725e+03 
         8.572000e+02:-2.709500e+03 8.485250e+02:-2.714125e+03 
         8.403500e+02:-2.719575e+03 8.327750e+02:-2.725825e+03 
         8.258250e+02:-2.732775e+03 8.195750e+02:-2.740350e+03 
         8.141250e+02:-2.748525e+03 8.095000e+02:-2.757200e+03 
         8.057250e+02:-2.766275e+03 8.028750e+02:-2.775675e+03 
         8.009750e+02:-2.785300e+03 8.000000e+02:-2.795075e+03 
         8.000000e+02:-3.700000e+03 1.000000e+03:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-1.400000e+03:3.700000e+03 -1.600000e+03:3.700000e+03 
         -1.600000e+03:2.795075e+03 -1.599025e+03:2.785300e+03 
         -1.597125e+03:2.775675e+03 -1.594275e+03:2.766275e+03 
         -1.590500e+03:2.757200e+03 -1.585875e+03:2.748525e+03 
         -1.580425e+03:2.740350e+03 -1.574175e+03:2.732775e+03 
         -1.567225e+03:2.725825e+03 -1.559650e+03:2.719575e+03 
         -1.551475e+03:2.714125e+03 -1.542800e+03:2.709500e+03 
         -1.533725e+03:2.705725e+03 -1.524325e+03:2.702875e+03 
         -1.514700e+03:2.700975e+03 -1.504925e+03:2.700000e+03 
         -1.495075e+03:2.700000e+03 -1.485300e+03:2.700975e+03 
         -1.475675e+03:2.702875e+03 -1.466275e+03:2.705725e+03 
         -1.457200e+03:2.709500e+03 -1.448525e+03:2.714125e+03 
         -1.440350e+03:2.719575e+03 -1.432775e+03:2.725825e+03 
         -1.425825e+03:2.732775e+03 -1.419575e+03:2.740350e+03 
         -1.414125e+03:2.748525e+03 -1.409500e+03:2.757200e+03 
         -1.405725e+03:2.766275e+03 -1.402875e+03:2.775675e+03 
         -1.400975e+03:2.785300e+03 -1.400000e+03:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(1.300000e+03:-2.795075e+03 1.299025e+03:-2.785300e+03 
         1.297125e+03:-2.775675e+03 1.294275e+03:-2.766275e+03 
         1.290500e+03:-2.757200e+03 1.285875e+03:-2.748525e+03 
         1.280425e+03:-2.740350e+03 1.274175e+03:-2.732775e+03 
         1.267225e+03:-2.725825e+03 1.259650e+03:-2.719575e+03 
         1.251475e+03:-2.714125e+03 1.242800e+03:-2.709500e+03 
         1.233725e+03:-2.705725e+03 1.224325e+03:-2.702875e+03 
         1.214700e+03:-2.700975e+03 1.204925e+03:-2.700000e+03 
         1.195075e+03:-2.700000e+03 1.185300e+03:-2.700975e+03 
         1.175675e+03:-2.702875e+03 1.166275e+03:-2.705725e+03 
         1.157200e+03:-2.709500e+03 1.148525e+03:-2.714125e+03 
         1.140350e+03:-2.719575e+03 1.132775e+03:-2.725825e+03 
         1.125825e+03:-2.732775e+03 1.119575e+03:-2.740350e+03 
         1.114125e+03:-2.748525e+03 1.109500e+03:-2.757200e+03 
         1.105725e+03:-2.766275e+03 1.102875e+03:-2.775675e+03 
         1.100975e+03:-2.785300e+03 1.100000e+03:-2.795075e+03 
         1.100000e+03:-3.700000e+03 1.300000e+03:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:-2.000000e+03 2.695075e+03:-2.000000e+03 
         2.685300e+03:-2.000975e+03 2.675675e+03:-2.002875e+03 
         2.666275e+03:-2.005725e+03 2.657200e+03:-2.009500e+03 
         2.648525e+03:-2.014125e+03 2.640350e+03:-2.019575e+03 
         2.632775e+03:-2.025825e+03 2.625825e+03:-2.032775e+03 
         2.619575e+03:-2.040350e+03 2.614125e+03:-2.048525e+03 
         2.609500e+03:-2.057200e+03 2.605725e+03:-2.066275e+03 
         2.602875e+03:-2.075675e+03 2.600975e+03:-2.085300e+03 
         2.600000e+03:-2.095075e+03 2.600000e+03:-2.104925e+03 
         2.600975e+03:-2.114700e+03 2.602875e+03:-2.124325e+03 
         2.605725e+03:-2.133725e+03 2.609500e+03:-2.142800e+03 
         2.614125e+03:-2.151475e+03 2.619575e+03:-2.159650e+03 
         2.625825e+03:-2.167225e+03 2.632775e+03:-2.174175e+03 
         2.640350e+03:-2.180425e+03 2.648525e+03:-2.185875e+03 
         2.657200e+03:-2.190500e+03 2.666275e+03:-2.194275e+03 
         2.675675e+03:-2.197125e+03 2.685300e+03:-2.199025e+03 
         2.695075e+03:-2.200000e+03 3.618946e+03:-2.200000e+03 
         3.670875e+03:-2.217600e+03 3.700000e+03:-2.231249e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:1.000000e+03 2.795075e+03:1.000000e+03 
         2.785300e+03:9.990250e+02 2.775675e+03:9.971250e+02 
         2.766275e+03:9.942750e+02 2.757200e+03:9.905000e+02 
         2.748525e+03:9.858750e+02 2.740350e+03:9.804250e+02 
         2.732775e+03:9.741750e+02 2.725825e+03:9.672250e+02 
         2.719575e+03:9.596500e+02 2.714125e+03:9.514750e+02 
         2.709500e+03:9.428000e+02 2.705725e+03:9.337250e+02 
         2.702875e+03:9.243250e+02 2.700975e+03:9.147000e+02 
         2.700000e+03:9.049250e+02 2.700000e+03:8.950750e+02 
         2.700975e+03:8.853000e+02 2.702875e+03:8.756750e+02 
         2.705725e+03:8.662750e+02 2.709500e+03:8.572000e+02 
         2.714125e+03:8.485250e+02 2.719575e+03:8.403500e+02 
         2.725825e+03:8.327750e+02 2.732775e+03:8.258250e+02 
         2.740350e+03:8.195750e+02 2.748525e+03:8.141250e+02 
         2.757200e+03:8.095000e+02 2.766275e+03:8.057250e+02 
         2.775675e+03:8.028750e+02 2.785300e+03:8.009750e+02 
         2.795075e+03:8.000000e+02 3.700000e+03:8.000000e+02))
  dbCreatePolygon(cv list(133 -1)
    list(-1.700000e+03:-2.795075e+03 -1.700975e+03:-2.785300e+03 
         -1.702875e+03:-2.775675e+03 -1.705725e+03:-2.766275e+03 
         -1.709500e+03:-2.757200e+03 -1.714125e+03:-2.748525e+03 
         -1.719575e+03:-2.740350e+03 -1.725825e+03:-2.732775e+03 
         -1.732775e+03:-2.725825e+03 -1.740350e+03:-2.719575e+03 
         -1.748525e+03:-2.714125e+03 -1.757200e+03:-2.709500e+03 
         -1.766275e+03:-2.705725e+03 -1.775675e+03:-2.702875e+03 
         -1.785300e+03:-2.700975e+03 -1.795075e+03:-2.700000e+03 
         -1.804925e+03:-2.700000e+03 -1.814700e+03:-2.700975e+03 
         -1.824325e+03:-2.702875e+03 -1.833725e+03:-2.705725e+03 
         -1.842800e+03:-2.709500e+03 -1.851475e+03:-2.714125e+03 
         -1.859650e+03:-2.719575e+03 -1.867225e+03:-2.725825e+03 
         -1.874175e+03:-2.732775e+03 -1.880425e+03:-2.740350e+03 
         -1.885875e+03:-2.748525e+03 -1.890500e+03:-2.757200e+03 
         -1.894275e+03:-2.766275e+03 -1.897125e+03:-2.775675e+03 
         -1.899025e+03:-2.785300e+03 -1.900000e+03:-2.795075e+03 
         -1.900000e+03:-3.700000e+03 -1.700000e+03:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-8.000000e+02:-2.795075e+03 -8.009750e+02:-2.785300e+03 
         -8.028750e+02:-2.775675e+03 -8.057250e+02:-2.766275e+03 
         -8.095000e+02:-2.757200e+03 -8.141250e+02:-2.748525e+03 
         -8.195750e+02:-2.740350e+03 -8.258250e+02:-2.732775e+03 
         -8.327750e+02:-2.725825e+03 -8.403500e+02:-2.719575e+03 
         -8.485250e+02:-2.714125e+03 -8.572000e+02:-2.709500e+03 
         -8.662750e+02:-2.705725e+03 -8.756750e+02:-2.702875e+03 
         -8.853000e+02:-2.700975e+03 -8.950750e+02:-2.700000e+03 
         -9.049250e+02:-2.700000e+03 -9.147000e+02:-2.700975e+03 
         -9.243250e+02:-2.702875e+03 -9.337250e+02:-2.705725e+03 
         -9.428000e+02:-2.709500e+03 -9.514750e+02:-2.714125e+03 
         -9.596500e+02:-2.719575e+03 -9.672250e+02:-2.725825e+03 
         -9.741750e+02:-2.732775e+03 -9.804250e+02:-2.740350e+03 
         -9.858750e+02:-2.748525e+03 -9.905000e+02:-2.757200e+03 
         -9.942750e+02:-2.766275e+03 -9.971250e+02:-2.775675e+03 
         -9.990250e+02:-2.785300e+03 -1.000000e+03:-2.795075e+03 
         -1.000000e+03:-3.700000e+03 -8.000000e+02:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-1.100000e+03:3.700000e+03 -1.300000e+03:3.700000e+03 
         -1.300000e+03:2.795075e+03 -1.299025e+03:2.785300e+03 
         -1.297125e+03:2.775675e+03 -1.294275e+03:2.766275e+03 
         -1.290500e+03:2.757200e+03 -1.285875e+03:2.748525e+03 
         -1.280425e+03:2.740350e+03 -1.274175e+03:2.732775e+03 
         -1.267225e+03:2.725825e+03 -1.259650e+03:2.719575e+03 
         -1.251475e+03:2.714125e+03 -1.242800e+03:2.709500e+03 
         -1.233725e+03:2.705725e+03 -1.224325e+03:2.702875e+03 
         -1.214700e+03:2.700975e+03 -1.204925e+03:2.700000e+03 
         -1.195075e+03:2.700000e+03 -1.185300e+03:2.700975e+03 
         -1.175675e+03:2.702875e+03 -1.166275e+03:2.705725e+03 
         -1.157200e+03:2.709500e+03 -1.148525e+03:2.714125e+03 
         -1.140350e+03:2.719575e+03 -1.132775e+03:2.725825e+03 
         -1.125825e+03:2.732775e+03 -1.119575e+03:2.740350e+03 
         -1.114125e+03:2.748525e+03 -1.109500e+03:2.757200e+03 
         -1.105725e+03:2.766275e+03 -1.102875e+03:2.775675e+03 
         -1.100975e+03:2.785300e+03 -1.100000e+03:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.000000e+03:3.700000e+03 -2.225866e+03:3.700000e+03 
         -2.211350e+03:3.664625e+03 -2.200000e+03:3.625045e+03 
         -2.200000e+03:2.695075e+03 -2.199025e+03:2.685300e+03 
         -2.197125e+03:2.675675e+03 -2.194275e+03:2.666275e+03 
         -2.190500e+03:2.657200e+03 -2.185875e+03:2.648525e+03 
         -2.180425e+03:2.640350e+03 -2.174175e+03:2.632775e+03 
         -2.167225e+03:2.625825e+03 -2.159650e+03:2.619575e+03 
         -2.151475e+03:2.614125e+03 -2.142800e+03:2.609500e+03 
         -2.133725e+03:2.605725e+03 -2.124325e+03:2.602875e+03 
         -2.114700e+03:2.600975e+03 -2.104925e+03:2.600000e+03 
         -2.095075e+03:2.600000e+03 -2.085300e+03:2.600975e+03 
         -2.075675e+03:2.602875e+03 -2.066275e+03:2.605725e+03 
         -2.057200e+03:2.609500e+03 -2.048525e+03:2.614125e+03 
         -2.040350e+03:2.619575e+03 -2.032775e+03:2.625825e+03 
         -2.025825e+03:2.632775e+03 -2.019575e+03:2.640350e+03 
         -2.014125e+03:2.648525e+03 -2.009500e+03:2.657200e+03 
         -2.005725e+03:2.666275e+03 -2.002875e+03:2.675675e+03 
         -2.000975e+03:2.685300e+03 -2.000000e+03:2.695075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-1.400000e+03:-2.795075e+03 -1.400975e+03:-2.785300e+03 
         -1.402875e+03:-2.775675e+03 -1.405725e+03:-2.766275e+03 
         -1.409500e+03:-2.757200e+03 -1.414125e+03:-2.748525e+03 
         -1.419575e+03:-2.740350e+03 -1.425825e+03:-2.732775e+03 
         -1.432775e+03:-2.725825e+03 -1.440350e+03:-2.719575e+03 
         -1.448525e+03:-2.714125e+03 -1.457200e+03:-2.709500e+03 
         -1.466275e+03:-2.705725e+03 -1.475675e+03:-2.702875e+03 
         -1.485300e+03:-2.700975e+03 -1.495075e+03:-2.700000e+03 
         -1.504925e+03:-2.700000e+03 -1.514700e+03:-2.700975e+03 
         -1.524325e+03:-2.702875e+03 -1.533725e+03:-2.705725e+03 
         -1.542800e+03:-2.709500e+03 -1.551475e+03:-2.714125e+03 
         -1.559650e+03:-2.719575e+03 -1.567225e+03:-2.725825e+03 
         -1.574175e+03:-2.732775e+03 -1.580425e+03:-2.740350e+03 
         -1.585875e+03:-2.748525e+03 -1.590500e+03:-2.757200e+03 
         -1.594275e+03:-2.766275e+03 -1.597125e+03:-2.775675e+03 
         -1.599025e+03:-2.785300e+03 -1.600000e+03:-2.795075e+03 
         -1.600000e+03:-3.700000e+03 -1.400000e+03:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.000000e+03:-2.695075e+03 -2.000975e+03:-2.685300e+03 
         -2.002875e+03:-2.675675e+03 -2.005725e+03:-2.666275e+03 
         -2.009500e+03:-2.657200e+03 -2.014125e+03:-2.648525e+03 
         -2.019575e+03:-2.640350e+03 -2.025825e+03:-2.632775e+03 
         -2.032775e+03:-2.625825e+03 -2.040350e+03:-2.619575e+03 
         -2.048525e+03:-2.614125e+03 -2.057200e+03:-2.609500e+03 
         -2.066275e+03:-2.605725e+03 -2.075675e+03:-2.602875e+03 
         -2.085300e+03:-2.600975e+03 -2.095075e+03:-2.600000e+03 
         -2.104925e+03:-2.600000e+03 -2.114700e+03:-2.600975e+03 
         -2.124325e+03:-2.602875e+03 -2.133725e+03:-2.605725e+03 
         -2.142800e+03:-2.609500e+03 -2.151475e+03:-2.614125e+03 
         -2.159650e+03:-2.619575e+03 -2.167225e+03:-2.625825e+03 
         -2.174175e+03:-2.632775e+03 -2.180425e+03:-2.640350e+03 
         -2.185875e+03:-2.648525e+03 -2.190500e+03:-2.657200e+03 
         -2.194275e+03:-2.666275e+03 -2.197125e+03:-2.675675e+03 
         -2.199025e+03:-2.685300e+03 -2.200000e+03:-2.695075e+03 
         -2.200000e+03:-3.700000e+03 -2.000000e+03:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(2.231248e+03:-3.700000e+03 2.217600e+03:-3.670875e+03 
         2.200000e+03:-3.618946e+03 2.200000e+03:-2.695075e+03 
         2.199025e+03:-2.685300e+03 2.197125e+03:-2.675675e+03 
         2.194275e+03:-2.666275e+03 2.190500e+03:-2.657200e+03 
         2.185875e+03:-2.648525e+03 2.180425e+03:-2.640350e+03 
         2.174175e+03:-2.632775e+03 2.167225e+03:-2.625825e+03 
         2.159650e+03:-2.619575e+03 2.151475e+03:-2.614125e+03 
         2.142800e+03:-2.609500e+03 2.133725e+03:-2.605725e+03 
         2.124325e+03:-2.602875e+03 2.114700e+03:-2.600975e+03 
         2.104925e+03:-2.600000e+03 2.095075e+03:-2.600000e+03 
         2.085300e+03:-2.600975e+03 2.075675e+03:-2.602875e+03 
         2.066275e+03:-2.605725e+03 2.057200e+03:-2.609500e+03 
         2.048525e+03:-2.614125e+03 2.040350e+03:-2.619575e+03 
         2.032775e+03:-2.625825e+03 2.025825e+03:-2.632775e+03 
         2.019575e+03:-2.640350e+03 2.014125e+03:-2.648525e+03 
         2.009500e+03:-2.657200e+03 2.005725e+03:-2.666275e+03 
         2.002875e+03:-2.675675e+03 2.000975e+03:-2.685300e+03 
         2.000000e+03:-2.695075e+03 2.000000e+03:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:4.000000e+02 2.795075e+03:4.000000e+02 
         2.785300e+03:3.990250e+02 2.775675e+03:3.971250e+02 
         2.766275e+03:3.942750e+02 2.757200e+03:3.905000e+02 
         2.748525e+03:3.858750e+02 2.740350e+03:3.804250e+02 
         2.732775e+03:3.741750e+02 2.725825e+03:3.672250e+02 
         2.719575e+03:3.596500e+02 2.714125e+03:3.514750e+02 
         2.709500e+03:3.428000e+02 2.705725e+03:3.337250e+02 
         2.702875e+03:3.243250e+02 2.700975e+03:3.147000e+02 
         2.700000e+03:3.049250e+02 2.700000e+03:2.950750e+02 
         2.700975e+03:2.853000e+02 2.702875e+03:2.756750e+02 
         2.705725e+03:2.662750e+02 2.709500e+03:2.572000e+02 
         2.714125e+03:2.485250e+02 2.719575e+03:2.403500e+02 
         2.725825e+03:2.327750e+02 2.732775e+03:2.258250e+02 
         2.740350e+03:2.195750e+02 2.748525e+03:2.141250e+02 
         2.757200e+03:2.095000e+02 2.766275e+03:2.057250e+02 
         2.775675e+03:2.028750e+02 2.785300e+03:2.009750e+02 
         2.795075e+03:2.000000e+02 3.700000e+03:2.000000e+02))
  dbCreatePolygon(cv list(133 -1)
    list(-1.100000e+03:-2.795075e+03 -1.100975e+03:-2.785300e+03 
         -1.102875e+03:-2.775675e+03 -1.105725e+03:-2.766275e+03 
         -1.109500e+03:-2.757200e+03 -1.114125e+03:-2.748525e+03 
         -1.119575e+03:-2.740350e+03 -1.125825e+03:-2.732775e+03 
         -1.132775e+03:-2.725825e+03 -1.140350e+03:-2.719575e+03 
         -1.148525e+03:-2.714125e+03 -1.157200e+03:-2.709500e+03 
         -1.166275e+03:-2.705725e+03 -1.175675e+03:-2.702875e+03 
         -1.185300e+03:-2.700975e+03 -1.195075e+03:-2.700000e+03 
         -1.204925e+03:-2.700000e+03 -1.214700e+03:-2.700975e+03 
         -1.224325e+03:-2.702875e+03 -1.233725e+03:-2.705725e+03 
         -1.242800e+03:-2.709500e+03 -1.251475e+03:-2.714125e+03 
         -1.259650e+03:-2.719575e+03 -1.267225e+03:-2.725825e+03 
         -1.274175e+03:-2.732775e+03 -1.280425e+03:-2.740350e+03 
         -1.285875e+03:-2.748525e+03 -1.290500e+03:-2.757200e+03 
         -1.294275e+03:-2.766275e+03 -1.297125e+03:-2.775675e+03 
         -1.299025e+03:-2.785300e+03 -1.300000e+03:-2.795075e+03 
         -1.300000e+03:-3.700000e+03 -1.100000e+03:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(1.000000e+02:3.700000e+03 -1.000000e+02:3.700000e+03 
         -1.000000e+02:2.795075e+03 -9.902500e+01:2.785300e+03 
         -9.712500e+01:2.775675e+03 -9.427500e+01:2.766275e+03 
         -9.050000e+01:2.757200e+03 -8.587500e+01:2.748525e+03 
         -8.042500e+01:2.740350e+03 -7.417500e+01:2.732775e+03 
         -6.722500e+01:2.725825e+03 -5.965000e+01:2.719575e+03 
         -5.147500e+01:2.714125e+03 -4.280000e+01:2.709500e+03 
         -3.372500e+01:2.705725e+03 -2.432500e+01:2.702875e+03 
         -1.470000e+01:2.700975e+03 -4.925000e+00:2.700000e+03 
         4.925000e+00:2.700000e+03 1.470000e+01:2.700975e+03 
         2.432500e+01:2.702875e+03 3.372500e+01:2.705725e+03 
         4.280000e+01:2.709500e+03 5.147500e+01:2.714125e+03 
         5.965000e+01:2.719575e+03 6.722500e+01:2.725825e+03 
         7.417500e+01:2.732775e+03 8.042500e+01:2.740350e+03 
         8.587500e+01:2.748525e+03 9.050000e+01:2.757200e+03 
         9.427500e+01:2.766275e+03 9.712500e+01:2.775675e+03 
         9.902500e+01:2.785300e+03 1.000000e+02:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:1.600000e+03 2.795075e+03:1.600000e+03 
         2.785300e+03:1.599025e+03 2.775675e+03:1.597125e+03 
         2.766275e+03:1.594275e+03 2.757200e+03:1.590500e+03 
         2.748525e+03:1.585875e+03 2.740350e+03:1.580425e+03 
         2.732775e+03:1.574175e+03 2.725825e+03:1.567225e+03 
         2.719575e+03:1.559650e+03 2.714125e+03:1.551475e+03 
         2.709500e+03:1.542800e+03 2.705725e+03:1.533725e+03 
         2.702875e+03:1.524325e+03 2.700975e+03:1.514700e+03 
         2.700000e+03:1.504925e+03 2.700000e+03:1.495075e+03 
         2.700975e+03:1.485300e+03 2.702875e+03:1.475675e+03 
         2.705725e+03:1.466275e+03 2.709500e+03:1.457200e+03 
         2.714125e+03:1.448525e+03 2.719575e+03:1.440350e+03 
         2.725825e+03:1.432775e+03 2.732775e+03:1.425825e+03 
         2.740350e+03:1.419575e+03 2.748525e+03:1.414125e+03 
         2.757200e+03:1.409500e+03 2.766275e+03:1.405725e+03 
         2.775675e+03:1.402875e+03 2.785300e+03:1.400975e+03 
         2.795075e+03:1.400000e+03 3.700000e+03:1.400000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:-1.400000e+03 2.795075e+03:-1.400000e+03 
         2.785300e+03:-1.400975e+03 2.775675e+03:-1.402875e+03 
         2.766275e+03:-1.405725e+03 2.757200e+03:-1.409500e+03 
         2.748525e+03:-1.414125e+03 2.740350e+03:-1.419575e+03 
         2.732775e+03:-1.425825e+03 2.725825e+03:-1.432775e+03 
         2.719575e+03:-1.440350e+03 2.714125e+03:-1.448525e+03 
         2.709500e+03:-1.457200e+03 2.705725e+03:-1.466275e+03 
         2.702875e+03:-1.475675e+03 2.700975e+03:-1.485300e+03 
         2.700000e+03:-1.495075e+03 2.700000e+03:-1.504925e+03 
         2.700975e+03:-1.514700e+03 2.702875e+03:-1.524325e+03 
         2.705725e+03:-1.533725e+03 2.709500e+03:-1.542800e+03 
         2.714125e+03:-1.551475e+03 2.719575e+03:-1.559650e+03 
         2.725825e+03:-1.567225e+03 2.732775e+03:-1.574175e+03 
         2.740350e+03:-1.580425e+03 2.748525e+03:-1.585875e+03 
         2.757200e+03:-1.590500e+03 2.766275e+03:-1.594275e+03 
         2.775675e+03:-1.597125e+03 2.785300e+03:-1.599025e+03 
         2.795075e+03:-1.600000e+03 3.700000e+03:-1.600000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(1.600000e+03:-2.795075e+03 1.599025e+03:-2.785300e+03 
         1.597125e+03:-2.775675e+03 1.594275e+03:-2.766275e+03 
         1.590500e+03:-2.757200e+03 1.585875e+03:-2.748525e+03 
         1.580425e+03:-2.740350e+03 1.574175e+03:-2.732775e+03 
         1.567225e+03:-2.725825e+03 1.559650e+03:-2.719575e+03 
         1.551475e+03:-2.714125e+03 1.542800e+03:-2.709500e+03 
         1.533725e+03:-2.705725e+03 1.524325e+03:-2.702875e+03 
         1.514700e+03:-2.700975e+03 1.504925e+03:-2.700000e+03 
         1.495075e+03:-2.700000e+03 1.485300e+03:-2.700975e+03 
         1.475675e+03:-2.702875e+03 1.466275e+03:-2.705725e+03 
         1.457200e+03:-2.709500e+03 1.448525e+03:-2.714125e+03 
         1.440350e+03:-2.719575e+03 1.432775e+03:-2.725825e+03 
         1.425825e+03:-2.732775e+03 1.419575e+03:-2.740350e+03 
         1.414125e+03:-2.748525e+03 1.409500e+03:-2.757200e+03 
         1.405725e+03:-2.766275e+03 1.402875e+03:-2.775675e+03 
         1.400975e+03:-2.785300e+03 1.400000e+03:-2.795075e+03 
         1.400000e+03:-3.700000e+03 1.600000e+03:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:1.000000e+02 2.795075e+03:1.000000e+02 
         2.785300e+03:9.902500e+01 2.775675e+03:9.712500e+01 
         2.766275e+03:9.427500e+01 2.757200e+03:9.050000e+01 
         2.748525e+03:8.587500e+01 2.740350e+03:8.042500e+01 
         2.732775e+03:7.417500e+01 2.725825e+03:6.722500e+01 
         2.719575e+03:5.965000e+01 2.714125e+03:5.147500e+01 
         2.709500e+03:4.280000e+01 2.705725e+03:3.372500e+01 
         2.702875e+03:2.432500e+01 2.700975e+03:1.470000e+01 
         2.700000e+03:4.925000e+00 2.700000e+03:-4.925000e+00 
         2.700975e+03:-1.470000e+01 2.702875e+03:-2.432500e+01 
         2.705725e+03:-3.372500e+01 2.709500e+03:-4.280000e+01 
         2.714125e+03:-5.147500e+01 2.719575e+03:-5.965000e+01 
         2.725825e+03:-6.722500e+01 2.732775e+03:-7.417500e+01 
         2.740350e+03:-8.042500e+01 2.748525e+03:-8.587500e+01 
         2.757200e+03:-9.050000e+01 2.766275e+03:-9.427500e+01 
         2.775675e+03:-9.712500e+01 2.785300e+03:-9.902500e+01 
         2.795075e+03:-1.000000e+02 3.700000e+03:-1.000000e+02))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:2.200000e+03 2.695075e+03:2.200000e+03 
         2.685300e+03:2.199025e+03 2.675675e+03:2.197125e+03 
         2.666275e+03:2.194275e+03 2.657200e+03:2.190500e+03 
         2.648525e+03:2.185875e+03 2.640350e+03:2.180425e+03 
         2.632775e+03:2.174175e+03 2.625825e+03:2.167225e+03 
         2.619575e+03:2.159650e+03 2.614125e+03:2.151475e+03 
         2.609500e+03:2.142800e+03 2.605725e+03:2.133725e+03 
         2.602875e+03:2.124325e+03 2.600975e+03:2.114700e+03 
         2.600000e+03:2.104925e+03 2.600000e+03:2.095075e+03 
         2.600975e+03:2.085300e+03 2.602875e+03:2.075675e+03 
         2.605725e+03:2.066275e+03 2.609500e+03:2.057200e+03 
         2.614125e+03:2.048525e+03 2.619575e+03:2.040350e+03 
         2.625825e+03:2.032775e+03 2.632775e+03:2.025825e+03 
         2.640350e+03:2.019575e+03 2.648525e+03:2.014125e+03 
         2.657200e+03:2.009500e+03 2.666275e+03:2.005725e+03 
         2.675675e+03:2.002875e+03 2.685300e+03:2.000975e+03 
         2.695075e+03:2.000000e+03 3.700000e+03:2.000000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:1.900000e+03 2.795075e+03:1.900000e+03 
         2.785300e+03:1.899025e+03 2.775675e+03:1.897125e+03 
         2.766275e+03:1.894275e+03 2.757200e+03:1.890500e+03 
         2.748525e+03:1.885875e+03 2.740350e+03:1.880425e+03 
         2.732775e+03:1.874175e+03 2.725825e+03:1.867225e+03 
         2.719575e+03:1.859650e+03 2.714125e+03:1.851475e+03 
         2.709500e+03:1.842800e+03 2.705725e+03:1.833725e+03 
         2.702875e+03:1.824325e+03 2.700975e+03:1.814700e+03 
         2.700000e+03:1.804925e+03 2.700000e+03:1.795075e+03 
         2.700975e+03:1.785300e+03 2.702875e+03:1.775675e+03 
         2.705725e+03:1.766275e+03 2.709500e+03:1.757200e+03 
         2.714125e+03:1.748525e+03 2.719575e+03:1.740350e+03 
         2.725825e+03:1.732775e+03 2.732775e+03:1.725825e+03 
         2.740350e+03:1.719575e+03 2.748525e+03:1.714125e+03 
         2.757200e+03:1.709500e+03 2.766275e+03:1.705725e+03 
         2.775675e+03:1.702875e+03 2.785300e+03:1.700975e+03 
         2.795075e+03:1.700000e+03 3.700000e+03:1.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:-2.000000e+02 2.795075e+03:-2.000000e+02 
         2.785300e+03:-2.009750e+02 2.775675e+03:-2.028750e+02 
         2.766275e+03:-2.057250e+02 2.757200e+03:-2.095000e+02 
         2.748525e+03:-2.141250e+02 2.740350e+03:-2.195750e+02 
         2.732775e+03:-2.258250e+02 2.725825e+03:-2.327750e+02 
         2.719575e+03:-2.403500e+02 2.714125e+03:-2.485250e+02 
         2.709500e+03:-2.572000e+02 2.705725e+03:-2.662750e+02 
         2.702875e+03:-2.756750e+02 2.700975e+03:-2.853000e+02 
         2.700000e+03:-2.950750e+02 2.700000e+03:-3.049250e+02 
         2.700975e+03:-3.147000e+02 2.702875e+03:-3.243250e+02 
         2.705725e+03:-3.337250e+02 2.709500e+03:-3.428000e+02 
         2.714125e+03:-3.514750e+02 2.719575e+03:-3.596500e+02 
         2.725825e+03:-3.672250e+02 2.732775e+03:-3.741750e+02 
         2.740350e+03:-3.804250e+02 2.748525e+03:-3.858750e+02 
         2.757200e+03:-3.905000e+02 2.766275e+03:-3.942750e+02 
         2.775675e+03:-3.971250e+02 2.785300e+03:-3.990250e+02 
         2.795075e+03:-4.000000e+02 3.700000e+03:-4.000000e+02))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:7.000000e+02 2.795075e+03:7.000000e+02 
         2.785300e+03:6.990250e+02 2.775675e+03:6.971250e+02 
         2.766275e+03:6.942750e+02 2.757200e+03:6.905000e+02 
         2.748525e+03:6.858750e+02 2.740350e+03:6.804250e+02 
         2.732775e+03:6.741750e+02 2.725825e+03:6.672250e+02 
         2.719575e+03:6.596500e+02 2.714125e+03:6.514750e+02 
         2.709500e+03:6.428000e+02 2.705725e+03:6.337250e+02 
         2.702875e+03:6.243250e+02 2.700975e+03:6.147000e+02 
         2.700000e+03:6.049250e+02 2.700000e+03:5.950750e+02 
         2.700975e+03:5.853000e+02 2.702875e+03:5.756750e+02 
         2.705725e+03:5.662750e+02 2.709500e+03:5.572000e+02 
         2.714125e+03:5.485250e+02 2.719575e+03:5.403500e+02 
         2.725825e+03:5.327750e+02 2.732775e+03:5.258250e+02 
         2.740350e+03:5.195750e+02 2.748525e+03:5.141250e+02 
         2.757200e+03:5.095000e+02 2.766275e+03:5.057250e+02 
         2.775675e+03:5.028750e+02 2.785300e+03:5.009750e+02 
         2.795075e+03:5.000000e+02 3.700000e+03:5.000000e+02))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:-5.000000e+02 2.795075e+03:-5.000000e+02 
         2.785300e+03:-5.009750e+02 2.775675e+03:-5.028750e+02 
         2.766275e+03:-5.057250e+02 2.757200e+03:-5.095000e+02 
         2.748525e+03:-5.141250e+02 2.740350e+03:-5.195750e+02 
         2.732775e+03:-5.258250e+02 2.725825e+03:-5.327750e+02 
         2.719575e+03:-5.403500e+02 2.714125e+03:-5.485250e+02 
         2.709500e+03:-5.572000e+02 2.705725e+03:-5.662750e+02 
         2.702875e+03:-5.756750e+02 2.700975e+03:-5.853000e+02 
         2.700000e+03:-5.950750e+02 2.700000e+03:-6.049250e+02 
         2.700975e+03:-6.147000e+02 2.702875e+03:-6.243250e+02 
         2.705725e+03:-6.337250e+02 2.709500e+03:-6.428000e+02 
         2.714125e+03:-6.514750e+02 2.719575e+03:-6.596500e+02 
         2.725825e+03:-6.672250e+02 2.732775e+03:-6.741750e+02 
         2.740350e+03:-6.804250e+02 2.748525e+03:-6.858750e+02 
         2.757200e+03:-6.905000e+02 2.766275e+03:-6.942750e+02 
         2.775675e+03:-6.971250e+02 2.785300e+03:-6.990250e+02 
         2.795075e+03:-7.000000e+02 3.700000e+03:-7.000000e+02))
  dbCreatePolygon(cv list(133 -1)
    list(2.215853e+03:3.700000e+03 2.000000e+03:3.700000e+03 
         2.000000e+03:2.695075e+03 2.000975e+03:2.685300e+03 
         2.002875e+03:2.675675e+03 2.005725e+03:2.666275e+03 
         2.009500e+03:2.657200e+03 2.014125e+03:2.648525e+03 
         2.019575e+03:2.640350e+03 2.025825e+03:2.632775e+03 
         2.032775e+03:2.625825e+03 2.040350e+03:2.619575e+03 
         2.048525e+03:2.614125e+03 2.057200e+03:2.609500e+03 
         2.066275e+03:2.605725e+03 2.075675e+03:2.602875e+03 
         2.085300e+03:2.600975e+03 2.095075e+03:2.600000e+03 
         2.104925e+03:2.600000e+03 2.114700e+03:2.600975e+03 
         2.124325e+03:2.602875e+03 2.133725e+03:2.605725e+03 
         2.142800e+03:2.609500e+03 2.151475e+03:2.614125e+03 
         2.159650e+03:2.619575e+03 2.167225e+03:2.625825e+03 
         2.174175e+03:2.632775e+03 2.180425e+03:2.640350e+03 
         2.185875e+03:2.648525e+03 2.190500e+03:2.657200e+03 
         2.194275e+03:2.666275e+03 2.197125e+03:2.675675e+03 
         2.199025e+03:2.685300e+03 2.200000e+03:2.695075e+03 
         2.200000e+03:3.655363e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:-8.000000e+02 2.795075e+03:-8.000000e+02 
         2.785300e+03:-8.009750e+02 2.775675e+03:-8.028750e+02 
         2.766275e+03:-8.057250e+02 2.757200e+03:-8.095000e+02 
         2.748525e+03:-8.141250e+02 2.740350e+03:-8.195750e+02 
         2.732775e+03:-8.258250e+02 2.725825e+03:-8.327750e+02 
         2.719575e+03:-8.403500e+02 2.714125e+03:-8.485250e+02 
         2.709500e+03:-8.572000e+02 2.705725e+03:-8.662750e+02 
         2.702875e+03:-8.756750e+02 2.700975e+03:-8.853000e+02 
         2.700000e+03:-8.950750e+02 2.700000e+03:-9.049250e+02 
         2.700975e+03:-9.147000e+02 2.702875e+03:-9.243250e+02 
         2.705725e+03:-9.337250e+02 2.709500e+03:-9.428000e+02 
         2.714125e+03:-9.514750e+02 2.719575e+03:-9.596500e+02 
         2.725825e+03:-9.672250e+02 2.732775e+03:-9.741750e+02 
         2.740350e+03:-9.804250e+02 2.748525e+03:-9.858750e+02 
         2.757200e+03:-9.905000e+02 2.766275e+03:-9.942750e+02 
         2.775675e+03:-9.971250e+02 2.785300e+03:-9.990250e+02 
         2.795075e+03:-1.000000e+03 3.700000e+03:-1.000000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:-1.100000e+03 2.795075e+03:-1.100000e+03 
         2.785300e+03:-1.100975e+03 2.775675e+03:-1.102875e+03 
         2.766275e+03:-1.105725e+03 2.757200e+03:-1.109500e+03 
         2.748525e+03:-1.114125e+03 2.740350e+03:-1.119575e+03 
         2.732775e+03:-1.125825e+03 2.725825e+03:-1.132775e+03 
         2.719575e+03:-1.140350e+03 2.714125e+03:-1.148525e+03 
         2.709500e+03:-1.157200e+03 2.705725e+03:-1.166275e+03 
         2.702875e+03:-1.175675e+03 2.700975e+03:-1.185300e+03 
         2.700000e+03:-1.195075e+03 2.700000e+03:-1.204925e+03 
         2.700975e+03:-1.214700e+03 2.702875e+03:-1.224325e+03 
         2.705725e+03:-1.233725e+03 2.709500e+03:-1.242800e+03 
         2.714125e+03:-1.251475e+03 2.719575e+03:-1.259650e+03 
         2.725825e+03:-1.267225e+03 2.732775e+03:-1.274175e+03 
         2.740350e+03:-1.280425e+03 2.748525e+03:-1.285875e+03 
         2.757200e+03:-1.290500e+03 2.766275e+03:-1.294275e+03 
         2.775675e+03:-1.297125e+03 2.785300e+03:-1.299025e+03 
         2.795075e+03:-1.300000e+03 3.700000e+03:-1.300000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(1.900000e+03:3.700000e+03 1.700000e+03:3.700000e+03 
         1.700000e+03:2.795075e+03 1.700975e+03:2.785300e+03 
         1.702875e+03:2.775675e+03 1.705725e+03:2.766275e+03 
         1.709500e+03:2.757200e+03 1.714125e+03:2.748525e+03 
         1.719575e+03:2.740350e+03 1.725825e+03:2.732775e+03 
         1.732775e+03:2.725825e+03 1.740350e+03:2.719575e+03 
         1.748525e+03:2.714125e+03 1.757200e+03:2.709500e+03 
         1.766275e+03:2.705725e+03 1.775675e+03:2.702875e+03 
         1.785300e+03:2.700975e+03 1.795075e+03:2.700000e+03 
         1.804925e+03:2.700000e+03 1.814700e+03:2.700975e+03 
         1.824325e+03:2.702875e+03 1.833725e+03:2.705725e+03 
         1.842800e+03:2.709500e+03 1.851475e+03:2.714125e+03 
         1.859650e+03:2.719575e+03 1.867225e+03:2.725825e+03 
         1.874175e+03:2.732775e+03 1.880425e+03:2.740350e+03 
         1.885875e+03:2.748525e+03 1.890500e+03:2.757200e+03 
         1.894275e+03:2.766275e+03 1.897125e+03:2.775675e+03 
         1.899025e+03:2.785300e+03 1.900000e+03:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(1.900000e+03:-2.795075e+03 1.899025e+03:-2.785300e+03 
         1.897125e+03:-2.775675e+03 1.894275e+03:-2.766275e+03 
         1.890500e+03:-2.757200e+03 1.885875e+03:-2.748525e+03 
         1.880425e+03:-2.740350e+03 1.874175e+03:-2.732775e+03 
         1.867225e+03:-2.725825e+03 1.859650e+03:-2.719575e+03 
         1.851475e+03:-2.714125e+03 1.842800e+03:-2.709500e+03 
         1.833725e+03:-2.705725e+03 1.824325e+03:-2.702875e+03 
         1.814700e+03:-2.700975e+03 1.804925e+03:-2.700000e+03 
         1.795075e+03:-2.700000e+03 1.785300e+03:-2.700975e+03 
         1.775675e+03:-2.702875e+03 1.766275e+03:-2.705725e+03 
         1.757200e+03:-2.709500e+03 1.748525e+03:-2.714125e+03 
         1.740350e+03:-2.719575e+03 1.732775e+03:-2.725825e+03 
         1.725825e+03:-2.732775e+03 1.719575e+03:-2.740350e+03 
         1.714125e+03:-2.748525e+03 1.709500e+03:-2.757200e+03 
         1.705725e+03:-2.766275e+03 1.702875e+03:-2.775675e+03 
         1.700975e+03:-2.785300e+03 1.700000e+03:-2.795075e+03 
         1.700000e+03:-3.700000e+03 1.900000e+03:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(1.600000e+03:3.700000e+03 1.400000e+03:3.700000e+03 
         1.400000e+03:2.795075e+03 1.400975e+03:2.785300e+03 
         1.402875e+03:2.775675e+03 1.405725e+03:2.766275e+03 
         1.409500e+03:2.757200e+03 1.414125e+03:2.748525e+03 
         1.419575e+03:2.740350e+03 1.425825e+03:2.732775e+03 
         1.432775e+03:2.725825e+03 1.440350e+03:2.719575e+03 
         1.448525e+03:2.714125e+03 1.457200e+03:2.709500e+03 
         1.466275e+03:2.705725e+03 1.475675e+03:2.702875e+03 
         1.485300e+03:2.700975e+03 1.495075e+03:2.700000e+03 
         1.504925e+03:2.700000e+03 1.514700e+03:2.700975e+03 
         1.524325e+03:2.702875e+03 1.533725e+03:2.705725e+03 
         1.542800e+03:2.709500e+03 1.551475e+03:2.714125e+03 
         1.559650e+03:2.719575e+03 1.567225e+03:2.725825e+03 
         1.574175e+03:2.732775e+03 1.580425e+03:2.740350e+03 
         1.585875e+03:2.748525e+03 1.590500e+03:2.757200e+03 
         1.594275e+03:2.766275e+03 1.597125e+03:2.775675e+03 
         1.599025e+03:2.785300e+03 1.600000e+03:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(7.000000e+02:3.700000e+03 5.000000e+02:3.700000e+03 
         5.000000e+02:2.795075e+03 5.009750e+02:2.785300e+03 
         5.028750e+02:2.775675e+03 5.057250e+02:2.766275e+03 
         5.095000e+02:2.757200e+03 5.141250e+02:2.748525e+03 
         5.195750e+02:2.740350e+03 5.258250e+02:2.732775e+03 
         5.327750e+02:2.725825e+03 5.403500e+02:2.719575e+03 
         5.485250e+02:2.714125e+03 5.572000e+02:2.709500e+03 
         5.662750e+02:2.705725e+03 5.756750e+02:2.702875e+03 
         5.853000e+02:2.700975e+03 5.950750e+02:2.700000e+03 
         6.049250e+02:2.700000e+03 6.147000e+02:2.700975e+03 
         6.243250e+02:2.702875e+03 6.337250e+02:2.705725e+03 
         6.428000e+02:2.709500e+03 6.514750e+02:2.714125e+03 
         6.596500e+02:2.719575e+03 6.672250e+02:2.725825e+03 
         6.741750e+02:2.732775e+03 6.804250e+02:2.740350e+03 
         6.858750e+02:2.748525e+03 6.905000e+02:2.757200e+03 
         6.942750e+02:2.766275e+03 6.971250e+02:2.775675e+03 
         6.990250e+02:2.785300e+03 7.000000e+02:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(1.000000e+03:3.700000e+03 8.000000e+02:3.700000e+03 
         8.000000e+02:2.795075e+03 8.009750e+02:2.785300e+03 
         8.028750e+02:2.775675e+03 8.057250e+02:2.766275e+03 
         8.095000e+02:2.757200e+03 8.141250e+02:2.748525e+03 
         8.195750e+02:2.740350e+03 8.258250e+02:2.732775e+03 
         8.327750e+02:2.725825e+03 8.403500e+02:2.719575e+03 
         8.485250e+02:2.714125e+03 8.572000e+02:2.709500e+03 
         8.662750e+02:2.705725e+03 8.756750e+02:2.702875e+03 
         8.853000e+02:2.700975e+03 8.950750e+02:2.700000e+03 
         9.049250e+02:2.700000e+03 9.147000e+02:2.700975e+03 
         9.243250e+02:2.702875e+03 9.337250e+02:2.705725e+03 
         9.428000e+02:2.709500e+03 9.514750e+02:2.714125e+03 
         9.596500e+02:2.719575e+03 9.672250e+02:2.725825e+03 
         9.741750e+02:2.732775e+03 9.804250e+02:2.740350e+03 
         9.858750e+02:2.748525e+03 9.905000e+02:2.757200e+03 
         9.942750e+02:2.766275e+03 9.971250e+02:2.775675e+03 
         9.990250e+02:2.785300e+03 1.000000e+03:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(7.000000e+02:-2.795075e+03 6.990250e+02:-2.785300e+03 
         6.971250e+02:-2.775675e+03 6.942750e+02:-2.766275e+03 
         6.905000e+02:-2.757200e+03 6.858750e+02:-2.748525e+03 
         6.804250e+02:-2.740350e+03 6.741750e+02:-2.732775e+03 
         6.672250e+02:-2.725825e+03 6.596500e+02:-2.719575e+03 
         6.514750e+02:-2.714125e+03 6.428000e+02:-2.709500e+03 
         6.337250e+02:-2.705725e+03 6.243250e+02:-2.702875e+03 
         6.147000e+02:-2.700975e+03 6.049250e+02:-2.700000e+03 
         5.950750e+02:-2.700000e+03 5.853000e+02:-2.700975e+03 
         5.756750e+02:-2.702875e+03 5.662750e+02:-2.705725e+03 
         5.572000e+02:-2.709500e+03 5.485250e+02:-2.714125e+03 
         5.403500e+02:-2.719575e+03 5.327750e+02:-2.725825e+03 
         5.258250e+02:-2.732775e+03 5.195750e+02:-2.740350e+03 
         5.141250e+02:-2.748525e+03 5.095000e+02:-2.757200e+03 
         5.057250e+02:-2.766275e+03 5.028750e+02:-2.775675e+03 
         5.009750e+02:-2.785300e+03 5.000000e+02:-2.795075e+03 
         5.000000e+02:-3.700000e+03 7.000000e+02:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-5.000000e+02:3.700000e+03 -7.000000e+02:3.700000e+03 
         -7.000000e+02:2.795075e+03 -6.990250e+02:2.785300e+03 
         -6.971250e+02:2.775675e+03 -6.942750e+02:2.766275e+03 
         -6.905000e+02:2.757200e+03 -6.858750e+02:2.748525e+03 
         -6.804250e+02:2.740350e+03 -6.741750e+02:2.732775e+03 
         -6.672250e+02:2.725825e+03 -6.596500e+02:2.719575e+03 
         -6.514750e+02:2.714125e+03 -6.428000e+02:2.709500e+03 
         -6.337250e+02:2.705725e+03 -6.243250e+02:2.702875e+03 
         -6.147000e+02:2.700975e+03 -6.049250e+02:2.700000e+03 
         -5.950750e+02:2.700000e+03 -5.853000e+02:2.700975e+03 
         -5.756750e+02:2.702875e+03 -5.662750e+02:2.705725e+03 
         -5.572000e+02:2.709500e+03 -5.485250e+02:2.714125e+03 
         -5.403500e+02:2.719575e+03 -5.327750e+02:2.725825e+03 
         -5.258250e+02:2.732775e+03 -5.195750e+02:2.740350e+03 
         -5.141250e+02:2.748525e+03 -5.095000e+02:2.757200e+03 
         -5.057250e+02:2.766275e+03 -5.028750e+02:2.775675e+03 
         -5.009750e+02:2.785300e+03 -5.000000e+02:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(4.000000e+02:3.700000e+03 2.000000e+02:3.700000e+03 
         2.000000e+02:2.795075e+03 2.009750e+02:2.785300e+03 
         2.028750e+02:2.775675e+03 2.057250e+02:2.766275e+03 
         2.095000e+02:2.757200e+03 2.141250e+02:2.748525e+03 
         2.195750e+02:2.740350e+03 2.258250e+02:2.732775e+03 
         2.327750e+02:2.725825e+03 2.403500e+02:2.719575e+03 
         2.485250e+02:2.714125e+03 2.572000e+02:2.709500e+03 
         2.662750e+02:2.705725e+03 2.756750e+02:2.702875e+03 
         2.853000e+02:2.700975e+03 2.950750e+02:2.700000e+03 
         3.049250e+02:2.700000e+03 3.147000e+02:2.700975e+03 
         3.243250e+02:2.702875e+03 3.337250e+02:2.705725e+03 
         3.428000e+02:2.709500e+03 3.514750e+02:2.714125e+03 
         3.596500e+02:2.719575e+03 3.672250e+02:2.725825e+03 
         3.741750e+02:2.732775e+03 3.804250e+02:2.740350e+03 
         3.858750e+02:2.748525e+03 3.905000e+02:2.757200e+03 
         3.942750e+02:2.766275e+03 3.971250e+02:2.775675e+03 
         3.990250e+02:2.785300e+03 4.000000e+02:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(4.000000e+02:-2.795075e+03 3.990250e+02:-2.785300e+03 
         3.971250e+02:-2.775675e+03 3.942750e+02:-2.766275e+03 
         3.905000e+02:-2.757200e+03 3.858750e+02:-2.748525e+03 
         3.804250e+02:-2.740350e+03 3.741750e+02:-2.732775e+03 
         3.672250e+02:-2.725825e+03 3.596500e+02:-2.719575e+03 
         3.514750e+02:-2.714125e+03 3.428000e+02:-2.709500e+03 
         3.337250e+02:-2.705725e+03 3.243250e+02:-2.702875e+03 
         3.147000e+02:-2.700975e+03 3.049250e+02:-2.700000e+03 
         2.950750e+02:-2.700000e+03 2.853000e+02:-2.700975e+03 
         2.756750e+02:-2.702875e+03 2.662750e+02:-2.705725e+03 
         2.572000e+02:-2.709500e+03 2.485250e+02:-2.714125e+03 
         2.403500e+02:-2.719575e+03 2.327750e+02:-2.725825e+03 
         2.258250e+02:-2.732775e+03 2.195750e+02:-2.740350e+03 
         2.141250e+02:-2.748525e+03 2.095000e+02:-2.757200e+03 
         2.057250e+02:-2.766275e+03 2.028750e+02:-2.775675e+03 
         2.009750e+02:-2.785300e+03 2.000000e+02:-2.795075e+03 
         2.000000e+02:-3.700000e+03 4.000000e+02:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-5.000000e+02:-2.795075e+03 -5.009750e+02:-2.785300e+03 
         -5.028750e+02:-2.775675e+03 -5.057250e+02:-2.766275e+03 
         -5.095000e+02:-2.757200e+03 -5.141250e+02:-2.748525e+03 
         -5.195750e+02:-2.740350e+03 -5.258250e+02:-2.732775e+03 
         -5.327750e+02:-2.725825e+03 -5.403500e+02:-2.719575e+03 
         -5.485250e+02:-2.714125e+03 -5.572000e+02:-2.709500e+03 
         -5.662750e+02:-2.705725e+03 -5.756750e+02:-2.702875e+03 
         -5.853000e+02:-2.700975e+03 -5.950750e+02:-2.700000e+03 
         -6.049250e+02:-2.700000e+03 -6.147000e+02:-2.700975e+03 
         -6.243250e+02:-2.702875e+03 -6.337250e+02:-2.705725e+03 
         -6.428000e+02:-2.709500e+03 -6.514750e+02:-2.714125e+03 
         -6.596500e+02:-2.719575e+03 -6.672250e+02:-2.725825e+03 
         -6.741750e+02:-2.732775e+03 -6.804250e+02:-2.740350e+03 
         -6.858750e+02:-2.748525e+03 -6.905000e+02:-2.757200e+03 
         -6.942750e+02:-2.766275e+03 -6.971250e+02:-2.775675e+03 
         -6.990250e+02:-2.785300e+03 -7.000000e+02:-2.795075e+03 
         -7.000000e+02:-3.700000e+03 -5.000000e+02:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.000000e+02:3.700000e+03 -4.000000e+02:3.700000e+03 
         -4.000000e+02:2.795075e+03 -3.990250e+02:2.785300e+03 
         -3.971250e+02:2.775675e+03 -3.942750e+02:2.766275e+03 
         -3.905000e+02:2.757200e+03 -3.858750e+02:2.748525e+03 
         -3.804250e+02:2.740350e+03 -3.741750e+02:2.732775e+03 
         -3.672250e+02:2.725825e+03 -3.596500e+02:2.719575e+03 
         -3.514750e+02:2.714125e+03 -3.428000e+02:2.709500e+03 
         -3.337250e+02:2.705725e+03 -3.243250e+02:2.702875e+03 
         -3.147000e+02:2.700975e+03 -3.049250e+02:2.700000e+03 
         -2.950750e+02:2.700000e+03 -2.853000e+02:2.700975e+03 
         -2.756750e+02:2.702875e+03 -2.662750e+02:2.705725e+03 
         -2.572000e+02:2.709500e+03 -2.485250e+02:2.714125e+03 
         -2.403500e+02:2.719575e+03 -2.327750e+02:2.725825e+03 
         -2.258250e+02:2.732775e+03 -2.195750e+02:2.740350e+03 
         -2.141250e+02:2.748525e+03 -2.095000e+02:2.757200e+03 
         -2.057250e+02:2.766275e+03 -2.028750e+02:2.775675e+03 
         -2.009750e+02:2.785300e+03 -2.000000e+02:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-8.000000e+02:3.700000e+03 -1.000000e+03:3.700000e+03 
         -1.000000e+03:2.795075e+03 -9.990250e+02:2.785300e+03 
         -9.971250e+02:2.775675e+03 -9.942750e+02:2.766275e+03 
         -9.905000e+02:2.757200e+03 -9.858750e+02:2.748525e+03 
         -9.804250e+02:2.740350e+03 -9.741750e+02:2.732775e+03 
         -9.672250e+02:2.725825e+03 -9.596500e+02:2.719575e+03 
         -9.514750e+02:2.714125e+03 -9.428000e+02:2.709500e+03 
         -9.337250e+02:2.705725e+03 -9.243250e+02:2.702875e+03 
         -9.147000e+02:2.700975e+03 -9.049250e+02:2.700000e+03 
         -8.950750e+02:2.700000e+03 -8.853000e+02:2.700975e+03 
         -8.756750e+02:2.702875e+03 -8.662750e+02:2.705725e+03 
         -8.572000e+02:2.709500e+03 -8.485250e+02:2.714125e+03 
         -8.403500e+02:2.719575e+03 -8.327750e+02:2.725825e+03 
         -8.258250e+02:2.732775e+03 -8.195750e+02:2.740350e+03 
         -8.141250e+02:2.748525e+03 -8.095000e+02:2.757200e+03 
         -8.057250e+02:2.766275e+03 -8.028750e+02:2.775675e+03 
         -8.009750e+02:2.785300e+03 -8.000000e+02:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.600000e+03:2.104925e+03 -2.600975e+03:2.114700e+03 
         -2.602875e+03:2.124325e+03 -2.605725e+03:2.133725e+03 
         -2.609500e+03:2.142800e+03 -2.614125e+03:2.151475e+03 
         -2.619575e+03:2.159650e+03 -2.625825e+03:2.167225e+03 
         -2.632775e+03:2.174175e+03 -2.640350e+03:2.180425e+03 
         -2.648525e+03:2.185875e+03 -2.657200e+03:2.190500e+03 
         -2.666275e+03:2.194275e+03 -2.675675e+03:2.197125e+03 
         -2.685300e+03:2.199025e+03 -2.695075e+03:2.200000e+03 
         -3.700000e+03:2.200000e+03 -3.700000e+03:2.000000e+03 
         -2.695075e+03:2.000000e+03 -2.685300e+03:2.000975e+03 
         -2.675675e+03:2.002875e+03 -2.666275e+03:2.005725e+03 
         -2.657200e+03:2.009500e+03 -2.648525e+03:2.014125e+03 
         -2.640350e+03:2.019575e+03 -2.632775e+03:2.025825e+03 
         -2.625825e+03:2.032775e+03 -2.619575e+03:2.040350e+03 
         -2.614125e+03:2.048525e+03 -2.609500e+03:2.057200e+03 
         -2.605725e+03:2.066275e+03 -2.602875e+03:2.075675e+03 
         -2.600975e+03:2.085300e+03 -2.600000e+03:2.095075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(1.000000e+02:-2.795075e+03 9.902500e+01:-2.785300e+03 
         9.712500e+01:-2.775675e+03 9.427500e+01:-2.766275e+03 
         9.050000e+01:-2.757200e+03 8.587500e+01:-2.748525e+03 
         8.042500e+01:-2.740350e+03 7.417500e+01:-2.732775e+03 
         6.722500e+01:-2.725825e+03 5.965000e+01:-2.719575e+03 
         5.147500e+01:-2.714125e+03 4.280000e+01:-2.709500e+03 
         3.372500e+01:-2.705725e+03 2.432500e+01:-2.702875e+03 
         1.470000e+01:-2.700975e+03 4.925000e+00:-2.700000e+03 
         -4.925000e+00:-2.700000e+03 -1.470000e+01:-2.700975e+03 
         -2.432500e+01:-2.702875e+03 -3.372500e+01:-2.705725e+03 
         -4.280000e+01:-2.709500e+03 -5.147500e+01:-2.714125e+03 
         -5.965000e+01:-2.719575e+03 -6.722500e+01:-2.725825e+03 
         -7.417500e+01:-2.732775e+03 -8.042500e+01:-2.740350e+03 
         -8.587500e+01:-2.748525e+03 -9.050000e+01:-2.757200e+03 
         -9.427500e+01:-2.766275e+03 -9.712500e+01:-2.775675e+03 
         -9.902500e+01:-2.785300e+03 -1.000000e+02:-2.795075e+03 
         -1.000000e+02:-3.700000e+03 1.000000e+02:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(1.300000e+03:3.700000e+03 1.100000e+03:3.700000e+03 
         1.100000e+03:2.795075e+03 1.100975e+03:2.785300e+03 
         1.102875e+03:2.775675e+03 1.105725e+03:2.766275e+03 
         1.109500e+03:2.757200e+03 1.114125e+03:2.748525e+03 
         1.119575e+03:2.740350e+03 1.125825e+03:2.732775e+03 
         1.132775e+03:2.725825e+03 1.140350e+03:2.719575e+03 
         1.148525e+03:2.714125e+03 1.157200e+03:2.709500e+03 
         1.166275e+03:2.705725e+03 1.175675e+03:2.702875e+03 
         1.185300e+03:2.700975e+03 1.195075e+03:2.700000e+03 
         1.204925e+03:2.700000e+03 1.214700e+03:2.700975e+03 
         1.224325e+03:2.702875e+03 1.233725e+03:2.705725e+03 
         1.242800e+03:2.709500e+03 1.251475e+03:2.714125e+03 
         1.259650e+03:2.719575e+03 1.267225e+03:2.725825e+03 
         1.274175e+03:2.732775e+03 1.280425e+03:2.740350e+03 
         1.285875e+03:2.748525e+03 1.290500e+03:2.757200e+03 
         1.294275e+03:2.766275e+03 1.297125e+03:2.775675e+03 
         1.299025e+03:2.785300e+03 1.300000e+03:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:-1.700000e+03 2.795075e+03:-1.700000e+03 
         2.785300e+03:-1.700975e+03 2.775675e+03:-1.702875e+03 
         2.766275e+03:-1.705725e+03 2.757200e+03:-1.709500e+03 
         2.748525e+03:-1.714125e+03 2.740350e+03:-1.719575e+03 
         2.732775e+03:-1.725825e+03 2.725825e+03:-1.732775e+03 
         2.719575e+03:-1.740350e+03 2.714125e+03:-1.748525e+03 
         2.709500e+03:-1.757200e+03 2.705725e+03:-1.766275e+03 
         2.702875e+03:-1.775675e+03 2.700975e+03:-1.785300e+03 
         2.700000e+03:-1.795075e+03 2.700000e+03:-1.804925e+03 
         2.700975e+03:-1.814700e+03 2.702875e+03:-1.824325e+03 
         2.705725e+03:-1.833725e+03 2.709500e+03:-1.842800e+03 
         2.714125e+03:-1.851475e+03 2.719575e+03:-1.859650e+03 
         2.725825e+03:-1.867225e+03 2.732775e+03:-1.874175e+03 
         2.740350e+03:-1.880425e+03 2.748525e+03:-1.885875e+03 
         2.757200e+03:-1.890500e+03 2.766275e+03:-1.894275e+03 
         2.775675e+03:-1.897125e+03 2.785300e+03:-1.899025e+03 
         2.795075e+03:-1.900000e+03 3.700000e+03:-1.900000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(3.700000e+03:1.300000e+03 2.795075e+03:1.300000e+03 
         2.785300e+03:1.299025e+03 2.775675e+03:1.297125e+03 
         2.766275e+03:1.294275e+03 2.757200e+03:1.290500e+03 
         2.748525e+03:1.285875e+03 2.740350e+03:1.280425e+03 
         2.732775e+03:1.274175e+03 2.725825e+03:1.267225e+03 
         2.719575e+03:1.259650e+03 2.714125e+03:1.251475e+03 
         2.709500e+03:1.242800e+03 2.705725e+03:1.233725e+03 
         2.702875e+03:1.224325e+03 2.700975e+03:1.214700e+03 
         2.700000e+03:1.204925e+03 2.700000e+03:1.195075e+03 
         2.700975e+03:1.185300e+03 2.702875e+03:1.175675e+03 
         2.705725e+03:1.166275e+03 2.709500e+03:1.157200e+03 
         2.714125e+03:1.148525e+03 2.719575e+03:1.140350e+03 
         2.725825e+03:1.132775e+03 2.732775e+03:1.125825e+03 
         2.740350e+03:1.119575e+03 2.748525e+03:1.114125e+03 
         2.757200e+03:1.109500e+03 2.766275e+03:1.105725e+03 
         2.775675e+03:1.102875e+03 2.785300e+03:1.100975e+03 
         2.795075e+03:1.100000e+03 3.700000e+03:1.100000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-1.700000e+03:3.700000e+03 -1.900000e+03:3.700000e+03 
         -1.900000e+03:2.795075e+03 -1.899025e+03:2.785300e+03 
         -1.897125e+03:2.775675e+03 -1.894275e+03:2.766275e+03 
         -1.890500e+03:2.757200e+03 -1.885875e+03:2.748525e+03 
         -1.880425e+03:2.740350e+03 -1.874175e+03:2.732775e+03 
         -1.867225e+03:2.725825e+03 -1.859650e+03:2.719575e+03 
         -1.851475e+03:2.714125e+03 -1.842800e+03:2.709500e+03 
         -1.833725e+03:2.705725e+03 -1.824325e+03:2.702875e+03 
         -1.814700e+03:2.700975e+03 -1.804925e+03:2.700000e+03 
         -1.795075e+03:2.700000e+03 -1.785300e+03:2.700975e+03 
         -1.775675e+03:2.702875e+03 -1.766275e+03:2.705725e+03 
         -1.757200e+03:2.709500e+03 -1.748525e+03:2.714125e+03 
         -1.740350e+03:2.719575e+03 -1.732775e+03:2.725825e+03 
         -1.725825e+03:2.732775e+03 -1.719575e+03:2.740350e+03 
         -1.714125e+03:2.748525e+03 -1.709500e+03:2.757200e+03 
         -1.705725e+03:2.766275e+03 -1.702875e+03:2.775675e+03 
         -1.700975e+03:2.785300e+03 -1.700000e+03:2.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.000000e+02:-2.795075e+03 -2.009750e+02:-2.785300e+03 
         -2.028750e+02:-2.775675e+03 -2.057250e+02:-2.766275e+03 
         -2.095000e+02:-2.757200e+03 -2.141250e+02:-2.748525e+03 
         -2.195750e+02:-2.740350e+03 -2.258250e+02:-2.732775e+03 
         -2.327750e+02:-2.725825e+03 -2.403500e+02:-2.719575e+03 
         -2.485250e+02:-2.714125e+03 -2.572000e+02:-2.709500e+03 
         -2.662750e+02:-2.705725e+03 -2.756750e+02:-2.702875e+03 
         -2.853000e+02:-2.700975e+03 -2.950750e+02:-2.700000e+03 
         -3.049250e+02:-2.700000e+03 -3.147000e+02:-2.700975e+03 
         -3.243250e+02:-2.702875e+03 -3.337250e+02:-2.705725e+03 
         -3.428000e+02:-2.709500e+03 -3.514750e+02:-2.714125e+03 
         -3.596500e+02:-2.719575e+03 -3.672250e+02:-2.725825e+03 
         -3.741750e+02:-2.732775e+03 -3.804250e+02:-2.740350e+03 
         -3.858750e+02:-2.748525e+03 -3.905000e+02:-2.757200e+03 
         -3.942750e+02:-2.766275e+03 -3.971250e+02:-2.775675e+03 
         -3.990250e+02:-2.785300e+03 -4.000000e+02:-2.795075e+03 
         -4.000000e+02:-3.700000e+03 -2.000000e+02:-3.700000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:1.804925e+03 -2.700975e+03:1.814700e+03 
         -2.702875e+03:1.824325e+03 -2.705725e+03:1.833725e+03 
         -2.709500e+03:1.842800e+03 -2.714125e+03:1.851475e+03 
         -2.719575e+03:1.859650e+03 -2.725825e+03:1.867225e+03 
         -2.732775e+03:1.874175e+03 -2.740350e+03:1.880425e+03 
         -2.748525e+03:1.885875e+03 -2.757200e+03:1.890500e+03 
         -2.766275e+03:1.894275e+03 -2.775675e+03:1.897125e+03 
         -2.785300e+03:1.899025e+03 -2.795075e+03:1.900000e+03 
         -3.700000e+03:1.900000e+03 -3.700000e+03:1.700000e+03 
         -2.795075e+03:1.700000e+03 -2.785300e+03:1.700975e+03 
         -2.775675e+03:1.702875e+03 -2.766275e+03:1.705725e+03 
         -2.757200e+03:1.709500e+03 -2.748525e+03:1.714125e+03 
         -2.740350e+03:1.719575e+03 -2.732775e+03:1.725825e+03 
         -2.725825e+03:1.732775e+03 -2.719575e+03:1.740350e+03 
         -2.714125e+03:1.748525e+03 -2.709500e+03:1.757200e+03 
         -2.705725e+03:1.766275e+03 -2.702875e+03:1.775675e+03 
         -2.700975e+03:1.785300e+03 -2.700000e+03:1.795075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:1.504925e+03 -2.700975e+03:1.514700e+03 
         -2.702875e+03:1.524325e+03 -2.705725e+03:1.533725e+03 
         -2.709500e+03:1.542800e+03 -2.714125e+03:1.551475e+03 
         -2.719575e+03:1.559650e+03 -2.725825e+03:1.567225e+03 
         -2.732775e+03:1.574175e+03 -2.740350e+03:1.580425e+03 
         -2.748525e+03:1.585875e+03 -2.757200e+03:1.590500e+03 
         -2.766275e+03:1.594275e+03 -2.775675e+03:1.597125e+03 
         -2.785300e+03:1.599025e+03 -2.795075e+03:1.600000e+03 
         -3.700000e+03:1.600000e+03 -3.700000e+03:1.400000e+03 
         -2.795075e+03:1.400000e+03 -2.785300e+03:1.400975e+03 
         -2.775675e+03:1.402875e+03 -2.766275e+03:1.405725e+03 
         -2.757200e+03:1.409500e+03 -2.748525e+03:1.414125e+03 
         -2.740350e+03:1.419575e+03 -2.732775e+03:1.425825e+03 
         -2.725825e+03:1.432775e+03 -2.719575e+03:1.440350e+03 
         -2.714125e+03:1.448525e+03 -2.709500e+03:1.457200e+03 
         -2.705725e+03:1.466275e+03 -2.702875e+03:1.475675e+03 
         -2.700975e+03:1.485300e+03 -2.700000e+03:1.495075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:3.049250e+02 -2.700975e+03:3.147000e+02 
         -2.702875e+03:3.243250e+02 -2.705725e+03:3.337250e+02 
         -2.709500e+03:3.428000e+02 -2.714125e+03:3.514750e+02 
         -2.719575e+03:3.596500e+02 -2.725825e+03:3.672250e+02 
         -2.732775e+03:3.741750e+02 -2.740350e+03:3.804250e+02 
         -2.748525e+03:3.858750e+02 -2.757200e+03:3.905000e+02 
         -2.766275e+03:3.942750e+02 -2.775675e+03:3.971250e+02 
         -2.785300e+03:3.990250e+02 -2.795075e+03:4.000000e+02 
         -3.700000e+03:4.000000e+02 -3.700000e+03:2.000000e+02 
         -2.795075e+03:2.000000e+02 -2.785300e+03:2.009750e+02 
         -2.775675e+03:2.028750e+02 -2.766275e+03:2.057250e+02 
         -2.757200e+03:2.095000e+02 -2.748525e+03:2.141250e+02 
         -2.740350e+03:2.195750e+02 -2.732775e+03:2.258250e+02 
         -2.725825e+03:2.327750e+02 -2.719575e+03:2.403500e+02 
         -2.714125e+03:2.485250e+02 -2.709500e+03:2.572000e+02 
         -2.705725e+03:2.662750e+02 -2.702875e+03:2.756750e+02 
         -2.700975e+03:2.853000e+02 -2.700000e+03:2.950750e+02))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:2.800000e+03 -3.000000e+03:2.800000e+03 
         -2.850000e+03:2.400000e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.700000e+03:1.204925e+03 -2.700975e+03:1.214700e+03 
         -2.702875e+03:1.224325e+03 -2.705725e+03:1.233725e+03 
         -2.709500e+03:1.242800e+03 -2.714125e+03:1.251475e+03 
         -2.719575e+03:1.259650e+03 -2.725825e+03:1.267225e+03 
         -2.732775e+03:1.274175e+03 -2.740350e+03:1.280425e+03 
         -2.748525e+03:1.285875e+03 -2.757200e+03:1.290500e+03 
         -2.766275e+03:1.294275e+03 -2.775675e+03:1.297125e+03 
         -2.785300e+03:1.299025e+03 -2.795075e+03:1.300000e+03 
         -3.700000e+03:1.300000e+03 -3.700000e+03:1.100000e+03 
         -2.795075e+03:1.100000e+03 -2.785300e+03:1.100975e+03 
         -2.775675e+03:1.102875e+03 -2.766275e+03:1.105725e+03 
         -2.757200e+03:1.109500e+03 -2.748525e+03:1.114125e+03 
         -2.740350e+03:1.119575e+03 -2.732775e+03:1.125825e+03 
         -2.725825e+03:1.132775e+03 -2.719575e+03:1.140350e+03 
         -2.714125e+03:1.148525e+03 -2.709500e+03:1.157200e+03 
         -2.705725e+03:1.166275e+03 -2.702875e+03:1.175675e+03 
         -2.700975e+03:1.185300e+03 -2.700000e+03:1.195075e+03))
  dbCreatePolygon(cv list(133 -1)
    list(-2.600000e+03:-2.095075e+03 -2.600975e+03:-2.085300e+03 
         -2.602875e+03:-2.075675e+03 -2.605725e+03:-2.066275e+03 
         -2.609500e+03:-2.057200e+03 -2.614125e+03:-2.048525e+03 
         -2.619575e+03:-2.040350e+03 -2.625825e+03:-2.032775e+03 
         -2.632775e+03:-2.025825e+03 -2.640350e+03:-2.019575e+03 
         -2.648525e+03:-2.014125e+03 -2.657200e+03:-2.009500e+03 
         -2.666275e+03:-2.005725e+03 -2.675675e+03:-2.002875e+03 
         -2.685300e+03:-2.000975e+03 -2.695075e+03:-2.000000e+03 
         -3.700000e+03:-2.000000e+03 -3.700000e+03:-2.234300e+03 
         -3.677125e+03:-2.223850e+03 -3.607675e+03:-2.200725e+03 
         -3.604183e+03:-2.200000e+03 -2.695075e+03:-2.200000e+03 
         -2.685300e+03:-2.199025e+03 -2.675675e+03:-2.197125e+03 
         -2.666275e+03:-2.194275e+03 -2.657200e+03:-2.190500e+03 
         -2.648525e+03:-2.185875e+03 -2.640350e+03:-2.180425e+03 
         -2.632775e+03:-2.174175e+03 -2.625825e+03:-2.167225e+03 
         -2.619575e+03:-2.159650e+03 -2.614125e+03:-2.151475e+03 
         -2.609500e+03:-2.142800e+03 -2.605725e+03:-2.133725e+03 
         -2.602875e+03:-2.124325e+03 -2.600975e+03:-2.114700e+03 
         -2.600000e+03:-2.104925e+03))
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:2.100000e+03 "A4" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t

  label = dbCreateLabel(cv list(134 237)
                   2.099988e+03:-3.200050e+03 "B21" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   1.799988e+03:-3.200050e+03 "A20" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   1.499988e+03:-3.200050e+03 "B20" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   1.199988e+03:-3.200050e+03 "A19" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   8.999880e+02:-3.200050e+03 "B19" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   2.999880e+02:-3.200050e+03 "B18" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -1.200000e-02:-3.200050e+03 "A17" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.000120e+02:-3.200050e+03 "B17" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -6.000120e+02:-3.200050e+03 "A16" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -9.000120e+02:-3.200050e+03 "B16" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -1.200012e+03:-3.200050e+03 "A15" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -2.100012e+03:-3.200050e+03 "B14" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -1.800012e+03:-3.200050e+03 "A14" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -1.500012e+03:-3.200050e+03 "B15" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   5.999880e+02:-3.200050e+03 "A18" "centerCenter"
                   "R270" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   2.099988e+03:3.200000e+03 "B29" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   1.799988e+03:3.200000e+03 "A29" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   1.499988e+03:3.200000e+03 "B30" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   1.199988e+03:3.200000e+03 "A30" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   8.999880e+02:3.200000e+03 "B31" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   5.999880e+02:3.200000e+03 "A31" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   2.999880e+02:3.200000e+03 "B32" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -1.200000e-02:3.200000e+03 "A32" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.000120e+02:3.200000e+03 "B1" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -6.000120e+02:3.200000e+03 "A1" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -9.000120e+02:3.200000e+03 "B2" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -1.200012e+03:3.200000e+03 "A2" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -1.500012e+03:3.200000e+03 "B3" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -1.800012e+03:3.200000e+03 "A3" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:-3.000000e+02 "A24" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:-6.000000e+02 "B24" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:-1.800000e+03 "B22" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:3.000000e+02 "A25" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:0.000000e+00 "B25" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:9.000000e+02 "A26" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:1.500000e+03 "A27" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:1.200000e+03 "B27" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:2.100000e+03 "A28" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:1.800000e+03 "B28" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:6.000000e+02 "B26" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:-1.200000e+03 "B23" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:-9.000000e+02 "A23" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:-1.500000e+03 "A22" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   3.199988e+03:-2.100000e+03 "A21" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:-2.100000e+03 "A13" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:-1.500000e+03 "A10" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:-9.000000e+02 "A9" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:-1.200000e+03 "B10" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:-3.000000e+02 "A8" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:-6.000000e+02 "B9" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:-1.800000e+03 "B13" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:3.000000e+02 "A7" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:0.000000e+00 "B8" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:9.000000e+02 "A6" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:6.000000e+02 "B7" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:1.500000e+03 "A5" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:1.200000e+03 "B6" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -3.200037e+03:1.800000e+03 "B5" "centerCenter"
                   "R0" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
  label = dbCreateLabel(cv list(134 237)
                   -2.100012e+03:3.200000e+03 "B4" "centerCenter"
                   "R90" "roman" 1.500000e+02)
  label~>isDrafted = t
  label~>isOverbar = nil
  label~>isVisible = t
 
  dbCreatePolygon(cv list(141 -1)
    list(1.716270e+04:4.300625e+03 1.713730e+04:4.558485e+03 
         1.709160e+04:5.022431e+03 1.709160e+04:5.022450e+03 
         1.709147e+04:5.023700e+03 1.709125e+04:5.024925e+03 
         1.688073e+04:5.718870e+03 1.688070e+04:5.719025e+03 
         1.688033e+04:5.720225e+03 1.687985e+04:5.721375e+03 
         1.653735e+04:6.362150e+03 1.653665e+04:6.363175e+03 
         1.653585e+04:6.364150e+03 1.653585e+04:6.364151e+03 
         1.607573e+04:6.924825e+03 1.607483e+04:6.925725e+03 
         1.551415e+04:7.385849e+03 1.551415e+04:7.385850e+03 
         1.551317e+04:7.386650e+03 1.551215e+04:7.387350e+03 
         1.487138e+04:7.729850e+03 1.487023e+04:7.730325e+03 
         1.486972e+04:7.730478e+03 1.486902e+04:7.730700e+03 
         1.486893e+04:7.730717e+03 1.417492e+04:7.941250e+03 
         1.417370e+04:7.941475e+03 1.417245e+04:7.941600e+03 
         1.417243e+04:7.941600e+03 1.345062e+04:8.012700e+03 
         -1.345062e+04:8.012700e+03 -1.417243e+04:7.941600e+03 
         -1.417245e+04:7.941600e+03 -1.417370e+04:7.941475e+03 
         -1.417492e+04:7.941250e+03 -1.486887e+04:7.730728e+03 
         -1.486902e+04:7.730700e+03 -1.487023e+04:7.730325e+03 
         -1.487138e+04:7.729850e+03 -1.551215e+04:7.387350e+03 
         -1.551317e+04:7.386650e+03 -1.551415e+04:7.385850e+03 
         -1.551415e+04:7.385849e+03 -1.607483e+04:6.925725e+03 
         -1.607573e+04:6.924825e+03 -1.653585e+04:6.364151e+03 
         -1.653585e+04:6.364150e+03 -1.653665e+04:6.363175e+03 
         -1.653735e+04:6.362150e+03 -1.687985e+04:5.721375e+03 
         -1.688033e+04:5.720225e+03 -1.688048e+04:5.719720e+03 
         -1.688070e+04:5.719025e+03 -1.688072e+04:5.718933e+03 
         -1.709125e+04:5.024925e+03 -1.709147e+04:5.023700e+03 
         -1.709160e+04:5.022450e+03 -1.709160e+04:5.022431e+03 
         -1.716270e+04:4.300625e+03 -1.716270e+04:-1.650062e+04 
         -1.716258e+04:-1.650188e+04 -1.716233e+04:-1.650310e+04 
         -1.716197e+04:-1.650428e+04 -1.716150e+04:-1.650542e+04 
         -1.716090e+04:-1.650653e+04 -1.716022e+04:-1.650758e+04 
         -1.715942e+04:-1.650855e+04 -1.665855e+04:-1.700942e+04 
         -1.665758e+04:-1.701022e+04 -1.665653e+04:-1.701090e+04 
         -1.665542e+04:-1.701150e+04 -1.665428e+04:-1.701197e+04 
         -1.665310e+04:-1.701233e+04 -1.665188e+04:-1.701258e+04 
         -1.665062e+04:-1.701270e+04 -6.449375e+03:-1.701270e+04 
         -6.448125e+03:-1.701258e+04 -6.446900e+03:-1.701233e+04 
         -6.445725e+03:-1.701197e+04 -6.444575e+03:-1.701150e+04 
         -6.443475e+03:-1.701090e+04 -6.442425e+03:-1.701022e+04 
         -6.441450e+03:-1.700942e+04 -5.940575e+03:-1.650855e+04 
         -5.939775e+03:-1.650758e+04 -5.939100e+03:-1.650653e+04 
         -5.938500e+03:-1.650542e+04 -5.938025e+03:-1.650428e+04 
         -5.937675e+03:-1.650310e+04 -5.937425e+03:-1.650188e+04 
         -5.937300e+03:-1.650062e+04 -5.937300e+03:-9.550606e+03 
         -5.919234e+03:-9.367166e+03 -5.865900e+03:-9.191363e+03 
         -5.779276e+03:-9.029289e+03 -5.662733e+03:-8.887267e+03 
         -5.520711e+03:-8.770724e+03 -5.358695e+03:-8.684117e+03 
         -5.182834e+03:-8.630766e+03 -5.000000e+03:-8.612760e+03 
         -4.817166e+03:-8.630766e+03 -4.641363e+03:-8.684100e+03 
         -4.479289e+03:-8.770724e+03 -4.337267e+03:-8.887267e+03 
         -4.220724e+03:-9.029289e+03 -4.134117e+03:-9.191306e+03 
         -4.080766e+03:-9.367166e+03 -4.062700e+03:-9.550606e+03 
         -4.062700e+03:-1.650062e+04 -4.062575e+03:-1.650188e+04 
         -4.062325e+03:-1.650310e+04 -4.061975e+03:-1.650428e+04 
         -4.061500e+03:-1.650542e+04 -4.060900e+03:-1.650653e+04 
         -4.060225e+03:-1.650758e+04 -4.059425e+03:-1.650855e+04 
         -3.558550e+03:-1.700942e+04 -3.557575e+03:-1.701022e+04 
         -3.556525e+03:-1.701090e+04 -3.555425e+03:-1.701150e+04 
         -3.554275e+03:-1.701197e+04 -3.553100e+03:-1.701233e+04 
         -3.551875e+03:-1.701258e+04 -3.550625e+03:-1.701270e+04 
         1.665062e+04:-1.701270e+04 1.665188e+04:-1.701258e+04 
         1.665310e+04:-1.701233e+04 1.665428e+04:-1.701197e+04 
         1.665542e+04:-1.701150e+04 1.665653e+04:-1.701090e+04 
         1.665758e+04:-1.701022e+04 1.665855e+04:-1.700942e+04 
         1.715942e+04:-1.650855e+04 1.716022e+04:-1.650758e+04 
         1.716090e+04:-1.650653e+04 1.716150e+04:-1.650542e+04 
         1.716197e+04:-1.650428e+04 1.716233e+04:-1.650310e+04 
         1.716258e+04:-1.650188e+04 1.716270e+04:-1.650062e+04))

  dbSave(cv)
  dbClose(cv)
);let