# bondtools

Toolbox for creating a bonding diagram in Cadence Virtuoso

<span style="color:red">WORK IN PROGRESS</span>

## Setup

1. Create the new library *PACKAGES* and reference(!) it on your *PDK* library.
2. Go in  the *CIW* to *Tools> Technology File Manager* and press the 
   button *Load...* .
   Follow the instructions from the screenshot and press *OK*.

    <img src="./figs/load-tech-file.png" width="400">

3. Go in  the *CIW* to *Tools> Technology File Manager* and press the 
   button *Save...* .
   Follow the instructions from the screenshot and press *OK*.

    <img src="./figs/save-tech.png" width="400">

4. Go in  the *CIW* to *Tools> Display Resource Manager* and press the
   *Merge...*.  Merge *packages.drf* with the Display Resource File *.drf* 
   of your PDK.

    <img src="./figs/merge-drf.png" width="400">

5. Go to the *CIW* and enter the command
    ``` scheme
    (load "packages.il")
    ```
5. Add the command
    ``` scheme
    (load "bondtools.il")
    ```
   to your *.cdsinit*.

## Layers

| Layer       | Purpose     | Description                                      |
| ----------- | ----------- | ------------------------------------------------ |
| PKG_MET     | drawing     | metalization in package                          |
| PKG_LBL     | label       | labels for leadframe pins                        |
| BONDWIRE    | drawing     | bondwire                                         |
| BALL        | label       | position of the ball of a bondwire               |
| WEDGE       | label       | position of the wedge of a bondwire              |
| DEF_CHIP    | drawing     | outer edge of the chip                           |
| DEF_PAD     | drawing     | bond pads (opening in passionating)              |
| DEF_MARK    | drawing     | markings                                         |

## Packages

<span style="color:red">WORK IN PROGRESS</span> 

### JLCC/CQFJ 

Vendor : Kyocera ([inch](https://global.kyocera.com/prdct/semicon/semi/std_pkg/pdf/kyocera-pkg-cqfj-e-inch_r0167d.pdf), [mm](https://global.kyocera.com/prdct/semicon/semi/std_pkg/pdf/kyocera-pkg-cqfj-e_r0167d.pdf))

JLCC   : J-Leaded Ceramic Chip Carrier
CQFJ   : Ceramic Quad Flat J-Leaded

| Lead Count | Die Cavity (AxB) | Drawing Number  |
| -----------|:----------------:| ---------------:|
| 44         | 0.34x0.34        |  PB-F86315      |
