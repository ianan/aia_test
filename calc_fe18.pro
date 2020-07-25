function calc_fe18, d=d, t=t,notime=notime,version=version,show=show

  ; Function to estimate the Fe18 emission from SDO/AIA data using the
  ; approach of Del Zanna (2013), https://doi.org/10.1051/0004-6361/201321653
  ; namely
  ; I(fe18) = I(94) - I(171)/450 - I(211)/120
  ; 
  ; Will also factor in the time dependent degradation of SDO/AI
  ;
  ; d -> data array of 3 as [94,171,211] data in DN/s/px
  ; t -> time in anytim format
  ;
  ; If no data provide will return correction factors and print to screen the factors
  ;
  ; 26-May-2020 IGH
  ; 20-Jul-202- IGH Updated for v9 ssw degradation

  res=-1
  if (n_elements(version) ne 1) then version=9
  if n_elements(notime) eq 0 then begin
    if (n_elements(t) ne 1) then t='09-Sep-2018 12:00'

    ids=[0,2,4]
    corr_euv = aia_bp_get_corrections(version=version)

    dtims=abs(anytim(corr_euv.utc)-anytim(t))
    tid=(where(dtims eq min(dtims)))[0]

    ; d/d0= cf => d0 = d/cf
    cf=corr_euv.ea_over_ea0[tid,ids]
  endif else begin
    ;    Just in case you don't want any time corrections
    cf=[1,1,1]
  endelse
  if (keyword_set(show) eq 1) then print,cf

  ; Fe18 factors from Del Zanna (2013)
  dzf=[1,-1/450.,-1/120.]
  ; Total multiplicative factors
  mulf=dzf/cf

  if (n_elements(d) ne 3) then begin
    print,'Correction factors are:'
    print,'I(Fe18) = '+string(mulf[0],format='(f6.4)')+' x I(94) '+$
      string(mulf[1],format='(f7.4)')+' x I(171) ' + string(mulf[2],format='(f7.4)')+' x I(211) '
    res=mulf  
  endif else begin
    res=d[0]*mulf[0] + d[1]*mulf[1] + d[2]*mulf[2]
  endelse
  
  return,res

end
