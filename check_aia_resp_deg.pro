pro check_aia_resp_deg

  ; check the responses and deg for some times
  ;
  ; 25-Jul-2020 IGH
  ; 04-Nov-2020 IGH, updated for v10
  ;~~~~~~~~~~~~~~~~~~~

  @post_outset
  cv10= aia_bp_get_corrections(version=10)
  cv9 = aia_bp_get_corrections(version=9)
  cv8 = aia_bp_get_corrections(version=8)

  !p.charsize=1.5
  tlc_igh
  
  figname='aia_degcor_v8910.eps'
  set_plot,'ps'
  device, /encapsulated, /color, /isolatin1,/inches, $
    bits=8, xsize=12, ysize=5,file=figname
 
  gd=[0,1,2,3,4,6]
  !p.thick=4
  !p.multi=[0,3,2]
  tr=['2010-01-01T00:00:00','2021-01-01T00:00:00']
  for i=0, 5 do begin
    utplot,tr,[1,1],yrange=[0.1,1.3],ytit='EA(t)/EA(t!D0!N)',$
      tit=strcompress(string(cv8.channels[gd[i]]),/rem)+string(197b)+': v8 (dotted), v9 (dashed), v10 (solid)',thick=1,$
      timerange=tr,/y2k
    outplot,cv8.utc,cv8.ea_over_ea0[*,gd[i]],color=101+i,lines=1
    outplot,cv9.utc,cv9.ea_over_ea0[*,gd[i]],color=101+i,lines=2
    outplot,cv10.utc,cv10.ea_over_ea0[*,gd[i]],color=101+i
  endfor
  
  
  device,/close
  set_plot, mydevice
  
  spawn,'mogrify -density 100 -flatten -quality 85 -format png ' +figname
  spawn,'rm -f '+figname

;stop
;  convert_eps2pdf,figname,/del


  stop

  t1='26-Apr-2019'
  t2='21-Feb-2020'

  ;  v10 same as v9
  tr1v8=aia_get_response(/temperature,/dn,/chianti,/noblend,/evenorm,timedepend_date=t1,version=8)
  tr1v9=aia_get_response(/temperature,/dn,/chianti,/noblend,/evenorm,timedepend_date=t1,version=9)
  ;  tr1v10=aia_get_response(/temperature,/dn,/chianti,/noblend,/evenorm,timedepend_date=t1,version=10)

  tr2v8=aia_get_response(/temperature,/dn,/chianti,/noblend,/evenorm,timedepend_date=t2,version=8)
  tr2v9=aia_get_response(/temperature,/dn,/chianti,/noblend,/evenorm,timedepend_date=t2,version=9)
  ;  tr2v10=aia_get_response(/temperature,/dn,/chianti,/noblend,/evenorm,timedepend_date=t2,version=10)


  tlc_igh
  gd=[0,1,2,3,4,6]
  !p.thick=2
  !p.multi=[0,1,2]
  plot,[1,1],[1,1],/nodata,xtit='Temperature [MK]',ytit='Response [DN cm5/s/px]',$
    /xlog,xrange=[2e5,5e7],/ylog,yrange=[9d-29,5d-24],tit=t1+': v8 (solid), v9 (dashed)'
  for i=0,5 do oplot,10^tr1v8.logte,tr1v8.all[*,gd[i]],color=101+i
  for i=0,5 do oplot,10^tr1v9.logte,tr1v9.all[*,gd[i]],color=101+i,lines=2

  plot,[1,1],[1,1],/nodata,xtit='Temperature [MK]',ytit='Response [DN cm5/s/px]',$
    /xlog,xrange=[2e5,5e7],/ylog,yrange=[9d-29,5d-24],tit=t2+': v8 (solid), v9 (dashed)'
  for i=0,5 do oplot,10^tr2v8.logte,tr2v8.all[*,gd[i]],color=101+i
  for i=0,5 do oplot,10^tr2v9.logte,tr2v9.all[*,gd[i]],color=101+i,lines=2


  stop
end