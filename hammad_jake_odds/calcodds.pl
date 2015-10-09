$a = shift @ARGV;
$b = shift @ARGV;
open(IN, "<$a") || die "cant open";
open(OUT, ">$b");

$length = 1;

while(<IN>) {
    chomp;
    ($pair, $aa1, $aa2) = split(/ /, $_);
    if($lastpair != $pair) {
	for($i = 0 ; $i < 20 ; $i++) {
	    for($j = 0 ; $j < 20 ; $j++) {
		$exptot[$i][$j] += ($first[$i]*$second[$j]/$length);
		if($i != $j) {
		    $exptot[$i][$j] += ($first[$j]*$second[$i]/$length); }
	    }
	}
	for($i = 0 ; $i < 20 ; $i++) {
	    $first[$i] = 0;
	    $second[$i] = 0;
	}
	$length = 0;
    }
    $first[$aa1]++;
    $second[$aa2]++;
    $obstot[$aa1][$aa2]++;
    if($aa1 != $aa2) {
	$obstot[$aa2][$aa1]++; }
   $lastpair = $pair;
   $length++;
}

for($i = 0 ; $i < 20 ; $i++) {
    for($j = $i ; $j < 20 ; $j++) {
	if($exptot[$i][$j] == 0) {
	    printf OUT "%s %s -----\n", idtoaa($i), idtoaa($j); }
	else {
	    $obsfinal += $obstot[$i][$j];
	    $expfinal += $exptot[$i][$j];
	    printf OUT "%s %s %.3f %2d %5.2f\n", idtoaa($i), idtoaa($j), ($obstot[$i][$j]/$exptot[$i][$j]), $obstot[$i][$j], $exptot[$i][$j]; }
	    
    }
}

print "$obsfinal vs. $expfinal\n";

sub idtoaa {

    my $aa = $_[0];               
                                   
    if($aa ==  0) { return 'A'; }
    if($aa ==  1) { return 'R'; }
    if($aa ==  2) { return 'N'; }
    if($aa ==  3) { return 'D'; }
    if($aa ==  4) { return 'C'; }
    if($aa ==  5) { return 'Q'; } 
    if($aa ==  6) { return 'E'; } 
    if($aa ==  7) { return 'G'; }
    if($aa ==  8) { return 'H'; }
    if($aa ==  9) { return 'I'; }
    if($aa == 10) { return 'L'; }
    if($aa == 11) { return 'K'; }
    if($aa == 12) { return 'M'; }
    if($aa == 13) { return 'F'; }
    if($aa == 14) { return 'P'; }
    if($aa == 15) { return 'S'; }
    if($aa == 16) { return 'T'; }
    if($aa == 17) { return 'W'; }
    if($aa == 18) { return 'Y'; }
    if($aa == 19) { return 'V'; }
    print "Error!\n";
    return 'X';
}
