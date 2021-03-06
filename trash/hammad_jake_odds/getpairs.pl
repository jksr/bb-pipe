$pdb = shift @ARGV;
open(DSSP, "<../inputs/$pdb/$pdb.dssp") || die "Can't open";
open(COORD, "<odds_tmp/updated_strand.coord") || die "cant open";
open(STRONG, ">odds_tmp/$pdb.strong");
open(VDW, ">odds_tmp/$pdb.vdw");
open(WEAK, ">odds_tmp/$pdb.weak");

$prid = shift @ARGV;
$strandnum = shift @ARGV;





$tag = 0;
$eventag = 0;

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



#	printf "%3d %3d %2d %s %2d %3d %3d %3d\n", $index, $res[$index], $strandc[$index], $aa[$index], $aaid[$index], $bp1[$index], $bp2[$index], $hbond[$index];

    }
    if($ar[2] eq "\#") {
	$tag = 1; }
}

$indexnum = $index;

for($i = 1 ; $i <= $indexnum ; $i++) {

    if(($bp1[$i] > 0) && ($strandc[$i] > 0) && ($strandc[$bp1[$i]] > 0)) {
	if(($strandc[$i] == ($strandc[$bp1[$i]] - 1)) || (($strandc[$i] == $strandnum) && ($strandc[$bp1[$i]] == 1))) {
	    $pairid = (10000*$prid + 100*$strandc[$i] + $strandc[$bp1[$i]]);
#	    printf OUT "%6d %3d %s %2d %3d %s %2d %d\n", $pairid, $res[$i], $aa[$i], $aaid[$i], $res[$bp1[$i]], $aa[$bp1[$i]], $aaid[$bp1[$i]], (1+($bp1[$i] != $hbond[$i]));
	    if($bp1[$i] == $hbond[$i]) {
		printf STRONG "%d %d %d %d %d\n", $prid, $res[$i], $aaid[$i], $res[$bp1[$i]], $aaid[$bp1[$i]]; }
	    else {
		printf VDW "%d %d %d %d %d\n", $prid, $res[$i], $aaid[$i], $res[$bp1[$i]], $aaid[$bp1[$i]]; }
	}
    }

    if(($bp2[$i] > 0) && ($strandc[$i] > 0) && ($strandc[$bp2[$i]] > 0)) {
	if(($strandc[$i] == ($strandc[$bp2[$i]] - 1)) || (($strandc[$i] == $strandnum) && ($strandc[$bp2[$i]] == 1))) {
	    $pairid = (10000*$prid + 100*$strandc[$i] + $strandc[$bp2[$i]]);
#	    printf OUT "%6d %3d %s %2d %3d %s %2d %d\n", $pairid, $res[$i], $aa[$i], $aaid[$i], $res[$bp2[$i]], $aa[$bp2[$i]], $aaid[$bp2[$i]], (1+($bp2[$i] != $hbond[$i]));
	    if($bp2[$i] == $hbond[$i]) {
		printf STRONG "%d %d %d %d %d\n", $prid, $res[$i], $aaid[$i], $res[$bp2[$i]], $aaid[$bp2[$i]]; }
	    else {
		printf VDW "%d %d %d %d %d\n", $prid, $res[$i], $aaid[$i], $res[$bp2[$i]], $aaid[$bp2[$i]]; }
	}
    }

    if(($bp1[$i] > 0) && ($strandc[$i] > 0)) {
	if(($strandc[$i] == ($strandc[$bp1[$i]-1] - 1)) || (($strandc[$i] == $strandnum) && ($strandc[$bp1[$i]-1] == 1))) {
	    $pairid = (10000*$prid + 100*$strandc[$i] + $strandc[$bp1[$i]-1]);
	    if($eventag) { $pairid += 5050; }
#	    printf OUT "%6d %3d %s %2d %3d %s %2d 3\n", $pairid, $res[$i], $aa[$i], $aaid[$i], $res[$bp1[$i]-1], $aa[$bp1[$i]-1], $aaid[$bp1[$i]-1];
	    printf WEAK "%d %d %d %d %d\n", $prid, $res[$i], $aaid[$i], $res[$bp1[$i]-1], $aaid[$bp1[$i]-1];
	}
    }

    if(($bp2[$i] > 0) && ($strandc[$i] > 0)) {
	if(($strandc[$i] == ($strandc[$bp2[$i]-1] - 1)) || (($strandc[$i] == $strandnum) && ($strandc[$bp2[$i]-1] == 1))) {
	    $pairid = (10000*$prid + 100*$strandc[$i] + $strandc[$bp2[$i]-1]);
	    if($eventag) { $pairid += 5050; }
#	    printf OUT "%6d %3d %s %2d %3d %s %2d 3\n", $pairid, $res[$i], $aa[$i], $aaid[$i], $res[$bp2[$i]-1], $aa[$bp2[$i]-1], $aaid[$bp2[$i]-1]; 
	    printf WEAK "%d %d %d %d %d\n", $prid, $res[$i], $aaid[$i], $res[$bp2[$i]-1], $aaid[$bp2[$i]-1];
	}
    }
    $eventag = (($eventag+1) % 2);

}






