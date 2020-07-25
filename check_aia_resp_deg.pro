pro check_aia_resp_deg

  ; check the responses and deg for some times
  ;
  ; 25-Jul-2020 IGH
  ;
  ;~~~~~~~~~~~~~~~~~~~

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