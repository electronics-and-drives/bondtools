# bondtools

Toolbox for creating a bonding diagram in Cadence Virtuoso

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
| DEF_PAD     | drawing     | bond pads (opening in passivation)               |
| DEF_MARK    | drawing     | markings                                         |


## Usage

A bondwire can be defined by placing two labels with same name 
in the VLE (Virtuoso Layout Editor).
The first label must be placed on the bondpad and the second label must
be placed on the leadframe.

The endings of bond can be specified using the layer (*BALL* or *WEDGE*).

### SKILL

The function *EDbondtoolsDrawWires* must be invoked in the Command Interpreter Window (CIW).

``` scheme
(EDbondtoolsDrawWires 
  cv 
  fBallRadius
  fWireDiameter
  fWedgeExtension
) => t/nil
```

The parameters of the function are

`cv`

Cellview where the bondwires are created.

`fBallRadius`

Radius of a ball.

`fWireDiameter`

Diameter of the bondwire.

`fWedgeExtention`

Wedge Extension.

### GUI

The GUI of the tool can be invoked with

``` scheme
(hiDisplayForm (quote EDdrawBondWires))
```

The GUI is shown below

  <img src="./figs/gui.png" width="200">


When needed, create a corresponding menu item.
Specify the parameters is in the GUI and create the bondwires 
with *OK* or *Apply*.

An example of the bonding diagram of a multi-design chip is shown in the
screenshots shown below.

  <img src="./figs/bond1.png" width="500">
  <img src="./figs/bond2.png" width="500">
  <img src="./figs/bond3.png" width="500">

## Packages

The packages stated below are provided in the library *PACKAGES*.

### JLCC/CQFJ 

Vendor : Kyocera ([inch](https://global.kyocera.com/prdct/semicon/semi/std_pkg/pdf/kyocera-pkg-cqfj-e-inch_r0167d.pdf), [mm](https://global.kyocera.com/prdct/semicon/semi/std_pkg/pdf/kyocera-pkg-cqfj-e_r0167d.pdf))

JLCC   : J-Leaded Ceramic Chip Carrier
CQFJ   : Ceramic Quad Flat J-Leaded

| Cell Name         | Lead Count | Die Cavity (AxB) | Drawing Number  |
| ----------------- | -----------|:----------------:| ---------------:|
| JLCC_44_PB_F86315 | 44         | 0.34x0.34        |  PB-F86315      |
| JLCC_44_PB_F86315 | 68         | 0.4x0.4          |  PB-F86764      |
