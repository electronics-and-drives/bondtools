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

(pcDefinePCell
 (list (ddGetObj "PACKAGES") "JLCC_44_PB_F86315" "layout")
 (
    (scale     float   1.0)
    (grid      float 0.025)
    (labelSize float 150.0)
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
      (lambda (cv x x1 x2 pitch width grid idx num_of_pins labelSize)
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
              (lsprintf "%L" idx) 
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
      );funcall
    );for
  );let
);pcDefinePCell

(pcDefinePCell
 (list (ddGetObj "PACKAGES") "JLCC_68_PB_F86764" "layout")
 (
    (scale     float   1.0)
    (grid      float 0.025)
    (labelSize float 150.0)
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
      (lambda (cv x x1 x2 pitch width grid idx num_of_pins labelSize)
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
              (lsprintf "%L" idx) 
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
      );funcall
    );for
  );let
);pcDefinePCell