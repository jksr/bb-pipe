$a = shift @ARGV;

open(IN, "<$a") || die "cant open";
open(OUT, ">$a.odds");

$length = 1;

while(<IN>) 
{
    chomp;
    @ele = split("\t", $_);
    $pair = $ele[0];
    $aa1 = $ele[1];
    $aa2 = $ele[4];
    if($lastpair != $pair) 
      {
		  #print $length,"\n";
	for($i = 0 ; $i < 20 ; $i++) 
          {
	     for($j = 0 ; $j < 20 ; $j++) 
             {
		$exptot[$i][$j] += ($first[$i]*$second[$j]/$length);
		#printf "%.2f\n",$exptot[$i][$j];
		if($i != $j) 
                  {$exptot[$i][$j] += ($first[$j]*$second[$i]/$length); }
	      }
	   }
     
	 for($i = 0 ; $i < 20 ; $i++) 
          {
	      $first[$i] = 0;
	      $second[$i] = 0;
	   }
	 $length = 0;
      }
    $first[$aa1]++;
    $second[$aa2]++;
    $obstot[$aa1][$aa2]++;
    if($aa1 != $aa2) 
        {$obstot[$aa2][$aa1]++; }
    $lastpair = $pair;
    $length++;
}

for($i = 0 ; $i < 20 ; $i++) {
    for($j = $i ; $j < 20 ; $j++) {
	if($exptot[$i][$j] == 0) {
	   # printf OUT "%s\t%s\t0\t0\t0\n", idtoaa($i), idtoaa($j);
            #printf OUT "0\n";
            printf OUT "1.00\n"; 
           }
	else {
	    $obsfinal += $obstot[$i][$j];
	    $expfinal += $exptot[$i][$j];
	    #printf OUT "%s\t%s\t%.3f\t%2d\t%5.2f\n", idtoaa($i), idtoaa($j), ($obstot[$i][$j]/$exptot[$i][$j]), $obstot[$i][$j], $exptot[$i][$j];
            printf OUT "%.2f\n",($obstot[$i][$j]/$exptot[$i][$j]);
             }
    }
}

#printf "obs:%.2f\texp%.2f\todds:%.2f\n",$obsfinal,$expfinal,$obsfinal/$expfinal;

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
