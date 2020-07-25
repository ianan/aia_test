pro check_aia_resp_deg

  ; check the responses and deg for some times
  ;
  ; 25-Jul-2020 IGH
  ;
  ;~~~~~~~~~~~~~~~~~~~



  cv9 = aia_bp_get_corrections(version=9)
  cv8 = aia_bp_get_corrections(version=8)
  
  !p.font=1
  !p.charsize=3
  tlc_igh
  gd=[0,1,2,3,4,6]
  !p.thick=2
  !p.multi=[0,3,2]
  for i=0, 5 do begin
    utplot,cv8.utc,replicate(1,n_elements(cv8.utc)),yrange=[0.1,1.3],ytit='ea/ea0',$
      tit=string(cv8.channels[gd[i]])+'A: v8 (solid), v9 (dashed)',thick=1
    outplot,cv8.utc,cv8.ea_over_ea0[*,gd[i]],color=101+i
    outplot,cv9.utc,cv9.ea_over_ea0[*,gd[i]],color=101+i,lines=2
  endfor


  stop

  t1='26-Apr-2019'
  t2='21-Feb-2020'

  tr1v8=aia_get_response(/temperature,/dn,/chianti,/noblend,/evenorm,timedepend_date=t1,version=8)
  tr1v9=aia_get_response(/temperature,/dn,/chianti,/noblend,/evenorm,timedepend_date=t1,version=9)

  tr2v8=aia_get_response(/temperature,/dn,/chianti,/noblend,/evenorm,timedepend_date=t2,version=8)
  tr2v9=aia_get_response(/temperature,/dn,/chianti,/noblend,/evenorm,timedepend_date=t2,version=9)

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