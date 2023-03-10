* Optimizacion de Wp para un inversor
*----------------------------------------------------------------------
* Parameters and models
*----------------------------------------------------------------------

* Parameters and models
.lib '/mnt/vol_NFS_rh003/Est_Maestria_VLSI_I_2023/fporras/tutorial/tarea1/Hspice/lpmos/xh018.lib' tm
.lib '/mnt/vol_NFS_rh003/Est_Maestria_VLSI_I_2023/fporras/tutorial/tarea1/Hspice/lpmos/param.lib' 3s
.lib '/mnt/vol_NFS_rh003/Est_Maestria_VLSI_I_2023/fporras/tutorial/tarea1/Hspice/lpmos/config.lib' default

.param SUPPLY=1.8
.option scale=1
.temp 70
.option post
*----------------------------------------------------------------------
* Subcircuits
*----------------------------------------------------------------------
.subckt inv gnd_1 vdd vin vout N=360 P=720
xm0 vout vin gnd_1 gnd_1 ne w=N*1e-9 l=180n as=1.728e-13 ad=1.728e-13 ps=1.68e-06
+ pd=1.68e-06 nrs=0.75 nrd=0.75 m='(1*1)' par1='(1*1)' xf_subext=0
xm1 vout vin vdd vdd pe w=P*1e-9 l=180n as=2.0208e-12 ad=2.0208e-12 ps=9.38e-06
+ pd=9.38e-06 nrs=0.064133 nrd=0.064133 m='(1*1)' par1='(1*1)'
.ends inv

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------
Vdd vdd gnd 'SUPPLY'
Vin a gnd PULSE 0 'SUPPLY' 0 5ns 5ns 15ns 40ps
X1 gnd vdd a b inv P='P1' * shape input waveform
X2 gnd vdd b c inv P='P1' M=4 * reshape input waveform
X3 gnd vdd c d inv P='P1' M=16 * device under test
X4 gnd vdd d e inv P='P1' M=64 * load
X5 gnd vdd e f inv P='P1' M=256 * load on load
*----------------------------------------------------------------------
* Optimization setup
*----------------------------------------------------------------------
.param P1=optrange(1056,520,1600) * busca de 520nm a 920nm iniciando en 720
.model optmod opt itropt=100 * maximum of 30 iterations
.measure bestratio param='P1/360' * compute best P/N ratio
*----------------------------------------------------------------------
* Stimulus
*----------------------------------------------------------------------
.tran 0.1ps 30ns SWEEP OPTIMIZE=optrange RESULTS=tpd MODEL=optmod
.measure tpdr * rising propagation delay
+ TRIG v(c) VAL='SUPPLY/2' FALL=1
+ TARG v(d) VAL='SUPPLY/2' RISE=1
.measure tpdf * falling propagation delay
+ TRIG v(c) VAL='SUPPLY/2' RISE=1
+ TARG v(d) VAL='SUPPLY/2' FALL=1
.measure tpd param='(tpdr+tpdf)/2' goal=0 * average prop delay
.measure diff param='tpdr-tpdf' goal = 0 * diff between delays
.end
