# only some programs from elfutils
{ elfutils, runCommandLocal }: runCommandLocal "elfutils" {} /* bash */ ''
  mkdir -p $out/bin

  for f in readelf strings; do
    ln -vsfT ${elfutils}/bin/eu-$f $out/bin/$f
  done
''
