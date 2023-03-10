*  Generated for: FineSimPro
*  Design library name: tarea1
*  Design cell name: inverter1x_tb_isc
*  Design view name: schematic


.temp 25
.lib '/mnt/vol_NFS_rh003/Est_Maestria_VLSI_I_2023/fporras/tutorial/tarea1/Hspice/lpmos/xh018.lib' wz  
.lib '/mnt/vol_NFS_rh003/Est_Maestria_VLSI_I_2023/fporras/tutorial/tarea1/Hspice/lpmos/param.lib' 3s
.lib '/mnt/vol_NFS_rh003/Est_Maestria_VLSI_I_2023/fporras/tutorial/tarea1/Hspice/lpmos/config.lib' default

*Custom Compiler Version R-2020.12-SP1
*Thu Mar  9 14:13:05 2023
.PARAM cl = 1f
.global gnd!
********************************************************************************
* Library          : tarea1
* Cell             : inverter1x
* View             : schematic
* View Search List : hspice hspiceD schematic cmos_sch spice veriloga
* View Stop List   : hspice hspiceD
********************************************************************************
.subckt inverter1x gnd_1 vdd vin vout
xm0 vout vin gnd_1 gnd_1 ne w=360n l=180n as=1.728e-13 ad=1.728e-13 ps=1.68e-06
+ pd=1.68e-06 nrs=0.75 nrd=0.75 m='(1*1)' par1='(1*1)' xf_subext=0
xm1 vout vin vdd vdd pe w=4.21u l=180n as=2.0208e-12 ad=2.0208e-12 ps=9.38e-06
+ pd=9.38e-06 nrs=0.064133 nrd=0.064133 m='(1*1)' par1='(1*1)'
.ends inverter1x

********************************************************************************
* Library          : tarea1
* Cell             : inverter1x_tb_isc
* View             : schematic
* View Search List : hspice hspiceD schematic cmos_sch spice veriloga
* View Stop List   : hspice hspiceD
********************************************************************************
xi0 gnd! net7 net5 net12 inverter1x
v2 net7 gnd! dc=1.8
v5 net5 gnd! dc=0
c9 net12 gnd! c=cl

*.probe tran isub(xi0.xm1.s)
.dc v5 0 1.8 0.01
.option opfile=1 split_dp=1
.option probe =1
.probe tran v(*) isub(*) level = 5 
.plot v(*)
.probe v(*)

.option post probe



.end
