* fo4.sp
*----------------------------------------------------------------------
* Parameters and models
.lib '/mnt/vol_NFS_rh003/Est_Maestria_VLSI_I_2023/fporras/tutorial/tarea1/Hspice/lpmos/xh018.lib' tm
.lib '/mnt/vol_NFS_rh003/Est_Maestria_VLSI_I_2023/fporras/tutorial/tarea1/Hspice/lpmos/param.lib' 3s
.lib '/mnt/vol_NFS_rh003/Est_Maestria_VLSI_I_2023/fporras/tutorial/tarea1/Hspice/lpmos/config.lib' default
*----------------------------------------------------------------------
.param SUPPLY=1.8 
*** La fuente es de 1.8 V para nuestro proceso
.param H=4
.param wp = 720 
*Wp es un parametro para variar el anccho del PMOS
.option scale=1
.temp 70
.option post
*----------------------------------------------------------------------
* Subcircuits
*----------------------------------------------------------------------
.global vdd gnd

***Transistor de Largo minimo y Wp/Wn = 2 con Wn = 360nm
.subckt inv gnd_1 vdd vin vout 
xm0 vout vin gnd_1 gnd_1 ne w=360n l=180n as=1.728e-13 ad=1.728e-13 ps=1.68e-06
+ pd=1.68e-06 nrs=0.75 nrd=0.75 m='(1*1)' par1='(1*1)' xf_subext=0
xm1 vout vin vdd vdd pe w=wp*1e-9 l=180n as=2.0208e-12 ad=2.0208e-12 ps=9.38e-06
+ pd=9.38e-06 nrs=0.064133 nrd=0.064133 m='(1*1)' par1='(1*1)'
.ends inv

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------
Vdd vdd gnd 'SUPPLY'
Vin a gnd PULSE 0 'SUPPLY' 0ps 5ns 5ns 15ns 40ns
X1 gnd vdd a b inv * shape input waveform
X2 gnd vdd b c inv M='H' * reshape input waveform
X3 gnd vdd c d inv M='H**2' * device under test
X4 gnd vdd d e inv M='H**3' * load
X5 gnd vdd e f inv M='H**4' * load on load
*----------------------------------------------------------------------
* Stimulus
*----------------------------------------------------------------------
.tran 0.1ps 30ns sweep wp 520 4600 5
.measure tpdr * rising prop delay
+ TRIG v(c) VAL='SUPPLY/2' FALL=1
+ TARG v(d) VAL='SUPPLY/2' RISE=1
.measure tpdf * falling prop delay
+ TRIG v(c) VAL='SUPPLY/2' RISE=1
+ TARG v(d) VAL='SUPPLY/2' FALL=1
.measure tpd param='(tpdr+tpdf)/2' * average prop delay
.measure trise * rise time
+ TRIG v(d) VAL='0.2*SUPPLY' RISE=1
+ TARG v(d) VAL='0.8*SUPPLY' RISE=1
.measure tfall * fall time
+ TRIG v(d) VAL='0.8*SUPPLY' FALL=1
+ TARG v(d) VAL='0.2*SUPPLY' FALL=1
.end

.plot tpdr tpd tpdf trise tfall

