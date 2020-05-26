pro test_fe18calc

  ; How does the degredation effect the Fe18 calcualtion?

  ; The data = DEM * TR -> where TR is the temperature response at time of obs
  ;
  ; TR / TR0 = f -> where f is the correction or degradation factor, TR0 the uneffected TR
  ; so TR = TR0 * f => data = DEM * TR0 * f ( so => data / data0 = f)


  ; Fe18 = 94A  - 171A/450. - 211A/120.

    ; Work out resp without any time_dependendt changes
    ; Units of DM cm^5 s^-1 px^-1
    t0=aia_get_response(/temperature,/dn,/eve)
    save,file='tr0.dat',t0
  restore,file='tr0.dat'

  ids=[0,2,4]
  tr0=t0.all[*,ids]
  logt=t0.logte

  tlc_igh

  ;  plot,logt,tr0[*,0],/ylog,yrange=[1d-28,1d-23],ystyle=17
  ;  for i=0,2 do oplot, logt,tr0[*,i],color=101+ids[i],thick=4
  fetr0=tr0[*,0]-tr0[*,1]/450.-tr0[*,2]/211.
  ;  oplot,logt,fetr0,color=107,lines=2,thick=4

  ;  Assume plasma of two temperatures each with same EM
  logt1=alog10(1e6)
  logt2=alog10(7e6)

  em=1d28

  trlogt1=dblarr(3)
  trlogt2=dblarr(3)

  for i=0,2 do trlogt1[i]=10d^(interpol(alog10(tr0[*,i]),logt,logt1))
  for i=0,2 do trlogt2[i]=10d^(interpol(alog10(tr0[*,i]),logt,logt2))

  g0=dblarr(3)
  g0=trlogt1*em + trlogt2*em

  fe180=g0[0] - g0[1]/450. - g0[2]/120.

  ; Load in the correction factors
  corr_euv = aia_bp_get_corrections(version=8)
  ctims=corr_euv.utc
  cf=corr_euv.ea_over_ea0[*,ids]

  nt=n_elements(ctims)
  g=dblarr(nt,3)
  fe18=dblarr(nt)

  ; work out the degraded data [94A, 171A, 211A] and then for Fe18 as a function of time
  for t=0, nt-1 do g[t,*]=trlogt1*em*cf[t,*] + trlogt2*em*cf[t,*]
  for t=0, nt-1 do fe18[t]=g[t,0] - g[t,1]/450. - g[t,2]/120.


  !p.multi=[0,1,3]
  !p.charsize=2
  ; This is the fe18 that would be calculated for each time
  utplot,ctims,fe18

  ; Work out the corrected response factor for each time at logt=6.85
  idt=57
  trfe18=dblarr(nt)
  for t=0, nt-1 do trfe18[t]=(tr0[idt,0]*cf[t,0])-(tr0[idt,1]*cf[t,1])/450.-(tr0[idt,2]*cf[t,2])/211.


  emts=fe18/trfe18
  emt0=fe180/fetr0[idt]
  ; Then plot the resulting EM you would calculate from this
  utplot,ctims,emts,yrange=[3e27,6e27],ystyle=17
  outplot,anytim(minmax(anytim(ctims)),/yoh),[1,1]*emt0

  clearplot
  !p.multi=0
  !p.charsize=1.2
  utplot,ctims,emt0/emts,yrange=[0.7,1.3],ystyle=17,xstyle=17,psym=3,$
    ytitle='Fe18 EM_{data_cor} / EM_{tr_cor} @ logT=6.85',xtimer=['01-May-2010','01-May-2020']
  outplot,anytim(minmax(anytim(ctims)),/yoh),[1,1],lines=2,color=10
  



  stop
end