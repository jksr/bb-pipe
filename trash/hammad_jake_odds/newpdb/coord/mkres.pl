$pdb = shift @ARGV;

open(IN, "<$pdb.coord");
open(OUT, ">$pdb.res");

$i = 1;
while(<IN>) {
    chomp;
    @ar = split(/\s+/, $_);
    $res = $ar[1];
    $aa = $ar[2];
    for( ; $i != $res ; $i++) {
	print OUT "200\n"; }
    print OUT "$aa\n";
    $i++;
}

