$pdb = shift @ARGV;
$ref = shift @ARGV;

open(ROT, "<$pdb.rot") || die "cant";
open(IN, "<$pdb.atom") || die "cant";
open(OUT, ">$pdb.out");

$i = 0;
while(<ROT>) {
    chomp;
    @ar = split(/\s+/, $_);
    $rot[$i][0] = $ar[0];
    $rot[$i][1] = $ar[1];
    $rot[$i][2] = $ar[2];
    $i++;
}

$i = 0;
while(<IN>) {
    chomp;
    @a = split(/\s+/, $_);
    $x = $a[6];
    $y = $a[7];
    $z = $a[8];
    $xi[$i] = $x*$rot[0][0] + $y*$rot[0][1] + $z*$rot[0][2];
    $zi[$i] = $x*$rot[1][0] + $y*$rot[1][1] + $z*$rot[1][2];
    $yi[$i] = $x*$rot[2][0] + $y*$rot[2][1] + $z*$rot[2][2];
    if(($a[5] == $ref) && ($a[2] eq "CA")) {
	$rx = $xi[$i];
	$ry = $yi[$i];
	$rz = $zi[$i]; }
    $i++;
}
$max = $i;

for($i = 0 ; $i < $max ; $i++) {
    $xi[$i] -= $rx;
    $yi[$i] -= $ry;
    $zi[$i] -= $rz;
    if(($zi[$i] >= 0) && ($zi[$i] <= 27)) {
	$xsum += $xi[$i];
	$ysum += $yi[$i];
	$zsum += $zi[$i];
	$tot++; }
}

$ox = $xsum / $tot;
$oy = $ysum / $tot;
$oz = $zsum / $tot;

seek IN, 0, 0;

$i = 0;
while(<IN>) {
    chomp;
    @a = split(/\s+/, $_);
    $a[6] = $xi[$i] - $ox;
    $a[7] = $yi[$i] - $oy;
    $a[8] = $zi[$i] - $oz;
    printf OUT "%4s %6d  %-3s %3s %s %3d     %7.3f %7.3f %7.3f %5.2f %5.2f          %2s\n", $a[0], $a[1], $a[2], $a[3], $a[4], $a[5], $a[6], $a[7], $a[8], $a[9], $a[10], $a[11];
    $i++;
}

$i++;
printf OUT "ATOM %6d  C   CYS A9000       0.000   0.000   0.000  1.00 00.00           C\n", $i++;

for($x = -20 ; $x <= 20 ; $x++) {
    for($y = -20 ; $y <= 20 ; $y++) {
	printf OUT "ATOM %6d  C   CYS A9001     %7.3f %7.3f %7.3f  1.00 00.00           C\n", $i++, $x, $y, -13.5;
    }
}
for($x = -20 ; $x <= 20 ; $x++) {
    for($y = -20 ; $y <= 20 ; $y++) {
	printf OUT "ATOM %6d  C   CYS A9001     %7.3f %7.3f %7.3f  1.00 00.00           C\n", $i++, $x, $y, 13.5;
    }
}
