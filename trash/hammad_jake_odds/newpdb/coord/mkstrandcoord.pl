open(IN, "<strand.in");
open(OUT, ">strand.coord");

$laststr = 0;
$strand = 1;
$pr = 0;
while(<IN>) {
    chomp;
    @ar = split(/ /, $_);
    if($ar[0] != $pr) {
	$pr = $ar[0];
	$laststr = 0;
	$strand = 1; }
    $str = ($ar[4] > 0) * $strand;
    if(($str == 0) && ($laststr > 0)) { $strand++; }
    printf OUT "%d %d %d %d %d %d\n", $ar[0], $str, $ar[1], $ar[2], $ar[3], $ar[4];
    $laststr = $str;
}
