# bondtools

Toolbox for creating a bonding diagram in Cadence Virtuoso

<span style="color:red">WORK IN PROGRESS</span>

## Setup

1. Create the new library *PACKAGES* and reference it on your *PDK* library.
2. Go in  the *CIW* to *Tools> Technology File Manager* and press the 
   button *Load...* .
   Follow the instructions from the screenshot and press *OK*.

    <img src="./figs/load-tech-file.png" width="400">

3. Go in  the *CIW* to *Tools> Display Resource Manager* and press the
   *Merge...*.  Merge *packages.drf* with the Display Resource File *.drf* 
   of your PDK.

    <img src="./figs/merge-drf.png" width="400">

4. Go to the *CIW* and enter the command
    ``` scheme
    (load "packages.il")
    ```
4. Add the command
    ``` scheme
    (load "bondtools.il")
    ```
   to your *.cdsinit*.