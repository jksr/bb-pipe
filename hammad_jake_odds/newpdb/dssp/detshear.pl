$a = shift @ARGV;
$b = shift @ARGV;
open(DSSP, "<$a") || die "Can't open";
open(COORD, "<strand.coord") || die "cant open";
open(COM, ">$b");

$pdb = shift @ARGV;
$prid = shift @ARGV;
$strandnum = shift @ARGV;

$tag = 0;

while(<COORD>) {
    chomp;
    @array = split(/ /, $_);
    if($array[0] == $prid) {
	$strand[$array[2]] = $array[1];
	$amino[$array[2]] = $array[3]; }
}

while(<DSSP>) {
    chomp;
    @ar = split(//, $_);
    if($tag == 1) {
	$index = ($ar[0] . $ar[1] . $ar[2] . $ar[3] . $ar[4]);
	$res[$index] = ($ar[5] . $ar[6] . $ar[7] . $ar[8] . $ar[9]);
	if($prid == 19) {
	    $res[$index] -= 700; }
	$aa[$index] = $ar[13];
	$bp1[$index] = ($ar[25] . $ar[26] . $ar[27] . $ar[28]);
	$bp2[$index] = ($ar[29] . $ar[30] . $ar[31] . $ar[32]);
	$hbond[$index] = ($ar[39] . $ar[40] . $ar[41] . $ar[42] . $ar[43] . $ar[44]);
	$hbond[$index] += $index;

	$strandc[$index] = $strand[$res[$index]];
	$aaid[$index] = $amino[$res[$index]];



#	printf OUT "%3d %3d %2d %s %2d %3d %3d %3d\n", $index, $res[$index], $strandc[$index], $aa[$index], $aaid[$index], $bp1[$index], $bp2[$index], $hbond[$index];

    }
    if($ar[2] eq "\#") {
	$tag = 1; }
}

$indexnum = $index;
$laststrand = 0;
$lastres = 0;
$firststartindex = 0;

for($i = 1 ; $i <= ($indexnum+1) ; $i++) {

    if(($strandc[$i] > 0) && ($laststrand == 0)) {
	$strandstart[$strandc[$i]] = ($res[$i]-3);
	if($firststartindex == 0) {
	    $firststartindex = $i; }
	$tag = 0;
	for($j = ($i+1) ; $tag == 0 ; $j++) {
	    if($bp1[$j] > 0) {
		$tag = 1;
		$shear[$strandc[$i]] = (($res[$j]-$res[$i])+($res[$bp1[$j]]-($strandstart[$strandc[$i]-1]-3)));
	    }
	}
    }
    if(($strandc[$i] < 1) && ($laststrand > 0) && (($laststrand % 2) == 0)) {
	$strandstart[$laststrand] = ($res[$i-1]+3);
	$tag = 0;
	for($j = ($i-2) ; $tag == 0 ; $j--) {
	    if($bp1[$j] > 0) {
		$tag = 1;
		$shear[$strandc[$i-1]] = (($res[$i-1]-$res[$j])-($res[$bp1[$j]]-($strandstart[$strandc[$i-1]-1]+3)));
	    }
	}
	$finalstrand = $laststrand;
    }
    if(($strandc[$i] < 1) && ($laststrand > 0) && ($laststrand == $strandnum)) {
	$strandstart[$laststrand] = ($res[$i-1]+3);
	$tag = 0;
	for($j = ($i-2) ; $tag == 0 ; $j--) {
	    if($bp2[$j] > 0) {
		$tag = 1;
		$shear[$strandc[$i-1]] = (($res[$i-1]-$res[$j])-($res[$bp2[$j]]-($strandstart[$strandc[$i-1]-1]+3)));
	    }
	}
	$finalstrand = $laststrand;
    }

    if($res[$i] > 0) {
	$lastres = $res[$i]; }

    $laststrand = $strandc[$i];
}

$i = $firststartindex;
$tag = 0;
for($j = ($i+1) ; $tag == 0 ; $j++) {
    if($bp2[$j] > 0) {
	$tag = 1;
	$shear[1] = (($res[$j]-$res[$i])+($res[$bp2[$j]]-($strandstart[$strandnum]-3)));
    }
}

print COM "perl model.pl inputs/$pdb/$pdb.res inputs/$pdb/$pdb.self ../newpairs/strong/$pdb.strong.contact ../newpairs/vdw/$pdb.vdw.contact ../newpairs/weak/$pdb.weak.contact $pdb.out $lastres $strandnum";
for($i = 1 ; $i <= $finalstrand ; $i++) {
    $sheartot += $shear[$i];
    printf COM " %d %d", $strandstart[$i], $shear[$i]; }
print COM "\n";
print "Shearing Number = $sheartot\n";


