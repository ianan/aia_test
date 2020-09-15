pro make_aiaresp_forpy

  ; IDL script to produce the AIA temeprature response functions for the chosen date,
  ; then output it is a simple format that python will be happy with.
  ;
  ; 15-May-2020 IGH
  ;
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ids=[0,1,2,3,4,6]

  trespe=aia_get_response(/temp,/dn,/eve,version=9)
  channels=trespe.channels[ids]
  logt=trespe.logte
  tr=trespe.all[*,ids]
  units=trespe.units
  save,file='aia_trespv9_en.dat',channels,logt,tr,units

  trespe=aia_get_response(/temp,/dn,/eve,version=9,/chiantifix)
  channels=trespe.channels[ids]
  logt=trespe.logte
  tr=trespe.all[*,ids]
  units=trespe.units
  save,file='aia_trespv9_ench.dat',channels,logt,tr,units
  
  trespe=aia_get_response(/temp,/dn,/eve,version=9,timedepend_date='01-Jan-2014')
  channels=trespe.channels[ids]
  logt=trespe.logte
  tr=trespe.all[*,ids]
  units=trespe.units
  save,file='aia_trespv9_en20140101.dat',channels,logt,tr,units


  trespe=aia_get_response(/temp,/dn,/eve,version=8)
  channels=trespe.channels[ids]
  logt=trespe.logte
  tr=trespe.all[*,ids]
  units=trespe.units
  save,file='aia_trespv8_en.dat',channels,logt,tr,units


  stop
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; tr_01072010 / tr_0 = [1.0140375, 0.91678831, 1.1839775, 1.1948474, 1.0609241, 1.2337296]
  ; tr_e / tr_0 = [1.0140375,  0.94678238,  1.2030335,  1.2019872,  1.0747562,  1.3558809]
  ; tr_01072010 / tr_e = [1.0000000,  0.96832000,  0.98416000,  0.99406000,  0.98713000,  0.90991000]

  ;  tresp=aia_get_response(/temperature,/dn,/eve,timedepend_date='01-Jul-2010')
  ;  tresp0=aia_get_response(/temperature,/dn)
  trespe=aia_get_response(/temperature,/dn,/eve)
  ;
  clearplot
  ids=[0,1,2,3,4,6]
  channels=trespe.channels[ids]
  logt=trespe.logte
  tr=trespe.all[*,ids]
  units=trespe.units
  save,file='aia_resp_eve.dat',channels,logt,tr,units

  ;  tr0=tresp0.all[*,ids]
  ;  tre=trespe.all[*,ids]

  ;  ; The full corrections against time, for the latest version, v8
  ;
  ;  time='01-Jul-2010'
  ;
  ;  corr_euv = aia_bp_get_corrections(version=8)
  ;  tims=anytim(corr_euv.utc)
  ;  dtims=abs(tims-anytim('01-Jan-2014'))
  ;  id=(where(dtims eq min(dtims)))[0]
  ;
  ;  id18=[0,2,4]
  ;
  ;  print,reform(corr_euv.ea_over_ea0[id,id18])
  ;
  ;  ;  tlc_igh
  ;  ;  utplot,corr_euv.utc,corr_euv.ea_over_ea0[*,0],nodata,yrange=[0.1,1.1]
  ;  ;  for i=0, 5 do outplot, corr_euv.utc,corr_euv.ea_over_ea0[*,ids[i]],color=101+i,thick=2
  ;  ;
  ;  ;  id=where(tims ge anytim('01-Jul-2010') and tims lt  anytim('01-Jul-2010'))


  stop
end