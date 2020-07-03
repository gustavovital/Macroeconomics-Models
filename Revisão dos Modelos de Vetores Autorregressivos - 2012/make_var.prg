'Sample for estimation (Eviews format)
%esmpl="@first 2018m12"

' Sample for forecasting (Eviews format) 
%fsmpl="2018m12 2019m12"

'Number of bands in fanchart starting from 90%. 
'For example, !numb=1 plots 90% band and the mode, 
'!numb=2 plots 90% band, 45% band and the mode 
!numb=3

'Do not change the 2 parameters below unless you are adapting the code
' for your own model
'Name of the model to be used for constructing a fan chart
%modname="mod"

'Variable to forecast (has to be one of the model variables)
%varname="ipca"

smpl {%esmpl}
'=========== Model specification =========
'replace the two lines below with your model of inflation if you want
var eq1.ls 1 6 {%varname} d_ibcbr d_cambio
eq1.makemodel({%modname}) 
'=============== Main Fan Chart Program==============
%quant_array="90 "
!quant_step=90/!numb
!k=90-!quant_step
while !k>5 
%quant_array=%quant_array+@str(@round(!k))+" "
!k=!k-!quant_step
wend
%quant_array=%quant_array+"1"

delete(noerr) g2
group g2

for %quant {%quant_array}  
	!alfa={%quant} 'current confidence level
	smpl {%fsmpl}
	!alfa_ratio=!alfa/100 
	
	!num_simul=100000

	
	{%modname}.stochastic(i=b, b=!alfa_ratio,c=t,r=!num_simul)
			

	{%modname}.solveopt(s=b,d=d)
	{%modname}.solve
	
	%first_elem_fsmpl=@wleft(%fsmpl,1)
	%second_elem_fsmpl=@wright(%fsmpl,1)
	
	smpl {%first_elem_fsmpl} {%first_elem_fsmpl}
	{%varname}_0h={%varname}
	{%varname}_0l={%varname}
	
	smpl {%first_elem_fsmpl}-12 {%second_elem_fsmpl}
	if !alfa<3 then
		%quant="0"
	endif
	series {%varname}_{%quant}h_={%varname}_0h
	series {%varname}_{%quant}l_={%varname}_0l
	g2.add {%varname}_{%quant}l_ {%varname}_{%quant}h_

next
series p1={%varname}
g2.add {%varname} p1
freeze(fanchart, mode=overwrite) g2.band(o="classic")

fanchart.legend -display
for !i=1 to !numb+1
	!r=@round((1-0.275*@sqrt(!i) )*255)
	!b=@round((1-0.275*@sqrt(!i) )*255)
	!g=@round((1-0.275*@sqrt(!i) )*255)
	fanchart.setelem(!i) fcolor(@rgb(!r,!g,!b))
next

!numline=!numb+2
fanchart.setelem(!numline) fcolor(black)

fanchart.draw(shade,b) {%fsmpl}
show fanchart

smpl @all

