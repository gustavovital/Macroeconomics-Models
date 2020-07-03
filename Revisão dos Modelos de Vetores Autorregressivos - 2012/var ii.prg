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
var eq1.ls 1 6 {%varname} d_cambio selic administrados livres m2 ipi_d11
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

	
	{%modname}.stochastic(i=b, b=!alfa_ratio,r=!num_simul)
			

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

g2.add {%varname}_{%quant}l_ {%varname}_{%quant}h_

series p1={%varname}
g2.add {%varname} p1
freeze(fanchart, mode=overwrite) g2.band(o="classic")

fanchart.legend -display
for !i=1 to !numb+1
	!r=@round((1-0.375*@sqrt(!i) )*255)
	!b=@round((1-0.375*@sqrt(!i) )*255)
	!g=@round((1-0.375*@sqrt(!i) )*255)
	fanchart.setelem(!i) fcolor(@rgb(!r,!g,!b))
next

!numline=!numb+2
fanchart.setelem(!numline) fcolor(black)

fanchart.draw(shade,b) {%fsmpl}
show fanchart

' cria tabela, o default é para 3 intervalos de confiança 30 60 90

smpl 2019m1 @last

g2.add {%varname}_0m

freeze(matriz) g2 

table(13, 8) previsoes

setcell(previsoes, 1,1, "Data")
setcell(previsoes, 1,2, "90%")
setcell(previsoes, 1,3, "60%")
setcell(previsoes, 1,4, "30%")
setcell(previsoes, 1,5, "Central")
setcell(previsoes, 1,6, "30%")
setcell(previsoes, 1,7, "60%")
setcell(previsoes, 1,8, "90%")

for !i=3 to 14

	setcell(previsoes, !i-1,1, matriz(!i, 1))
	setcell(previsoes, !i-1,2, @val(matriz(!i, 2)))
	setcell(previsoes, !i-1,3, @val(matriz(!i, 4)))
	setcell(previsoes, !i-1,4, @val(matriz(!i, 6)))
	setcell(previsoes, !i-1,5, @val(matriz(!i, 9)))
	setcell(previsoes, !i-1,6, @val(matriz(!i, 7)))
	setcell(previsoes, !i-1,7, @val(matriz(!i, 5)))
	setcell(previsoes, !i-1,8, @val(matriz(!i, 3)))
	
	previsoes.setformat(!i-1,b) f.2
	previsoes.setformat(!i-1,c) f.2
	previsoes.setformat(!i-1,d) f.2
	previsoes.setformat(!i-1,e) f.2
	previsoes.setformat(!i-1,f) f.2
	previsoes.setformat(!i-1,g) f.2
	previsoes.setformat(!i-1,h) f.2
	
next

for !i=1 to !numb+1

	!r=@round((1-0.200*@sqrt(!i) )*255)
	!b=@round((1-0.200*@sqrt(!i) )*255)
	!g=@round((1-0.200*@sqrt(!i) )*255)

	if !i == 1 then
		previsoes.setfillcolor(H) @rgb(!r,!g,!b)
		previsoes.setfillcolor(B) @rgb(!r,!g,!b)
	else
		if !i == 2 then
			previsoes.setfillcolor(G) @rgb(!r,!g,!b)
			previsoes.setfillcolor(C) @rgb(!r,!g,!b)
		else
			if !i == 3 then
				previsoes.setfillcolor(D) @rgb(!r,!g,!b)
				previsoes.setfillcolor(F) @rgb(!r,!g,!b)
			else 
				previsoes.setfillcolor(E) @rgb(!r,!g,!b)
			endif
		endif
	endif
		
next

previsoes.setlines(a1:h1) +b
previsoes.setlines(a13:h13) +b

previsoes.setlines(a) +r
previsoes.setlines(b) +r
previsoes.setlines(c) +r
previsoes.setlines(d) +r
previsoes.setlines(e) +r		
previsoes.setlines(f) +r
previsoes.setlines(g) +r
previsoes.setlines(h) +r

previsoes.setjust(@all) center
previsoes.setwidth(@all) 7
previsoes.setwidth(a) 10

delete(noerr) matriz
show previsoes




smpl @all


