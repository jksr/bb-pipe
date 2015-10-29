$a = shift @ARGV;

open(IN, "<$a") || die "cant open";
open(OUT, ">$a.odds");

$length = 1;

while(<IN>) {
	chomp;
	@ele = split("\t", $_);
	$pair = $ele[0];
	$aa1 = $ele[1];
	$aa2 = $ele[4];
	if($lastpair != $pair) {
		for($i = 0 ; $i < 20 ; $i++) {
			for($j = 0 ; $j < 20 ; $j++) {
				$exptot[$i][$j] += ($first[$i]*$second[$j]/$length);
				if($i != $j) {
					$exptot[$i][$j] += ($first[$j]*$second[$i]/$length);
				}
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
		$obstot[$aa2][$aa1]++;
	}
	$lastpair = $pair;
	$length++;
}

		for($i = 0 ; $i < 20 ; $i++) {
			for($j = 0 ; $j < 20 ; $j++) {
				$exptot[$i][$j] += ($first[$i]*$second[$j]/$length);
				if($i != $j) {
					$exptot[$i][$j] += ($first[$j]*$second[$i]/$length);
				}
			}
		}






for($i = 0 ; $i < 20 ; $i++) {
	for($j = $i ; $j < 20 ; $j++) {
		if($exptot[$i][$j] == 0) {
			printf OUT "1.00\n";
		}
		else {
			$obsfinal += $obstot[$i][$j];
			$expfinal += $exptot[$i][$j];
			printf OUT "%.2f\n",($obstot[$i][$j]/$exptot[$i][$j]);
		}
	}
}


printf "obs:%.2f\texp%.2f\todds:%.2f\n",$obsfinal,$expfinal,$obsfinal/$expfinal;
