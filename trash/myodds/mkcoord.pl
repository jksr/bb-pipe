$pdb = shift @ARGV;
$prid = shift @ARGV;
open(IN, "<temp/$pdb.out") || die "Cant";
open(DSSP, "<temp/$pdb.struct");
open(OUT, ">temp/$pdb.coord");

while(<DSSP>) {
    chomp;
    ($res, $str) = split(/ /, $_);
    if($str eq "E") { $struct[$res] = 1; }
    else { $struct[$res] = 0; }
}

while(<IN>) {
    chomp;
    @ar = split(/\s+/, $_);
    if(($ar[4] eq "A9000") || ($ar[4] eq "A9001")) { next; }
    $atom = $ar[2];
    if($atom eq "CA") {
	$res = $ar[5];
	$aaid = aatoid($ar[3]);
	if($aaid == 7) {
	    if($fac == 1) { $fac = 2; }
	    else { $fac = 1; }
	}
	$x = $ar[6];
	$y = $ar[7];
	$z = $ar[8];
	$loc = 0;
	if(($z >= -20.5) && ($z < -6.5)) { $loc = 1; }
	if(($z >= 6.5) && ($z < 20.5)) { $loc = 5; }
	if(($z >= -13.5) && ($z < -6.5) && $struct[$res]) { $loc = 2; }
	if(($z >= -6.5) && ($z < 6.5) && $struct[$res]) { $loc = 3; }
	if(($z >= 6.5) && ($z < 13.5) && $struct[$res]) { $loc = 4; }
	if($aaid == 7) {
	printf OUT "%2d %3d %2d %7.3f %7.3f %7.3f %d %d %d\n", $prid, $res, $aaid, $x, $y, $z, $loc, (($loc > 1) && ($loc < 5))*$fac, $struct[$res];
	}
    }
    if($atom eq "CB") {
	if(($x*$x + $y*$y) < ($ar[6]*$ar[6] + $ar[7]*$ar[7])) { $fac = 2; }
	else { $fac = 1; }
	printf OUT "%2d %3d %2d %7.3f %7.3f %7.3f %d %d %d\n", $prid, $res, $aaid, $x, $y, $z, $loc, (($loc > 1) && ($loc < 5))*$fac, $struct[$res];
    }
}


sub aatoid {
    my $aa = $_[0];
    if($aa eq "ALA") { return  0; }
    if($aa eq "ARG") { return  1; }
    if($aa eq "ASN") { return  2; }
    if($aa eq "ASP") { return  3; }
    if($aa eq "CYS") { return  4; }
    if($aa eq "GLN") { return  5; }
    if($aa eq "GLU") { return  6; }
    if($aa eq "GLY") { return  7; }
    if($aa eq "HIS") { return  8; }
    if($aa eq "ILE") { return  9; }
    if($aa eq "LEU") { return 10; }
    if($aa eq "LYS") { return 11; }
    if($aa eq "MET") { return 12; }
    if($aa eq "MSE") { return 12; }
    if($aa eq "PHE") { return 13; }
    if($aa eq "PRO") { return 14; }
    if($aa eq "SER") { return 15; }
    if($aa eq "THR") { return 16; }
    if($aa eq "TRP") { return 17; }
    if($aa eq "TYR") { return 18; }
    if($aa eq "VAL") { return 19; }
}

sub aatoid1 {
    my $aa = $_[0];
    if($aa eq "A") { return  0; }
    if($aa eq "R") { return  1; }
    if($aa eq "N") { return  2; }
    if($aa eq "D") { return  3; }
    if($aa eq "C") { return  4; }
    if($aa eq "Q") { return  5; }
    if($aa eq "E") { return  6; }
    if($aa eq "G") { return  7; }
    if($aa eq "H") { return  8; }
    if($aa eq "I") { return  9; }
    if($aa eq "L") { return 10; }
    if($aa eq "K") { return 11; }
    if($aa eq "M") { return 12; }
    if($aa eq "F") { return 13; }
    if($aa eq "P") { return 14; }
    if($aa eq "S") { return 15; }
    if($aa eq "T") { return 16; }
    if($aa eq "W") { return 17; }
    if($aa eq "Y") { return 18; }
    if($aa eq "V") { return 19; }
}

