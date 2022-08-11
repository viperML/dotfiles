{runCommandLocal}:
runCommandLocal "present" {
  __nocachix = true;
} ''
  mkdir -p $out
  for ((i=0;i<NIX_BUILD_CORES;i++)); do
    echo "spawning present $i"
    touch $out/present-$i
    dd if=/dev/urandom of=$out/present-$i bs=4M count=$[2**63-1] &
  done

  echo "Getting your present ready..."
  wait
''
